// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//将漫反射颜色替换为纹理

Shader "YWY/12.Rock"
{

	Properties{
		//_Diffuse("_Diffuse Color",Color) = (1,1,1,1)
		_Texture("Texture",2D) = "white"{}
	
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
			//Application to vertex
			struct a2v{
				float4 vertex:POSITION;	//告诉unity把模型空间下的顶点坐标填充给vertex
				float3 normal:NORMAL;	//告诉unity把模型空间下的法线方向填充到normal	
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 position:SV_POSITION;
				float3 worldNormal:TEXCOORD0;	
				float3 worldVetex :TEXCOORD1;
				float2 uv:TEXCOORD2;
			};
			
			v2f vert(a2v v) {  
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);//世界空间的法线方向
				f.worldVetex  = mul(v.vertex,unity_WorldToObject).xyz;		//世界空间的顶点坐标
				f.uv = v.texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;		//传递经过缩放(* _Texture_ST.xy)和平移(+ _Texture_ST.zw)的纹理坐标给片元函数处理
				return f;
			}
			fixed4 frag(v2f f) :SV_Target{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光
				fixed3 normalDir = normalize(f.worldNormal);
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz); //对于每个顶点来说，光的位置就是光的方向，因为光是平行光

				fixed3 tempTexColor = tex2D(_Texture,f.uv.xy); //取得指定坐标点的纹理颜色

				fixed3 diffuse = _LightColor0.rgb * max(dot(normalDir,lightDir),0)*tempTexColor;		//取得漫反射颜色(纹理颜色)


				fixed3 tempColor = diffuse+ambient*tempTexColor;  //ambient*tempTexColor是为了纹理颜色与环境光相融合
				return fixed4(tempColor,1);	//color值范围0~1
			}


			ENDCG
		
		}
	}

	Fallback "Diffuse"

}