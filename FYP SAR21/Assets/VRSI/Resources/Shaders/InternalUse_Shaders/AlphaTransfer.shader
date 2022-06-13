Shader "Hidden/VRSI/AlphaTransfer"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		[HideInInspector] _AlphaTex("TextureAlpha", 2D) = "white" {}
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
			sampler2D _AlphaTex;

			//float4 _Delta;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 colAlpha = tex2D(_AlphaTex, i.uv);
				
				return fixed4(col.rgb, colAlpha.a);
			}
		ENDCG
		}
	}
}
