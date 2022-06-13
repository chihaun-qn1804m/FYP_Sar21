//Copyright Livenda Labs 2021
//VRSI SHADER LIBRARY BASE

Shader "VRSI/CameraFacing/Bare/vrsiCamFacing_MSAA_DIRECTIONAL_BARE"
{
	Properties
	{
		_MainTex("Texture Image", 2D) = "white" {}
		_Color("Color", COLOR) = (1,1,1,1)
		_WSNormals("WS Normals", 2D) = "white" {}		
		_MipBias("MipBias", Float) = -0.7		
	}
	

	SubShader
	{					
		//=================================================
		//Shadow Pass
		//=================================================

		Pass
		{
			ZWrite On			
			Cull Front

			Tags{ "LightMode" = "ShadowCaster" }
			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment frag			
					          
			uniform sampler2D _MainTex;
				
			inline float3x3 look_matrix33(float3 dir, float3 up)
			{
				float3 z = dir;
				float3 x = normalize(cross(up, z));
				float3 y = cross(z, x);
				return float3x3(
					x.x, y.x, z.x,
					x.y, y.y, z.y,
					x.z, y.z, z.z);
			}		

				struct vertexInput
				{
					float4 vertex : POSITION;
					float4 tex : TEXCOORD0;
				};

				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 tex : TEXCOORD0;
					float stIndex : TEXCOORD1;					
				};								

				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;


					float3 look = normalize(mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0)));

					if (dot(look, _WorldSpaceLightPos0.xyz) > 0)
					{	
						float3x3 rot = look_matrix33(_WorldSpaceLightPos0.xyz, float3(0, 1, 0));
						input.vertex.xyz = mul(rot, input.vertex.xyz);
						output.stIndex = 0;
					}
					else
					{						
						float3x3 rot = look_matrix33(-_WorldSpaceLightPos0.xyz, float3(0, 1, 0));
						input.vertex.xyz = mul(rot, input.vertex.xyz);
						output.stIndex = 1;
					}					

					output.pos = UnityObjectToClipPos(input.vertex);									   
					
					output.tex = input.tex;					

					return output;
				}

				float4 frag(vertexOutput input) : COLOR
				{
					float2 uv = input.tex.xy;					

					if(input.stIndex > 0)
						uv.x =  1 - input.tex.x * 0.5;
					else
						uv.x =  input.tex.x * 0.5;

					float4 col = tex2D(_MainTex, uv);					

					clip(col.a - 0.5);
					
					return col;
				}

			ENDCG
		}

		//=========================================================================
		//END OF SHADOW PASS	
		//=========================================================================		

	Pass
	{		
		Tags {"LightMode" = "ForwardBase"}

		ZWrite On		
		Cull Back		

		AlphaToMask On
		
		CGPROGRAM
		//#pragma multi_compile_fwdbase
		#pragma multi_compile_instancing
		#pragma multi_compile_fog		
		#pragma vertex vert  
		#pragma fragment frag

		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc" 

		uniform sampler2D _MainTex;
		sampler2D _WSNormals;		
		float4 _Color;		
		float _MipBias;	
	
		struct vertexInput
		{
			float4 vertex : POSITION;
			float4 tex : TEXCOORD0;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct vertexOutput
		{
			float4 pos : SV_POSITION;
			float4 tex : TEXCOORD0;
			float stIndex : TEXCOORD1;			
			float2 noiseVal : TEXCOORD2;
			float rotAngle : TEXCOORD3;					
			UNITY_FOG_COORDS(4)
			UNITY_VERTEX_INPUT_INSTANCE_ID
			UNITY_VERTEX_OUTPUT_STEREO
		};	

		inline float3x3 look_matrix33(float3 dir, float3 up)
		{
				float3 z = dir;
				float3 x = normalize(cross(up, z));
				float3 y = cross(z, x);
				return float3x3(
					x.x, y.x, z.x,
					x.y, y.y, z.y,
					x.z, y.z, z.z);
		}

		inline float3x3 zRotation3dRadians(float rad)
		{
				float s = sin(rad);
				float c = cos(rad);
				return float3x3(c, s, 0,
					-s, c, 0,
					0, 0, 1);
		}

		#define RAD2DEG 57.2957795131

	vertexOutput vert(vertexInput input)
	{		
		vertexOutput output;

		UNITY_SETUP_INSTANCE_ID(input);
		UNITY_TRANSFER_INSTANCE_ID(input, output);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

		output.noiseVal = unity_ObjectToWorld._m03_m13_m23.xz;

		float3 look = normalize(mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0)));
		look.y = 0;		

		const float3 local = float3(input.vertex.x, input.vertex.y, 0);
		const float3 offset = input.vertex.xyz - local;
		const float3 ajUp = normalize(cross(look, half3(0, 1, 0)));
		const float3 upVector = half3(0, 1, 0);
		const float3 forwardVector = -look;
		const float3 rightVector = normalize(cross(forwardVector, upVector));

		float3 position = 0;
		position += local.x * rightVector;
		position += local.y * upVector;
		position += local.z * forwardVector;

		input.vertex = float4(offset + position, 1);

		float3 fv = float3(0, 0, -1);
		
		float3 objWorldForward = -look;
		
		float objWorldHeading = atan2(-objWorldForward.x, objWorldForward.z);

		float angR = acos(dot(fv, look) / (length(fv)*length(look)));

		float angle = objWorldHeading * 360 / (2 * UNITY_PI);

		if (angle < 0) {
			angle += 360;
		}
		
		output.rotAngle =  angle * UNITY_PI / 180.0;

		output.pos = UnityObjectToClipPos(input.vertex);

		UNITY_TRANSFER_FOG(output, output.pos);
		
		output.tex = input.tex;
		if(unity_StereoEyeIndex > 0)
			output.stIndex = 0;
		else
			output.stIndex = 1;
		
		return output;
		
	}

	float3 RotateAroundYInDegrees(float4 vertex, float degrees)
	{
		float alpha = degrees;// *UNITY_PI / 180.0;
		float sina, cosa;
		sincos(alpha, sina, cosa);
		float2x2 m = float2x2(cosa, -sina, sina, cosa);
		return float4(mul(m, vertex.xz), vertex.yw).xzy;
	}
	

	float4 frag(vertexOutput input) : COLOR
	{
		UNITY_SETUP_INSTANCE_ID(input);

		float2 uv = input.tex.xy;

		uv.x = 0.5*input.stIndex + input.tex.x * 0.5;		

		float4 col =  tex2Dbias(_MainTex, float4(uv.x, uv.y, 0, _MipBias))*_Color;		

		float3 norm = tex2D(_WSNormals, uv).xyz*2.0 - 1.0;
		
		norm = RotateAroundYInDegrees(float4(norm, 1), input.rotAngle);

		half nl = max(0, dot(norm, _WorldSpaceLightPos0.xyz));

		float3 tmpcol = col.rgb;
			
		col.rgb *= ((nl + ShadeSH9(half4(norm, 1)*0.4)) * _LightColor0 + ShadeSH9(half4(norm, 1)));

		UNITY_APPLY_FOG(input.fogCoord, col);

		//clip(col.a - 0.25);

		return col;
	}

		ENDCG
	}

	
	

	






	}
}