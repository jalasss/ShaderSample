Shader "YWY/FirstShader"{
//这一整套称之为shaderLab
	Properties{
		//属性
		_Color("Color",Color)=(1,1,1,1)
		_Vector("Vector",Vector)=(1,2,3,4)
		_Int("Int",Int) = 123
		_Float("Float",Float) = 22.3
		_Range("Range",Range(1,100)) = 33
		_2D("Texture",2D) = "red"{}
		_Cude("Cube",Cube) = "white"{}		//天空盒子，天空盒子是正方体(六个面)包裹场景
		_3D("3DTexture",3D) = "black"{}
	}

	SubShader{
		//可以有多个 显卡运行效果的时候，按顺序选择可以用的第一个SubShader
	
	//至少有一个Pass块

		Pass{
			//在这里编写shader代码	HLSLPROGRAM
			CGPROGRAM
				//用CG语言编写shader代码
				//需要重新定义上面属性,属性名对应上面属性名时，默认值为上面默认值

				float4 _Color;  //任何使用float定义也可以用 half fixed定义，比如float4等同于half4，但是范围不一样，float 32位，half 16位（-6W ~ 6W）,fixed 11位(-2W ~ 2W),灵活使用定义可以节约显存
				float4 _Vector;
				float _Int;
				float _Float;
				float _Range;
				Sampler2D _2D;
				SamplerCube _Cube;
				Sampler3D _3D;

			ENDCG
			
		}
	}

	Fallback "VertexLit" //后备方案
		
}