Shader "Hidden/VRSI/colldiffAlphaMakerShader"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		[HideInInspector] _WhiteBackTex("WhiteBackTex", 2D) = "white" {}
		//[HideInInspector] _Delta ("Delta", Vector) = (0,0,0,0)
	}
	
	SubShader
	{
		Cull Off
		Lighting Off
		ZWrite Off
		
		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _WhiteBackTex;

			//float4 _Delta;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col  = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_WhiteBackTex, i.uv);

				float dist = length(col.rgb - col2.rgb);
				float alpha = 1;

				if (dist > 0) alpha = 0;
				
				return fixed4(col.rgb, alpha);
			}
		ENDCG
		}
	}
}
