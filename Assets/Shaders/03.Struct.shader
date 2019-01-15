// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "YWY/03.Struct"
{
	SubShader{
		Pass{
			CGPROGRAM			
#pragma vertex vert		//声明顶点函数 基本作用 完成顶点坐标从模型空间到剪裁空间(屏幕空间)的转换（从游戏环境转换到视野相机屏幕上）
#pragma fragment frag	//声明片元函数 基本作用 返回模型对应的屏幕上每个像素的颜色值
			
			//Application to vertex
			struct a2v{
				float4 vertex:POSITION;	//告诉unity把模型空间下的顶点坐标填充给vertex
				float4 normal:NORMAL;	//告诉unity把模型空间下的法线方向填充到normal
				float4 texcoord:TEXCOORD0;//告诉unity把第一套纹理坐标填充给texcoord
			};
			struct v2f{
				float4 position:SV_POSITION;
				float3 temp:COLOR0;		//用户自己定义，一般存储颜色
			};
			
			v2f vert(a2v v) {  
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.temp = v.normal;
				return f;
			}
			fixed4 frag(v2f f) :SV_Target{
				return fixed4(f.temp,1);	//color值范围0~1
			}


			ENDCG
		
		}
	}

	Fallback "VertexLit"

}