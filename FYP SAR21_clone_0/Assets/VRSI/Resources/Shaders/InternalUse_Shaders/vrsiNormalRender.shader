// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Hidden/vrsiNormals" {
	Properties{
		// normal map texture on the material,
		// default to dummy "flat surface" normalmap
		_BumpMap("Normal Map", 2D) = "bump" {}
		_MainTex("Texture Image", 2D) = "white" {}
	}
	SubShader{
		Pass {

		Cull Off

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	
	struct vertexInput
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float4 tangent : TANGENT;
		float2 uv : TEXCOORD0;
	};
	

	struct v2f {
		float3 worldPos : TEXCOORD0;
		// these three vectors will hold a 3x3 rotation matrix
		// that transforms from tangent to world space
		half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
		half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
		half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
		// texture coordinate for the normal map
		float2 uv : TEXCOORD4;
		float4 pos : SV_POSITION;
	};

	v2f vert(vertexInput v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		half3 wNormal = UnityObjectToWorldNormal(v.normal);
		half3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
		// compute bitangent from cross product of normal and tangent
		half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
		// output the tangent space matrix
		o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
		o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
		o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
		o.uv = v.uv;
		return o;
		/*
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.color = v.normal * 0.5 + 0.5;
		return o;
		*/
	}

	sampler2D _BumpMap;
	sampler2D _MainTex;
	sampler2D _vrsiRTtempTex;

	half4 frag(v2f i) : COLOR
	{
		// sample the normal map, and decode from the Unity encoding
				
				half4 col = tex2D(_MainTex, i.uv);
				half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
				
				
				// transform normal from tangent to world space
				half3 worldNormal;
				worldNormal.x = dot(i.tspace0, tnormal);
				worldNormal.y = dot(i.tspace1, tnormal);
				worldNormal.z = dot(i.tspace2, tnormal);

				float depth = 1 - saturate(length(i.worldPos - _WorldSpaceCameraPos)/ (_ProjectionParams.z - _ProjectionParams.y));
				// rest the same as in previous shader
				//half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				//half3 worldRefl = reflect(-worldViewDir, worldNormal);
				//half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
				//half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);
				//fixed4 c = 0;
				//c.rgb = skyColor;
				//return c;

				clip(col.a - 0.5);
				return half4 (worldNormal*0.5 + 0.5, depth);
				

	}
	ENDCG

		}
	}
		Fallback "VertexLit"

}