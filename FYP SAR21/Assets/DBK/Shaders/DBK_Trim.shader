// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Trim"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_TransitionAmount("Transition Amount", Range( 0 , 1)) = 0
		_TransitionEdgeAmount("Transition Edge Amount", Range( 0.01 , 1)) = 0
		_TrimColor("Trim Color", 2D) = "white" {}
		_MaskOverlay("Mask Overlay", Range( 0 , 1)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0
		_DamagePower("Damage Power", Range( 0 , 1)) = 0
		_DamageSmooth("Damage Smooth", Range( 0 , 200)) = 0
		_DamageMultiply("Damage Multiply", Range( 0 , 1)) = 0
		_TrimNM("Trim NM", 2D) = "bump" {}
		_TrimNMScale("Trim NM Scale", Range( 0 , 2)) = 0
		_TrimDamageNM("Trim Damage NM", 2D) = "bump" {}
		_TrimDamageNMScale("Trim Damage NM Scale", Range( 0 , 2)) = 0
		_DirtBrightness("Dirt Brightness", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_MainSmoothness("Main Smoothness", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtContrast("Dirt Contrast", Range( 0 , 1)) = 0
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_SmoothnessOverlay("Smoothness Overlay", Range( 0 , 2)) = 0
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.45
		[Toggle(_USECUSTOMCOLOR_ON)] _UseCustomColor("Use Custom Color", Float) = 0
		_CustomColor("Custom Color", Int) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.0
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv4_texcoord4;
		};

		uniform sampler2D _TrimNM;
		uniform float4 _TrimNM_ST;
		uniform float _TrimNMScale;
		uniform sampler2D _TrimDamageNM;
		uniform float4 _TrimDamageNM_ST;
		uniform float _TrimDamageNMScale;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _DamagePower;
		uniform float _DamageMultiply;
		uniform float _DamageAmount;
		uniform float _DamageSmooth;
		uniform sampler2D _TrimColor;
		uniform float4 _TrimColor_ST;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform float _TransitionAmount;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _TransitionEdgeAmount;
		uniform float _MaskOverlay;
		uniform float _DirtBrightness;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtContrast;
		uniform float4 _Color;
		uniform float _MainSmoothness;
		uniform float _SmoothnessOverlay;
		uniform float _SmoothnessDirt;
		uniform float _SmoothnessDamage;
		uniform float _Cutoff = 0.45;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TrimNM = i.uv_texcoord * _TrimNM_ST.xy + _TrimNM_ST.zw;
			float2 uv_TrimDamageNM = i.uv_texcoord * _TrimDamageNM_ST.xy + _TrimDamageNM_ST.zw;
			float2 uv_RGBAMaskA = i.uv_texcoord * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode219 = tex2D( _RGBAMaskA, uv_RGBAMaskA );
			float HeightMask8 = saturate(pow(((tex2DNode219.r*( ( pow( tex2DNode219.g , _DamagePower ) * ( ( 1.0 - i.vertexColor.g ) + ( 1.0 - _DamageMultiply ) ) ) * ( 1.0 - _DamageAmount ) ))*4)+(( ( pow( tex2DNode219.g , _DamagePower ) * ( ( 1.0 - i.vertexColor.g ) + ( 1.0 - _DamageMultiply ) ) ) * ( 1.0 - _DamageAmount ) )*2),_DamageSmooth));
			float DamageSelection212 = ( 1.0 - HeightMask8 );
			float3 lerpResult17 = lerp( UnpackScaleNormal( tex2D( _TrimNM, uv_TrimNM ), _TrimNMScale ) , UnpackScaleNormal( tex2D( _TrimDamageNM, uv_TrimDamageNM ), _TrimDamageNMScale ) , DamageSelection212);
			float3 Normals208 = lerpResult17;
			o.Normal = Normals208;
			float2 uv_TrimColor = i.uv_texcoord * _TrimColor_ST.xy + _TrimColor_ST.zw;
			float4 tex2DNode150 = tex2D( _TrimColor, uv_TrimColor );
			half2 _ColorsNumber = half2(0,-0.1);
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch350 = (float)_CustomColor;
			#else
				float staticSwitch350 = (float)_ColorSelect;
			#endif
			float2 temp_output_336_0 = ( half2( 0.015625,0 ) * staticSwitch350 );
			float2 appendResult337 = (float2(temp_output_336_0.x , 0.5));
			float2 uv_TexCoord339 = i.uv_texcoord * _ColorsNumber + appendResult337;
			float4 Color2UV3325 = tex2D( _MainTex, uv_TexCoord339 );
			float MaskRedChannel290 = tex2DNode219.b;
			float3 temp_cast_3 = (( 1.0 - MaskRedChannel290 )).xxx;
			float VertexBlue308 = i.vertexColor.b;
			float3 temp_cast_4 = (( 1.0 - VertexBlue308 )).xxx;
			float2 uv4_RGBAMaskB = i.uv4_texcoord4 * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode271 = tex2D( _RGBAMaskB, uv4_RGBAMaskB );
			float3 temp_cast_5 = (pow( ( 1.0 - tex2DNode271.g ) , _TransitionEdgeAmount )).xxx;
			float3 desaturateInitialColor295 = temp_cast_5;
			float desaturateDot295 = dot( desaturateInitialColor295, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar295 = lerp( desaturateInitialColor295, desaturateDot295.xxx, 1.0 );
			float3 CutoutEdges296 = desaturateVar295;
			float4 lerpResult288 = lerp( tex2DNode150 , Color2UV3325 , float4( ( ( 1.0 - saturate( ( 1.0 - ( ( distance( temp_cast_3 , temp_cast_4 ) - _TransitionAmount ) / max( 1.0 , 1E-05 ) ) ) ) ) + CutoutEdges296 ) , 0.0 ));
			float2 uv_TexCoord340 = i.uv_texcoord * _ColorsNumber + temp_output_336_0;
			float4 Color1UV3327 = tex2D( _MainTex, uv_TexCoord340 );
			float4 lerpResult147 = lerp( Color1UV3327 , tex2DNode150 , pow( tex2DNode150.a , _MaskOverlay ));
			float4 lerpResult149 = lerp( lerpResult288 , lerpResult147 , ( 1.0 - DamageSelection212 ));
			float2 appendResult346 = (float2(temp_output_336_0.x , 0.1));
			float2 uv_TexCoord347 = i.uv_texcoord * _ColorsNumber + appendResult346;
			float4 DirtColorUV3329 = tex2D( _MainTex, uv_TexCoord347 );
			float MaskAlphaChannel227 = tex2DNode219.a;
			float MaskBlueChannel221 = tex2DNode219.b;
			float3 temp_cast_8 = (MaskBlueChannel221).xxx;
			float VertexRed234 = i.vertexColor.r;
			float3 temp_cast_9 = (( 1.0 - VertexRed234 )).xxx;
			float temp_output_190_0 = ( ( MaskAlphaChannel227 * saturate( ( 1.0 - ( ( distance( temp_cast_8 , temp_cast_9 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) ) ) * _DirtContrast );
			float4 lerpResult194 = lerp( lerpResult149 , ( DirtColorUV3329 * MaskAlphaChannel227 * _DirtBrightness ) , temp_output_190_0);
			float4 Albedo210 = lerpResult194;
			o.Albedo = ( Albedo210 * _Color ).rgb;
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode306 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float DirtSelection248 = temp_output_190_0;
			float Smoothness260 = ( pow( tex2DNode306.r , _MainSmoothness ) * ( 1.0 - ( MaskBlueChannel221 * _SmoothnessOverlay ) ) * ( 1.0 - ( _SmoothnessDirt * DirtSelection248 ) ) * ( 1.0 - ( _SmoothnessDamage * DamageSelection212 ) ) );
			o.Smoothness = Smoothness260;
			o.Alpha = 1;
			float OpacityMask303 = ( tex2DNode271.g * tex2DNode306.b );
			clip( OpacityMask303 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-3930.604;817.0764;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;240;-395.7499,203.7377;Inherit;False;2923.793;894.2009;Comment;21;59;11;25;55;64;56;6;63;24;57;7;139;5;234;227;8;221;18;212;219;308;Damage Selection;0.7735849,0.3224024,0.1715023,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;185.3668,860.6017;Float;False;Property;_DamageMultiply;Damage Multiply;9;0;Create;True;0;0;0;False;0;False;0;0.7746754;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;11;-345.7499,664.6511;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;333;963.7505,-2980.024;Inherit;False;2254.714;813.5428;Comment;18;329;327;348;325;342;343;347;340;339;346;341;338;337;336;335;350;334;349;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;262;-384.3956,1223.487;Inherit;False;1908.081;1070.13;Comment;19;260;242;269;258;252;246;251;257;66;306;244;253;259;254;243;250;245;307;352;Smoothness;0.4123353,0.7698147,0.7735849,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;25;342.6176,695.6475;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;219;-345.3989,253.7377;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;19;0;Create;True;0;0;0;False;0;False;-1;5e4e6254e4e8db64fb7226f12b796911;5e4e6254e4e8db64fb7226f12b796911;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;349;1140.221,-2502.708;Inherit;False;Property;_CustomColor;Custom Color;26;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;334;1146.42,-2699.496;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;305;1642.33,1241.894;Inherit;False;1268.581;463.9253;;9;271;293;292;294;295;296;303;351;354;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;64;480.8796,790.9686;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;307;-331.6988,1254.068;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;23;0;Create;True;0;0;0;False;0;False;e1a2b2c9d4b4fed4f9acd14a4be621d7;e1a2b2c9d4b4fed4f9acd14a4be621d7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;55;331.0717,477.104;Float;False;Property;_DamagePower;Damage Power;7;0;Create;True;0;0;0;False;0;False;0;0.126;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;567.2586,976.9388;Float;False;Property;_DamageAmount;Damage Amount;6;0;Create;True;0;0;0;False;0;False;0;0.539;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;227;30.46864,489.1812;Inherit;False;MaskAlphaChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-26.255,612.3606;Inherit;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;756.9781,340.1616;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;238;-408.5556,-1998.773;Inherit;False;3883.394;1303.973;Comment;30;235;228;150;222;196;198;185;197;231;229;214;232;187;199;192;200;201;230;215;147;193;190;149;194;248;288;210;330;332;331;Albedo;0.8867924,0.7815846,0.07111073,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;350;1344.221,-2596.708;Inherit;False;Property;_UseCustomColor;Use Custom Color;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;271;1667.33,1248.894;Inherit;True;Property;_Drywall_PaintMask;Drywall_PaintMask;23;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;335;1270.176,-2885.885;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;63;654.4764,704.9475;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;959.7487,476.7512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;86.06342,396.8087;Inherit;False;MaskBlueChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;1198.201,-1147.458;Inherit;False;234;VertexRed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;308;-48.97522,765.2509;Inherit;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;889.5667,669.3323;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;1682.368,-1341.604;Inherit;False;227;MaskAlphaChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;1920.739,1589.819;Inherit;False;Property;_TransitionEdgeAmount;Transition Edge Amount;3;0;Create;True;0;0;0;False;0;False;0;0.60684;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;293;2004.499,1441.759;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;302;-453.2914,-3007.789;Inherit;False;1196.237;919.5989;Comment;10;284;291;282;285;274;278;297;279;298;309;Wood Edges;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;290;72.8074,221.3932;Inherit;False;MaskRedChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;336;1593.474,-2766.692;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;198;1548.614,-809.8;Inherit;False;Property;_DirtSmooth;Dirt Smooth;17;0;Create;True;0;0;0;False;0;False;0;0.314;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;1553.08,-888.16;Inherit;False;Property;_DirtRange;Dirt Range;15;0;Create;True;0;0;0;False;0;False;0;0.212;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;196;1533.041,-1147.979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;338;1639.171,-2919.006;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;139;1479.605,268.3562;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-405.0916,-2717.209;Inherit;False;290;MaskRedChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;1521.589,-1005.306;Inherit;False;221;MaskBlueChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-372.8061,-2880.531;Inherit;False;308;VertexBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;337;1804.469,-2475.118;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;1340.584,683.8811;Float;False;Property;_DamageSmooth;Damage Smooth;8;0;Create;True;0;0;0;False;0;False;0;32;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;1183.3,526.6245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;231;2046.894,-1228.218;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;294;2219.077,1457.209;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;1957.065,-2876.905;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;339;2071.636,-2493.531;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;199;2003.729,-1148.015;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;346;1806.007,-2280.184;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-206.9645,-2523.113;Inherit;False;Constant;_TransitionSmooth;Transition Smooth;30;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;274;-76.95824,-2850.498;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;295;2395.965,1463.949;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.HeightMapBlendNode;8;1718.374,473.9216;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-190.9644,-2606.112;Inherit;False;Property;_TransitionAmount;Transition Amount;2;0;Create;True;0;0;0;False;0;False;0;0.633;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;341;2105.277,-2733.204;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;425d0feaa38f0fd449bee195ba67b938;425d0feaa38f0fd449bee195ba67b938;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;232;2183.458,-1193.022;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;291;-104.7361,-2712.847;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;2370.062,-1228.15;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;2354.78,-1061.586;Inherit;False;Property;_DirtContrast;Dirt Contrast;18;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;2667.911,1470.449;Inherit;False;CutoutEdges;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;18;1999.151,472.1826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;347;2078.654,-2318.984;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;278;179.5035,-2711.178;Inherit;False;Color Mask;-1;;42;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;342;2508.384,-2628.292;Inherit;True;Property;_Texture4;Texture4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;343;2497.177,-2895.8;Inherit;True;Property;_TextureSample1;Texture Sample 1;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;2686.637,-1446.869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;276.867,-2419.164;Inherit;False;296;CutoutEdges;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;2966.563,-2640.367;Inherit;False;Color2UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;279;480.6075,-2682.317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;348;2520.655,-2394.934;Inherit;True;Property;_TextureSample5;Texture Sample 5;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;150;-22.89986,-1947.565;Inherit;True;Property;_TrimColor;Trim Color;4;0;Create;True;0;0;0;False;0;False;-1;816c45ae0964c3d42bbd916a2f565c9e;816c45ae0964c3d42bbd916a2f565c9e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;327;2965.853,-2844.535;Inherit;False;Color1UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2236.2,462.8383;Inherit;False;DamageSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;56.06473,-1647.371;Inherit;False;Property;_MaskOverlay;Mask Overlay;5;0;Create;True;0;0;0;False;0;False;0;0.6094651;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;248;2897.564,-1449.151;Inherit;False;DirtSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;187;413.1369,-1735.525;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;588.9459,-2432.555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;229;2049.71,-1512.603;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;572.2476,-1792.228;Inherit;False;327;Color1UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;2981.04,-2433.723;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;845.0194,-1527.635;Inherit;False;212;DamageSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;331;546.1193,-1900.058;Inherit;False;325;Color2UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;239;-457.0891,-572.2059;Inherit;False;1591.248;517.0002;Comment;7;208;17;213;4;2;301;299;Normals;0.08971164,0.5341466,0.9056604,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;243;75.20151,1587.826;Inherit;False;221;MaskBlueChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;53.61348,1661.105;Inherit;False;Property;_SmoothnessOverlay;Smoothness Overlay;20;0;Create;True;0;0;0;False;0;False;0;0.544616;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;82.7376,1906.107;Inherit;False;248;DirtSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;254;40.53766,2114.307;Inherit;False;212;DamageSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;41.86447,1792.413;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;21;0;Create;True;0;0;0;False;0;False;0;0.8105318;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;288;798.6725,-1950.202;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;230;2434.057,-1554.839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;43.33768,2021.208;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;22;0;Create;True;0;0;0;False;0;False;0;0.8588235;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;849.8787,-1807.43;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;215;1096.372,-1577.113;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;2214.452,-1436.383;Float;False;Property;_DirtBrightness;Dirt Brightness;14;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;332;2109.225,-1792.161;Inherit;False;329;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;2553.804,-1717.276;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;299;-391.1299,-451.763;Inherit;False;Property;_TrimNMScale;Trim NM Scale;11;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;1281.428,-1950.349;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;306;38.7877,1312.859;Inherit;True;Property;_TilingMask2_RGBA;TilingMask2_RGBA;29;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;406.0127,2061.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;413.3706,1847.74;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;90.82846,1501.161;Float;False;Property;_MainSmoothness;Main Smoothness;16;0;Create;True;0;0;0;False;0;False;0;0.478267;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;301;-424.1299,-225.763;Inherit;False;Property;_TrimDamageNMScale;Trim Damage NM Scale;13;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;428.7134,1615.905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;194;2869.097,-1937.938;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;354;1903.944,1427.693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;361.2719,-147.5471;Inherit;False;212;DamageSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;19.91063,-526.2058;Inherit;True;Property;_TrimNM;Trim NM;10;0;Create;True;0;0;0;False;0;False;-1;68cf8deba28c36148b2fdf4dd8335ef2;68cf8deba28c36148b2fdf4dd8335ef2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;269;577.315,1321.99;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;252;584.7778,1788.369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;13.1161,-291.5981;Inherit;True;Property;_TrimDamageNM;Trim Damage NM;12;0;Create;True;0;0;0;False;0;False;-1;ccf0b02cf17b2be4fa3753f1a5083c1c;ccf0b02cf17b2be4fa3753f1a5083c1c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;246;603.5139,1538.504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;258;585.5198,2014.903;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;3261.21,-1938.124;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;351;2226.965,1318.25;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;631.5342,-426.0409;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;839.4466,1469.622;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;356;4648.847,-449.4741;Inherit;False;Property;_Color;Color;27;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;211;4669.971,-237.0907;Inherit;False;210;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;303;2465.668,1288.365;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;1176.452,1551.886;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;208;884.8715,-428.4879;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;261;4667.268,-84.92728;Inherit;False;260;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;355;4873.709,-206.7638;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;352;429.2875,1469.826;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;4658.514,-158.921;Inherit;False;208;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;353;4686.78,-0.5061302;Inherit;False;352;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;4681.563,70.31781;Inherit;False;303;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5060.378,-174.5143;Float;False;True;-1;4;;0;0;Standard;DBK/Trim;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.45;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;24;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;11;2
WireConnection;64;0;59;0
WireConnection;227;0;219;4
WireConnection;234;0;11;1
WireConnection;56;0;219;2
WireConnection;56;1;55;0
WireConnection;350;1;334;0
WireConnection;350;0;349;0
WireConnection;271;0;307;0
WireConnection;63;0;25;0
WireConnection;63;1;64;0
WireConnection;24;0;56;0
WireConnection;24;1;63;0
WireConnection;221;0;219;3
WireConnection;308;0;11;3
WireConnection;57;0;6;0
WireConnection;293;0;271;2
WireConnection;290;0;219;3
WireConnection;336;0;335;0
WireConnection;336;1;350;0
WireConnection;196;0;235;0
WireConnection;139;0;219;1
WireConnection;337;0;336;0
WireConnection;7;0;24;0
WireConnection;7;1;57;0
WireConnection;231;0;228;0
WireConnection;294;0;293;0
WireConnection;294;1;292;0
WireConnection;340;0;338;0
WireConnection;340;1;336;0
WireConnection;339;0;338;0
WireConnection;339;1;337;0
WireConnection;199;1;196;0
WireConnection;199;3;222;0
WireConnection;199;4;197;0
WireConnection;199;5;198;0
WireConnection;346;0;336;0
WireConnection;274;0;309;0
WireConnection;295;0;294;0
WireConnection;8;0;139;0
WireConnection;8;1;7;0
WireConnection;8;2;5;0
WireConnection;232;0;231;0
WireConnection;291;0;284;0
WireConnection;200;0;232;0
WireConnection;200;1;199;0
WireConnection;296;0;295;0
WireConnection;18;0;8;0
WireConnection;347;0;338;0
WireConnection;347;1;346;0
WireConnection;278;1;274;0
WireConnection;278;3;291;0
WireConnection;278;4;282;0
WireConnection;278;5;285;0
WireConnection;342;0;341;0
WireConnection;342;1;339;0
WireConnection;343;0;341;0
WireConnection;343;1;340;0
WireConnection;190;0;200;0
WireConnection;190;1;201;0
WireConnection;325;0;342;0
WireConnection;279;0;278;0
WireConnection;348;0;341;0
WireConnection;348;1;347;0
WireConnection;327;0;343;0
WireConnection;212;0;18;0
WireConnection;248;0;190;0
WireConnection;187;0;150;4
WireConnection;187;1;185;0
WireConnection;298;0;279;0
WireConnection;298;1;297;0
WireConnection;229;0;228;0
WireConnection;329;0;348;0
WireConnection;288;0;150;0
WireConnection;288;1;331;0
WireConnection;288;2;298;0
WireConnection;230;0;229;0
WireConnection;147;0;330;0
WireConnection;147;1;150;0
WireConnection;147;2;187;0
WireConnection;215;0;214;0
WireConnection;193;0;332;0
WireConnection;193;1;230;0
WireConnection;193;2;192;0
WireConnection;149;0;288;0
WireConnection;149;1;147;0
WireConnection;149;2;215;0
WireConnection;306;0;307;0
WireConnection;257;0;259;0
WireConnection;257;1;254;0
WireConnection;251;0;250;0
WireConnection;251;1;253;0
WireConnection;244;0;243;0
WireConnection;244;1;245;0
WireConnection;194;0;149;0
WireConnection;194;1;193;0
WireConnection;194;2;190;0
WireConnection;354;0;306;3
WireConnection;4;5;299;0
WireConnection;269;0;306;1
WireConnection;269;1;66;0
WireConnection;252;0;251;0
WireConnection;2;5;301;0
WireConnection;246;0;244;0
WireConnection;258;0;257;0
WireConnection;210;0;194;0
WireConnection;351;0;271;2
WireConnection;351;1;354;0
WireConnection;17;0;4;0
WireConnection;17;1;2;0
WireConnection;17;2;213;0
WireConnection;242;0;269;0
WireConnection;242;1;246;0
WireConnection;242;2;252;0
WireConnection;242;3;258;0
WireConnection;303;0;351;0
WireConnection;260;0;242;0
WireConnection;208;0;17;0
WireConnection;355;0;211;0
WireConnection;355;1;356;0
WireConnection;352;0;306;4
WireConnection;0;0;355;0
WireConnection;0;1;209;0
WireConnection;0;4;261;0
WireConnection;0;10;304;0
ASEEND*/
//CHKSM=46A98E0517CEFF29F7464FE3A1D47BAF4F74E0D3