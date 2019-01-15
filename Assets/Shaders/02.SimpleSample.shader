// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "YWY/02.SimpleSamples"{
	SubShader{
		Pass{
			CGPROGRAM			
#pragma vertex vert		//声明顶点函数 基本作用 完成顶点坐标从模型空间到剪裁空间(屏幕空间)的转换（从游戏环境转换到视野相机屏幕上）
#pragma fragment frag	//声明片元函数 基本作用 返回模型对应的屏幕上每个像素的颜色值
			float4 vert(float4 v :POSITION) :SV_POSITION{  //通过语义告诉系统，我这个参数是干嘛的，比如POSITION是告诉系统我需要顶点坐标，SV_POSITION这个语义用来解释说明返回值，意思是返回值是剪裁空间下的顶点坐标
			
				return UnityObjectToClipPos(v);
			}
			fixed4 frag() :SV_Target{
				return fixed4(1,0.5,1,1);	//color值范围0~1
			
			}


			ENDCG
		
		}
	}

	Fallback "VertexLit"

}