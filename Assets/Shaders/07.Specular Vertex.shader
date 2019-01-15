// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//逐片元漫反射

Shader "YWY/07.Specular Vertex"
{

	Properties{
		_Diffuse("_Diffuse Color",Color) = (1,1,1,1)
		_Specular("Specular Color",Color) = (1,1,1,1)
		_Gross("Gloss",Range(8,200)) = 10
	}
	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert		//声明顶点函数 基本作用 完成顶点坐标从模型空间到剪裁空间(屏幕空间)的转换（从游戏环境转换到视野相机屏幕上）
			#pragma fragment frag	//声明片元函数 基本作用 返回模型对应的屏幕上每个像素的颜色值

			fixed4 _Diffuse;
			fixed4 _Specular;
			half _Gross;
			//Application to vertex
			struct a2v{
				float4 vertex:POSITION;	//告诉unity把模型空间下的顶点坐标填充给vertex
				float3 normal:NORMAL;	//告诉unity把模型空间下的法线方向填充到normal				
			};
			struct v2f{
				float4 position:SV_POSITION;
				float3 color:COLOR0;		//用户自己定义，一般存储颜色
			};
			
			v2f vert(a2v v) {  
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光
				fixed3 normalDir = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz); //对于每个顶点来说，光的位置就是光的方向，因为光是平行光
				fixed3 diffuse = _LightColor0.rgb * max(dot(normalDir,lightDir),0)*_Diffuse.rgb;		//取得漫反射颜色


				fixed3 reflectDir = normalize(reflect(-lightDir,normalDir));		//取得反射光方向
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(v.vertex,unity_WorldToObject).xyz);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb*pow(max(dot(reflectDir,viewDir),0),_Gross);

				f.color = diffuse+ambient+ specular;
				return f;
			}
			fixed4 frag(v2f f) :SV_Target{
				return fixed4(f.color,1);	//color值范围0~1
			}


			ENDCG
		
		}
	}

	Fallback "Diffuse"

}