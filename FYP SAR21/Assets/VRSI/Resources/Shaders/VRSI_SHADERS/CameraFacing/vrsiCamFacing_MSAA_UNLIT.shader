//Copyright Livenda Labs 2021
//VRSI SHADER LIBRARY BASE

Shader "VRSI/CameraFacing/vrsiCamFacing_MSAA_UNLIT"
{
	Properties
	{
		_MainTex("Texture Image", 2D) = "white" {}
		_Color("Color", COLOR) = (1,1,1,1)
		_WSNormals("WS Normals", 2D) = "white" {}
		_Color1("Color1", COLOR) = (1,1,1,1)
		_Color2("Color2", COLOR) = (1,1,1,1)
		_NoiseTex("Noise Image", 2D) = "white" {}
		_ScaleX("Scale X", Float) = 1.0
		_OffsetY("Offset Y", Float) = 0.5
		_MipBias("MipBias", Float) = -0.7
		_WindTrunkStrength("WindTrunk Strength", Float) = 0
		_WindTrunkSpeed("WindTrunk Speed", Float) = 1
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
		sampler2D _NoiseTex;
		uniform float _ScaleX; 
		float _OffsetY;		
		float4 _Color;
		float4 _Color1;
		float4 _Color2;
		float _MipBias;		
		float _WindTrunkStrength;
		float _WindTrunkSpeed;
	
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
			float3 col : TEXCOORD2;
			float2 noiseVal : TEXCOORD3;
			float rotAngle : TEXCOORD4;
			float4 posWorld : TEXCOORD5;		
			UNITY_FOG_COORDS(6)
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

		//--------------------------

		if (input.tex.y > _OffsetY)
		{
			float3 worldPos = mul(unity_ObjectToWorld, input.vertex);
			float noise = tex2Dlod(_NoiseTex, float4(worldPos.xz*_ScaleX, 0, 0)).r;
			float4 col = lerp(_Color1, _Color2, noise);
			output.col = col;

			input.vertex.x += sin(_Time.y * 0.1*_WindTrunkSpeed + (output.noiseVal.x + output.noiseVal.y) * 100)*0.01*_WindTrunkStrength;
			input.vertex.x += sin(_Time.y * 0.6*_WindTrunkSpeed + (output.noiseVal.x + output.noiseVal.y) * 200)*0.007*_WindTrunkStrength;
			input.vertex.x += sin(_Time.y * 1.2*_WindTrunkSpeed + (output.noiseVal.x + output.noiseVal.y) * 30)*0.003*_WindTrunkStrength;
			input.vertex.x += sin(_Time.y * 2.3*_WindTrunkSpeed + worldPos.xz * 80)*0.004*_WindTrunkStrength;			

		}
		else
		{
			output.col = float4(1, 1, 1, 1);
		}

		//--------------------------

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

		// object's forward vector (local +Z direction)
		float3 objWorldForward = -look;
		//get objects current Y rotation from its rotation matrix in radians
		float objWorldHeading = atan2(-objWorldForward.x, objWorldForward.z);

		float angR = acos(dot(fv, look) / (length(fv)*length(look)));

		float angle = objWorldHeading * 360 / (2 * UNITY_PI);

		if (angle < 0) {
			angle += 360;
		}
		
		output.rotAngle =  angle * UNITY_PI / 180.0;		

		output.posWorld = mul(unity_ObjectToWorld, input.vertex); 					  

		output.pos = UnityObjectToClipPos(input.vertex);

		UNITY_TRANSFER_FOG(output, output.pos);

		//output.pos = input.vertex;
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

	float3x3 YRotationMatrix(float degrees)
	{
		float alpha = degrees;// *UNITY_PI / 180.0;
		float sina, cosa;
		sincos(alpha, sina, cosa);
		return float3x3(
			cosa, 0, -sina,
			0, 1, 0,
			sina, 0, cosa);
	}

	float4 frag(vertexOutput input) : COLOR
	{
		UNITY_SETUP_INSTANCE_ID(input);

		float2 uv = input.tex.xy;

		uv.x = 0.5*input.stIndex + input.tex.x * 0.5;		

		float4 col =  tex2Dbias(_MainTex, float4(uv.x, uv.y, 0, _MipBias))*_Color;

		col.rgb *=  input.col.rgb;

		UNITY_APPLY_FOG(input.fogCoord, col);
		//clip(col.a - 0.25);
		return col;
	}

		ENDCG
	}

	
	

	






	}
}