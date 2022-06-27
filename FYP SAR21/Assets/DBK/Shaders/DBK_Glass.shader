// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Glass"
{
	Properties
	{
		_GlassSmoothness("Glass Smoothness", Range( 0 , 1)) = 0
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_ColorTheme("Color Theme", 2D) = "white" {}
		_DirtSmoothness("Dirt Smoothness", Range( 0 , 1)) = 0
		_Glass_Normals("Glass_Normals", 2D) = "bump" {}
		_GlassBrigthness("Glass Brigthness", Range( 0 , 1)) = 0
		_GlassMask("Glass Mask", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Glass_Normals;
		uniform float4 _Glass_Normals_ST;
		uniform sampler2D _GlassMask;
		uniform float4 _GlassMask_ST;
		uniform sampler2D _ColorTheme;
		uniform int _ColorSelect;
		uniform float _GlassBrigthness;
		uniform float4 _Color;
		uniform float _GlassSmoothness;
		uniform float _DirtSmoothness;
		uniform float _DirtOpacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Glass_Normals = i.uv_texcoord * _Glass_Normals_ST.xy + _Glass_Normals_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Glass_Normals, uv_Glass_Normals ) );
			float2 uv_GlassMask = i.uv_texcoord * _GlassMask_ST.xy + _GlassMask_ST.zw;
			float4 tex2DNode65 = tex2D( _GlassMask, uv_GlassMask );
			float2 uv_TexCoord55 = i.uv_texcoord * half2( 0,-0.1 ) + ( half2( 0.015625,0 ) * _ColorSelect );
			float4 ColorSelection63 = tex2D( _ColorTheme, uv_TexCoord55 );
			o.Albedo = ( ( tex2DNode65.r * ColorSelection63 * _GlassBrigthness ) * _Color ).rgb;
			float temp_output_11_0 = ( tex2DNode65.b * ( 1.0 - ( tex2DNode65.r * _DirtOpacity ) ) );
			o.Smoothness = ( _GlassSmoothness * ( _DirtSmoothness * tex2DNode65.r * temp_output_11_0 ) );
			o.Alpha = temp_output_11_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;419.788;1933.483;2.520031;True;False
Node;AmplifyShaderEditor.CommentaryNode;49;-948.3525,-1672.883;Inherit;False;2080.08;813.5428;Comment;8;63;60;56;55;53;52;51;50;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;50;-742.0428,-1292.712;Inherit;False;Property;_ColorSelect;ColorSelect;2;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.Vector2Node;51;-816.5598,-1578.744;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-493.2626,-1459.551;Inherit;False;2;2;0;FLOAT2;0,0;False;1;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;52;-432.5655,-1606.863;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-8.672998,-1599.764;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;56;-8.107996,-1452.065;Inherit;True;Property;_ColorTheme;Color Theme;4;0;Create;True;0;0;0;False;0;False;cd4b5d8aeef219c4bafd11ce2d4d5525;cd4b5d8aeef219c4bafd11ce2d4d5525;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;14;-444.726,847.6392;Inherit;False;Property;_DirtOpacity;Dirt Opacity;3;0;Create;True;0;0;0;False;0;False;0;0.631;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-467.2832,-285.9327;Inherit;True;Property;_GlassMask;Glass Mask;8;0;Create;True;0;0;0;False;0;False;-1;bfbde71c1a80a6f448fd18fc39306db8;bfbde71c1a80a6f448fd18fc39306db8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;416.4377,-1599.659;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-71.62408,705.7544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;100.2964,633.9305;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;815.8384,-1457.274;Inherit;False;ColorSelection;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;433.4231,-163.8965;Inherit;False;63;ColorSelection;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;447.5928,510.9402;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;503.1842,-39.81622;Inherit;False;Property;_GlassBrigthness;Glass Brigthness;7;0;Create;True;0;0;0;False;0;False;0;0.573;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-472.0815,275.9457;Inherit;False;Property;_DirtSmoothness;Dirt Smoothness;5;0;Create;True;0;0;0;False;0;False;0;0.956;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-489.3229,136.6169;Inherit;False;Property;_GlassSmoothness;Glass Smoothness;0;0;Create;True;0;0;0;False;0;False;0;0.901;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;829.4478,-286.2946;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;263.542,224.5935;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;69;1214.824,-515.3007;Inherit;False;Property;_Color;Color;9;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;923.4283,392.6332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;1424.044,-273.0386;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;33;1332.136,482.9443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;470.1093,129.5745;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;824.5204,-63.31698;Inherit;True;Property;_Glass_Normals;Glass_Normals;6;0;Create;True;0;0;0;False;0;False;-1;9297249ecc862d24d9d18b58ff475d1d;9297249ecc862d24d9d18b58ff475d1d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1658.978,25.82345;Float;False;True;-1;2;;0;0;Standard;DBK/Glass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;51;0
WireConnection;53;1;50;0
WireConnection;55;0;52;0
WireConnection;55;1;53;0
WireConnection;60;0;56;0
WireConnection;60;1;55;0
WireConnection;16;0;65;1
WireConnection;16;1;14;0
WireConnection;12;0;16;0
WireConnection;63;0;60;0
WireConnection;11;0;65;3
WireConnection;11;1;12;0
WireConnection;25;0;65;1
WireConnection;25;1;48;0
WireConnection;25;2;64;0
WireConnection;19;0;20;0
WireConnection;19;1;65;1
WireConnection;19;2;11;0
WireConnection;68;0;25;0
WireConnection;68;1;69;0
WireConnection;33;0;11;0
WireConnection;18;0;2;0
WireConnection;18;1;19;0
WireConnection;0;0;68;0
WireConnection;0;1;34;0
WireConnection;0;4;18;0
WireConnection;0;9;33;0
ASEEND*/
//CHKSM=B1C181DA163A64934DE109968449763F689B3659