// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//将漫反射颜色替换为纹理

Shader "YWY/13.Rock Normal map"
{

	Properties{
		//_Diffuse("_Diffuse Color",Color) = (1,1,1,1)
		_Texture("Texture",2D) = "white"{}
		_NormalMap("Normal Map",2D) = "bump"{}
		_BumpScale("Bump Scale",float) = 1
	}
	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert		//声明顶点函数 基本作用 完成顶点坐标从模型空间到剪裁空间(屏幕空间)的转换（从游戏环境转换到视野相机屏幕上）
			#pragma fragment frag	//声明片元函数 基本作用 返回模型对应的屏幕上每个像素的颜色值

			sampler2D _Texture;	//纹理
			float4 _Texture_ST;  //前面名字必须与Texture名字一致,表示纹理的缩放和位移

			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			float _BumpScale;

			//Application to vertex
			struct a2v{
				float4 vertex:POSITION;	//告诉unity把模型空间下的顶点坐标填充给vertex
				//切线空间的确定是通过（存储到模型里面的）法线和（存储到模型里面的）切线确定的
				float3 normal:NORMAL;	//告诉unity把模型空间下的法线方向填充到normal	
				float4 tangent:TANGENT;	//tangent.w是用来确定切线空间中坐标轴的方向的（和法线必须是固定写法）
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 position:SV_POSITION;
			//float3 worldNormal:TEXCOORD0;	
				float3 lightDir:TEXCOORD0;//切线空间下 平行光的方向
				float3 worldVetex :TEXCOORD1;
				float4 uv:TEXCOORD2;		//xy用来存储MainText的纹理坐标 zw用来存储NormalMap的纹理坐标
			};
			
			v2f vert(a2v v) {  
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
			//	f.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);//世界空间的法线方向
				f.worldVetex  = mul(v.vertex,unity_WorldToObject).xyz;		//世界空间的顶点坐标
				f.uv.xy = v.texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;		//传递经过缩放(* _Texture_ST.xy)和平移(+ _Texture_ST.zw)的纹理坐标给片元函数处理
				f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;		

				TANGENT_SPACE_ROTATION; //调用这个后，会得到一个矩阵 rotation 这个矩阵用来把模型空间下的方向转换成切线空间下的方向（保证a2v 的名字是v,保证里面有normal和tangent,名字也不能变）

				//ObjSpaceLightDir(v.vertex); //得到模型空间下得平行光方向
				f.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));
				return f;
			}
			//从法线贴图里取得的法线方向是在切线空间下的
			fixed4 frag(v2f f) :SV_Target{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光
			//	fixed3 normalDir = normalize(f.worldNormal);
			    fixed4 normalColor = tex2D(_NormalMap,f.uv.zw);//取得指定坐标点的法线颜色	
			//	fixed3 tangentNormal = normalize(normalColor.xyz*2 -1); //算出真正法线方向在切线空间下的值(一般不使用这种方法)
				fixed3 tangentNormal = UnpackNormal(normalColor);		//替代上面方法
				tangentNormal.xy = tangentNormal.xy*_BumpScale;
				tangentNormal = normalize(tangentNormal);
				fixed3 lightDir = normalize(f.lightDir); 

				fixed3 tempTexColor = tex2D(_Texture,f.uv.xy); //取得指定坐标点的纹理颜色

				fixed3 diffuse = _LightColor0.rgb * max(dot(tangentNormal,lightDir),0)*tempTexColor;		//取得漫反射颜色(纹理颜色)


				fixed3 tempColor = diffuse+ambient*tempTexColor;  //ambient*tempTexColor是为了纹理颜色与环境光相融合
				return fixed4(tempColor,1);	//color值范围0~1
			}


			ENDCG
		
		}
	}

	Fallback "Diffuse"

}