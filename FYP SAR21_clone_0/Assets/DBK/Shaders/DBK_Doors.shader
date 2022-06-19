// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Doors"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_WoodGrain("Wood Grain", Range( 0 , 1)) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_TransitionAmount("Transition Amount", Range( 0 , 1)) = 0
		_TransitionEdgeAmount("Transition Edge Amount", Range( 0.01 , 1)) = 0
		_DoorsColor("Doors Color", 2D) = "white" {}
		_MaskOverlay("Mask Overlay", Range( 0.1 , 1)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0
		_DamagePower("Damage Power", Range( 0 , 0.1)) = 0
		_DamageSmooth("Damage Smooth", Range( 0 , 200)) = 0
		_DamageMultiply("Damage Multiply", Range( 0 , 1)) = 0
		_DoorNM("Door NM", 2D) = "bump" {}
		_DoorsNMScale("Doors NM Scale", Range( 0 , 2)) = 0
		_DoorDamageNM("Door Damage NM", 2D) = "bump" {}
		_DoorsDamageNMScale("Doors Damage NM Scale", Range( 0 , 2)) = 0
		_DirtBrightness("Dirt Brightness", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_MainSmoothness("Main Smoothness", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtContrast("Dirt Contrast", Range( 0 , 2)) = 0
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_SmoothnessOverlay("Smoothness Overlay", Range( 0 , 2)) = 0
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.45
		_CustomColor("Custom Color", Int) = 0
		[Toggle(_USECUSTOMCOLOR_ON)] _UseCustomColor("Use Custom Color", Float) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.5
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv4_texcoord4;
			float2 uv3_texcoord3;
		};

		uniform sampler2D _DoorNM;
		uniform float4 _DoorNM_ST;
		uniform float _DoorsNMScale;
		uniform sampler2D _DoorDamageNM;
		uniform float4 _DoorDamageNM_ST;
		uniform float _DoorsDamageNMScale;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _DamagePower;
		uniform float _DamageMultiply;
		uniform float _DamageAmount;
		uniform float _DamageSmooth;
		uniform sampler2D _DoorsColor;
		uniform float4 _DoorsColor_ST;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform float _TransitionAmount;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _TransitionEdgeAmount;
		uniform float _WoodGrain;
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
			float2 uv_DoorNM = i.uv_texcoord * _DoorNM_ST.xy + _DoorNM_ST.zw;
			float2 uv_DoorDamageNM = i.uv_texcoord * _DoorDamageNM_ST.xy + _DoorDamageNM_ST.zw;
			float2 uv_RGBAMaskA = i.uv_texcoord * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode219 = tex2D( _RGBAMaskA, uv_RGBAMaskA );
			float saferPower56 = abs( tex2DNode219.b );
			float HeightMask8 = saturate(pow(((tex2DNode219.g*( ( pow( saferPower56 , _DamagePower ) * ( ( 1.0 - i.vertexColor.g ) + ( 1.0 - _DamageMultiply ) ) ) * ( 1.0 - _DamageAmount ) ))*4)+(( ( pow( saferPower56 , _DamagePower ) * ( ( 1.0 - i.vertexColor.g ) + ( 1.0 - _DamageMultiply ) ) ) * ( 1.0 - _DamageAmount ) )*2),_DamageSmooth));
			float DamageSelection212 = ( 1.0 - HeightMask8 );
			float3 lerpResult17 = lerp( UnpackScaleNormal( tex2D( _DoorNM, uv_DoorNM ), _DoorsNMScale ) , UnpackScaleNormal( tex2D( _DoorDamageNM, uv_DoorDamageNM ), _DoorsDamageNMScale ) , DamageSelection212);
			float3 Normals208 = lerpResult17;
			o.Normal = Normals208;
			float2 uv_DoorsColor = i.uv_texcoord * _DoorsColor_ST.xy + _DoorsColor_ST.zw;
			float4 tex2DNode150 = tex2D( _DoorsColor, uv_DoorsColor );
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch376 = (float)_CustomColor;
			#else
				float staticSwitch376 = (float)_ColorSelect;
			#endif
			float2 appendResult378 = (float2(( staticSwitch376 * 0.015625 ) , -0.33333));
			float2 uv4_TexCoord380 = i.uv4_texcoord4 + appendResult378;
			float4 Color2UV3325 = tex2D( _MainTex, uv4_TexCoord380 );
			float MaskBlueChannel221 = tex2DNode219.b;
			float3 temp_cast_2 = (( 1.0 - MaskBlueChannel221 )).xxx;
			float VertexBlue308 = i.vertexColor.b;
			float3 temp_cast_3 = (( 1.0 - VertexBlue308 )).xxx;
			float2 uv3_RGBAMaskB = i.uv3_texcoord3 * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode271 = tex2D( _RGBAMaskB, uv3_RGBAMaskB );
			float3 temp_cast_4 = (pow( ( 1.0 - tex2DNode271.g ) , _TransitionEdgeAmount )).xxx;
			float3 desaturateInitialColor295 = temp_cast_4;
			float desaturateDot295 = dot( desaturateInitialColor295, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar295 = lerp( desaturateInitialColor295, desaturateDot295.xxx, 1.0 );
			float3 CutoutEdges296 = desaturateVar295;
			float4 lerpResult288 = lerp( tex2DNode150 , Color2UV3325 , float4( ( ( 1.0 - saturate( ( 1.0 - ( ( distance( temp_cast_2 , temp_cast_3 ) - _TransitionAmount ) / max( 0.8514541 , 1E-05 ) ) ) ) ) + CutoutEdges296 ) , 0.0 ));
			float2 uv4_TexCoord385 = i.uv4_texcoord4 + ( half2( 0.015625,0 ) * staticSwitch376 );
			float4 Color1UV3327 = tex2D( _MainTex, uv4_TexCoord385 );
			float MaskRedChannelX369 = tex2DNode219.a;
			float clampResult393 = clamp( ( MaskRedChannelX369 + _WoodGrain ) , 0.0 , 1.0 );
			float4 lerpResult147 = lerp( ( Color1UV3327 * clampResult393 ) , tex2DNode150 , pow( tex2DNode150.a , _MaskOverlay ));
			float4 lerpResult149 = lerp( lerpResult288 , lerpResult147 , ( 1.0 - DamageSelection212 ));
			float MaskAlphaChannelX227 = tex2DNode219.r;
			float3 temp_cast_6 = (MaskBlueChannel221).xxx;
			float VertexRed234 = i.vertexColor.r;
			float3 temp_cast_7 = (( 1.0 - VertexRed234 )).xxx;
			float temp_output_190_0 = ( ( MaskAlphaChannelX227 * saturate( ( 1.0 - ( ( distance( temp_cast_6 , temp_cast_7 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) ) ) * _DirtContrast );
			float4 lerpResult194 = lerp( lerpResult149 , ( Color2UV3325 * MaskAlphaChannelX227 * _DirtBrightness ) , temp_output_190_0);
			float4 Albedo210 = lerpResult194;
			o.Albedo = ( Albedo210 * _Color ).rgb;
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode306 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float Metallic352 = tex2DNode306.a;
			o.Metallic = Metallic352;
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
2560;133;1920;1132;-3906.731;1046.299;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;240;-395.7499,203.7377;Inherit;False;2923.793;894.2009;Comment;23;59;11;25;55;64;56;6;63;24;57;7;139;5;234;8;221;18;212;219;308;369;370;368;Damage Selection;0.7735849,0.3224024,0.1715023,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;195.3668,864.6017;Float;False;Property;_DamageMultiply;Damage Multiply;10;0;Create;True;0;0;0;False;0;False;0;0.799;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;11;-345.7499,664.6511;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;262;-384.3956,1223.487;Inherit;False;1908.081;1070.13;Comment;19;260;242;269;258;252;246;251;257;66;306;244;253;259;254;243;250;245;307;352;Smoothness;0.4123353,0.7698147,0.7735849,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;372;850.5073,-3063.549;Inherit;False;2579.244;1004.779;Comment;20;390;389;388;377;379;380;329;391;325;327;381;386;378;385;384;382;376;375;349;334;UV5 Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;305;1642.33,1241.894;Inherit;False;1268.581;463.9253;;8;271;293;292;294;295;296;303;351;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;219;-360.5241,247.0293;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;20;0;Create;True;0;0;0;False;0;False;-1;5e4e6254e4e8db64fb7226f12b796911;a7856712ad4a5604aafb25d0812d8915;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;349;898.7368,-2433.369;Inherit;False;Property;_CustomColor;Custom Color;26;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;334;882.3369,-2924.837;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.OneMinusNode;64;480.8796,790.9686;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;342.6176,695.6475;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;365.0717,478.104;Float;False;Property;_DamagePower;Damage Power;8;0;Create;True;0;0;0;False;0;False;0;0.0624;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;307;-331.6988,1254.068;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;21;0;Create;True;0;0;0;False;0;False;e1a2b2c9d4b4fed4f9acd14a4be621d7;6cdc0a8c9d8459f4e8d9edab9ffae90c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;382;1562.581,-3018.736;Half;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-28.255,639.3606;Inherit;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;227;62.46864,85.18121;Inherit;False;MaskAlphaChannelX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;238;-408.5556,-1998.773;Inherit;False;3883.394;1303.973;Comment;35;235;228;150;222;196;198;185;197;231;229;214;232;187;199;192;200;201;230;215;147;193;190;149;194;248;288;210;330;332;360;361;331;371;392;393;Albedo;0.8867924,0.7815846,0.07111073,1;0;0
Node;AmplifyShaderEditor.SamplerNode;271;1673.33,1267.894;Inherit;True;Property;_Drywall_PaintMask;Drywall_PaintMask;23;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;376;1168.059,-2760.022;Inherit;False;Property;_UseCustomColor;Use Custom Color;27;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;368;66.86615,265.6452;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;666.8174,710.2365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;1451.549,-2499.903;Inherit;False;Constant;_3Row;3 Row;33;0;Create;True;0;0;0;False;0;False;0.015625;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;662.7362,311.6304;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;567.2586,976.9388;Float;False;Property;_DamageAmount;Damage Amount;7;0;Create;True;0;0;0;False;0;False;0;0.457;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;308;-33.97522,811.2509;Inherit;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;1805.806,-2637.952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;1687.368,-1382.604;Inherit;False;227;MaskAlphaChannelX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;81.74672,424.006;Inherit;False;MaskBlueChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;889.5667,669.3323;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;1261.201,-1155.458;Inherit;False;234;VertexRed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;1990.101,-3014.848;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;949.1707,385.0752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;1920.739,1589.819;Inherit;False;Property;_TransitionEdgeAmount;Transition Edge Amount;4;0;Create;True;0;0;0;False;0;False;0;0.798;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;370;1425.357,279.186;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;293;2004.499,1441.759;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;302;-453.2914,-3007.789;Inherit;False;1196.237;919.5989;Comment;10;284;291;282;285;274;278;297;279;298;309;Wood Edges;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;198;1563.614,-810.8;Inherit;False;Property;_DirtSmooth;Dirt Smooth;18;0;Create;True;0;0;0;False;0;False;0;0.1360036;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;231;2046.894,-1228.218;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;196;1534.175,-1149.113;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-369.8061,-2887.531;Inherit;False;308;VertexBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;1340.584,683.8811;Float;False;Property;_DamageSmooth;Damage Smooth;9;0;Create;True;0;0;0;False;0;False;0;85.2;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;1551.708,-1015.938;Inherit;False;221;MaskBlueChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;1186.826,521.3355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;1553.08,-888.16;Inherit;False;Property;_DirtRange;Dirt Range;16;0;Create;True;0;0;0;False;0;False;0;0.4203857;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;378;2002.036,-2524.21;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.33333;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-366.0916,-2728.209;Inherit;False;221;MaskBlueChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;385;2265.748,-3029.549;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.09,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;379;2208.013,-2816.295;Inherit;True;Property;_MainTex;Color Theme;2;0;Create;False;0;0;0;False;0;False;bf84d265e341525459ab1fd8a003c547;7d698245abe6a094b9c4b38c9b568d9e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;369;81.73267,504.6322;Inherit;False;MaskRedChannelX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;139;1506.27,289.3768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;294;2219.077,1457.209;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;291;-104.7361,-2712.847;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;232;2183.458,-1193.022;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;295;2395.965,1463.949;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-190.9644,-2606.112;Inherit;False;Property;_TransitionAmount;Transition Amount;3;0;Create;True;0;0;0;False;0;False;0;0.4295977;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;199;2003.729,-1148.015;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;386;2685.162,-2916.177;Inherit;True;Property;_TextureSample2;Texture Sample 2;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;371;-204.7338,-1369.487;Inherit;False;369;MaskRedChannelX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-190.9645,-2523.113;Inherit;False;Constant;_TransitionSmooth;Transition Smooth;30;0;Create;True;0;0;0;False;0;False;0.8514541;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;360;-175.9385,-1127.271;Inherit;True;Property;_WoodGrain;Wood Grain;1;0;Create;True;0;0;0;False;0;False;0;0.619043;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;8;1718.374,473.9216;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;274;-76.95824,-2850.498;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;380;2259.854,-2560.064;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;2370.062,-1228.15;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;2354.78,-1061.586;Inherit;False;Property;_DirtContrast;Dirt Contrast;19;0;Create;True;0;0;0;False;0;False;0;1.233938;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;278;179.5035,-2711.178;Inherit;False;Color Mask;-1;;42;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;1999.151,472.1826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;392;134.0302,-1369.888;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;327;3090.985,-2913.923;Inherit;False;Color1UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;2667.911,1470.449;Inherit;False;CutoutEdges;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;381;2663.14,-2684.794;Inherit;True;Property;_TextureSample0;Texture Sample 0;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2239.653,477.2038;Inherit;False;DamageSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;274.867,-2409.164;Inherit;False;296;CutoutEdges;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;185;62.06473,-1683.371;Inherit;False;Property;_MaskOverlay;Mask Overlay;6;0;Create;True;0;0;0;False;0;False;0;0.682353;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;279;458.7227,-2743.109;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;120.8619,-1554.018;Inherit;False;327;Color1UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;393;387.0302,-1410.888;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;3106.695,-2697.755;Inherit;False;Color2UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;2686.637,-1446.869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;150;-26.89986,-1956.565;Inherit;True;Property;_DoorsColor;Doors Color;5;0;Create;True;0;0;0;False;0;False;-1;816c45ae0964c3d42bbd916a2f565c9e;8ff0f2d5e4f220d4ab4af0233c000405;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;331;599.6663,-1865.389;Inherit;False;325;Color2UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;559.7278,-1498.151;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;187;421.1369,-1697.525;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;229;2049.71,-1512.603;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;823.3639,-1462.67;Inherit;False;212;DamageSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;248;2897.564,-1449.151;Inherit;False;DirtSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;588.9459,-2432.555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;243;99.20151,1581.826;Inherit;False;221;MaskBlueChannel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;82.7376,1906.107;Inherit;False;248;DirtSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;41.86447,1792.413;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;23;0;Create;True;0;0;0;False;0;False;0;0.58;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;43.33768,2021.208;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;24;0;Create;True;0;0;0;False;0;False;0;0.699;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;79.61348,1670.105;Inherit;False;Property;_SmoothnessOverlay;Smoothness Overlay;22;0;Create;True;0;0;0;False;0;False;0;0.22;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;254;40.53766,2114.307;Inherit;False;212;DamageSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;239;-457.0891,-572.2059;Inherit;False;1591.248;517.0002;Comment;7;208;17;213;4;2;301;299;Normals;0.08971164,0.5341466,0.9056604,1;0;0
Node;AmplifyShaderEditor.LerpOp;147;841.8787,-1733.43;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;288;908.6806,-1944.493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;215;1095.199,-1464.493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;2214.452,-1436.383;Float;False;Property;_DirtBrightness;Dirt Brightness;15;0;Create;True;0;0;0;False;0;False;0;0.17;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;332;2089.225,-1714.161;Inherit;False;325;Color2UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;230;2434.057,-1554.839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;1278.795,-1949.414;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;2553.804,-1717.276;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;406.0127,2061.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;87.82846,1501.161;Float;False;Property;_MainSmoothness;Main Smoothness;17;0;Create;True;0;0;0;False;0;False;0;0.345;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;301;-396.1299,-228.763;Inherit;False;Property;_DoorsDamageNMScale;Doors Damage NM Scale;14;0;Create;True;0;0;0;False;0;False;0;1.266;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;418.7134,1625.905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;306;47.242,1294.541;Inherit;True;Property;_TilingMask2_RGBA;TilingMask2_RGBA;29;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;413.3706,1847.74;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;299;-391.1299,-451.763;Inherit;False;Property;_DoorsNMScale;Doors NM Scale;12;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;252;584.7778,1788.369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;8.1161,-286.5981;Inherit;True;Property;_DoorDamageNM;Door Damage NM;13;0;Create;True;0;0;0;False;0;False;-1;ccf0b02cf17b2be4fa3753f1a5083c1c;f5c0b005919690b419229a256aca7c1d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;258;585.5198,2014.903;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;269;577.315,1321.99;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;246;586.5139,1569.504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;194;2888.603,-1931.319;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;361.2719,-147.5471;Inherit;False;212;DamageSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;19.91063,-526.2058;Inherit;True;Property;_DoorNM;Door NM;11;0;Create;True;0;0;0;False;0;False;-1;68cf8deba28c36148b2fdf4dd8335ef2;f96dc5ee892faad4bb093a05417075fc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;17;572.5342,-511.0409;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;351;2224.965,1318.25;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;836.0976,1426.084;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;3244.558,-1928.659;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;1033.912,1440.907;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;352;429.2875,1469.826;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;303;2465.668,1289.365;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;4712.971,-289.0907;Inherit;False;210;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;208;978.0267,-525.4976;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;395;4684.271,-542.1298;Inherit;False;Property;_Color;Color;28;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;3118.172,-2472.111;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;4921.19,-331.4677;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;390;2266.736,-2361.98;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;388;1829.622,-2322.696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;4699.514,-198.921;Inherit;False;208;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;353;4700.78,-27.50613;Inherit;False;352;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;261;4693.268,-117.9273;Inherit;False;260;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;4705.563,82.31781;Inherit;False;303;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;391;2658.537,-2469.579;Inherit;True;Property;_TextureSample4;Texture Sample 4;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;389;2027.818,-2333.032;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.666666;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5051.378,-184.5143;Float;False;True;-1;5;;0;0;Standard;DBK/Doors;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.45;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;25;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;64;0;59;0
WireConnection;25;0;11;2
WireConnection;234;0;11;1
WireConnection;227;0;219;1
WireConnection;271;0;307;0
WireConnection;376;1;334;0
WireConnection;376;0;349;0
WireConnection;368;0;219;2
WireConnection;63;0;25;0
WireConnection;63;1;64;0
WireConnection;56;0;219;3
WireConnection;56;1;55;0
WireConnection;308;0;11;3
WireConnection;377;0;376;0
WireConnection;377;1;375;0
WireConnection;221;0;219;3
WireConnection;57;0;6;0
WireConnection;384;0;382;0
WireConnection;384;1;376;0
WireConnection;24;0;56;0
WireConnection;24;1;63;0
WireConnection;370;0;368;0
WireConnection;293;0;271;2
WireConnection;231;0;228;0
WireConnection;196;0;235;0
WireConnection;7;0;24;0
WireConnection;7;1;57;0
WireConnection;378;0;377;0
WireConnection;385;1;384;0
WireConnection;369;0;219;4
WireConnection;139;0;370;0
WireConnection;294;0;293;0
WireConnection;294;1;292;0
WireConnection;291;0;284;0
WireConnection;232;0;231;0
WireConnection;295;0;294;0
WireConnection;199;1;196;0
WireConnection;199;3;222;0
WireConnection;199;4;197;0
WireConnection;199;5;198;0
WireConnection;386;0;379;0
WireConnection;386;1;385;0
WireConnection;8;0;139;0
WireConnection;8;1;7;0
WireConnection;8;2;5;0
WireConnection;274;0;309;0
WireConnection;380;1;378;0
WireConnection;200;0;232;0
WireConnection;200;1;199;0
WireConnection;278;1;274;0
WireConnection;278;3;291;0
WireConnection;278;4;282;0
WireConnection;278;5;285;0
WireConnection;18;0;8;0
WireConnection;392;0;371;0
WireConnection;392;1;360;0
WireConnection;327;0;386;0
WireConnection;296;0;295;0
WireConnection;381;0;379;0
WireConnection;381;1;380;0
WireConnection;212;0;18;0
WireConnection;279;0;278;0
WireConnection;393;0;392;0
WireConnection;325;0;381;0
WireConnection;190;0;200;0
WireConnection;190;1;201;0
WireConnection;361;0;330;0
WireConnection;361;1;393;0
WireConnection;187;0;150;4
WireConnection;187;1;185;0
WireConnection;229;0;228;0
WireConnection;248;0;190;0
WireConnection;298;0;279;0
WireConnection;298;1;297;0
WireConnection;147;0;361;0
WireConnection;147;1;150;0
WireConnection;147;2;187;0
WireConnection;288;0;150;0
WireConnection;288;1;331;0
WireConnection;288;2;298;0
WireConnection;215;0;214;0
WireConnection;230;0;229;0
WireConnection;149;0;288;0
WireConnection;149;1;147;0
WireConnection;149;2;215;0
WireConnection;193;0;332;0
WireConnection;193;1;230;0
WireConnection;193;2;192;0
WireConnection;257;0;259;0
WireConnection;257;1;254;0
WireConnection;244;0;243;0
WireConnection;244;1;245;0
WireConnection;306;0;307;0
WireConnection;251;0;250;0
WireConnection;251;1;253;0
WireConnection;252;0;251;0
WireConnection;2;5;301;0
WireConnection;258;0;257;0
WireConnection;269;0;306;1
WireConnection;269;1;66;0
WireConnection;246;0;244;0
WireConnection;194;0;149;0
WireConnection;194;1;193;0
WireConnection;194;2;190;0
WireConnection;4;5;299;0
WireConnection;17;0;4;0
WireConnection;17;1;2;0
WireConnection;17;2;213;0
WireConnection;351;0;271;2
WireConnection;351;1;306;3
WireConnection;242;0;269;0
WireConnection;242;1;246;0
WireConnection;242;2;252;0
WireConnection;242;3;258;0
WireConnection;210;0;194;0
WireConnection;260;0;242;0
WireConnection;352;0;306;4
WireConnection;303;0;351;0
WireConnection;208;0;17;0
WireConnection;329;0;391;0
WireConnection;394;0;211;0
WireConnection;394;1;395;0
WireConnection;390;1;389;0
WireConnection;388;0;376;0
WireConnection;388;1;375;0
WireConnection;391;0;379;0
WireConnection;391;1;390;0
WireConnection;389;0;388;0
WireConnection;0;0;394;0
WireConnection;0;1;209;0
WireConnection;0;3;353;0
WireConnection;0;4;261;0
WireConnection;0;10;304;0
ASEEND*/
//CHKSM=F8D8BED4F26B0DF9858F5D9A3F18E3698808971E