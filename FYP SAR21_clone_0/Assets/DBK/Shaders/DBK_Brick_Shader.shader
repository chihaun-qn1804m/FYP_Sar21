// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Brick"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_CementBrightness("Cement Brightness", Range( 0 , 1)) = 0
		_BrickOverlay("Brick Overlay", Range( 0 , 0.05)) = 0
		_WhiteBrick("White Brick", Range( 0 , 0.1)) = 1
		_WhiteBrickRange("White Brick Range", Range( 0 , 1)) = 0
		_WhiteBrickSmooth("White Brick Smooth", Range( 0 , 1)) = 0
		_DarkBrick("Dark Brick", Range( 0 , 1)) = 0
		_DarkBrickAmount("Dark Brick Amount", Range( 0.01 , 0.1)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0
		_DamageSmoothness("Damage Smoothness", Range( 0 , 100)) = 0
		_TransitionScale("Transition Scale", Range( 0 , 0.5)) = 0
		_RGBA_Mask_A("RGBA_Mask_A", 2D) = "white" {}
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_BrickNM("Brick NM", 2D) = "bump" {}
		_BrickScale("Brick Scale", Range( 1 , 2)) = 1
		_PaintedBrickScale("Painted Brick Scale", Range( 0 , 1)) = 0
		_BrickUniqueNM("Brick Unique NM", 2D) = "bump" {}
		_BrickUniqueScale("Brick Unique Scale", Range( 0 , 2)) = 0
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_RGBAMaskC("RGBA Mask C", 2D) = "white" {}
		_BrickBareSmoothness("BrickBare Smoothness", Range( 0 , 2)) = 0
		_BrickPaintSmoothness("BrickPaint Smoothness", Range( 0 , 1)) = 0
		_BrickDirtSmoothness("BrickDirt Smoothness", Range( 0 , 1)) = 0
		_BrickDirtMainSmoothness("BrickDirtMain Smoothness", Range( 0 , 1)) = 0
		_BrickDarkSmoothness("BrickDark Smoothness", Range( 0 , 1)) = 0
		[Toggle(_USECUSTOMCOLOR_ON)] _UseCustomColor("Use Custom Color", Float) = 0
		_CustomColor("Custom Color", Int) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
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

		uniform sampler2D _BrickNM;
		uniform float4 _BrickNM_ST;
		uniform float _BrickScale;
		uniform float _PaintedBrickScale;
		uniform sampler2D _RGBA_Mask_A;
		uniform float4 _RGBA_Mask_A_ST;
		uniform float _DamageAmount;
		uniform float _DamageSmoothness;
		uniform sampler2D _BrickUniqueNM;
		uniform float4 _BrickUniqueNM_ST;
		uniform float _BrickUniqueScale;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _RGBAMaskC;
		uniform float4 _RGBAMaskC_ST;
		uniform float _CementBrightness;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _BrickOverlay;
		uniform float _WhiteBrickRange;
		uniform float _WhiteBrickSmooth;
		uniform float _WhiteBrick;
		uniform float _DarkBrickAmount;
		uniform float _DarkBrick;
		uniform float _TransitionScale;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float4 _Color;
		uniform float _BrickBareSmoothness;
		uniform float _BrickPaintSmoothness;
		uniform float _BrickDirtSmoothness;
		uniform float _BrickDarkSmoothness;
		uniform float _BrickDirtMainSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BrickNM = i.uv_texcoord * _BrickNM_ST.xy + _BrickNM_ST.zw;
			float2 uv_RGBA_Mask_A = i.uv_texcoord * _RGBA_Mask_A_ST.xy + _RGBA_Mask_A_ST.zw;
			float4 tex2DNode371 = tex2D( _RGBA_Mask_A, uv_RGBA_Mask_A );
			float BricksDirtBlue598 = tex2DNode371.b;
			float BricksDirtRed597 = tex2DNode371.r;
			float HeightMask6 = saturate(pow(((BricksDirtBlue598*( _DamageAmount * ( i.vertexColor.g * BricksDirtRed597 ) ))*4)+(( _DamageAmount * ( i.vertexColor.g * BricksDirtRed597 ) )*2),_DamageSmoothness));
			float HeightBricks385 = HeightMask6;
			float3 lerpResult16 = lerp( UnpackScaleNormal( tex2D( _BrickNM, uv_BrickNM ), _BrickScale ) , UnpackScaleNormal( tex2D( _BrickNM, uv_BrickNM ), _PaintedBrickScale ) , HeightBricks385);
			float2 uv_BrickUniqueNM = i.uv_texcoord * _BrickUniqueNM_ST.xy + _BrickUniqueNM_ST.zw;
			float VertexAlpha521 = i.vertexColor.a;
			float3 lerpResult520 = lerp( lerpResult16 , UnpackScaleNormal( tex2D( _BrickUniqueNM, uv_BrickUniqueNM ), _BrickUniqueScale ) , VertexAlpha521);
			float3 Normals446 = lerpResult520;
			o.Normal = Normals446;
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch676 = (float)_CustomColor;
			#else
				float staticSwitch676 = (float)_ColorSelect;
			#endif
			float temp_output_659_0 = ( staticSwitch676 * 0.015625 );
			float2 appendResult667 = (float2(temp_output_659_0 , -0.75));
			float2 uv4_TexCoord666 = i.uv4_texcoord4 + appendResult667;
			float4 BricksColorUV3668 = tex2D( _MainTex, uv4_TexCoord666 );
			float2 uv_RGBAMaskC = i.uv_texcoord * _RGBAMaskC_ST.xy + _RGBAMaskC_ST.zw;
			float4 tex2DNode606 = tex2D( _RGBAMaskC, uv_RGBAMaskC );
			float4 temp_cast_2 = (pow( tex2DNode606.r , _CementBrightness )).xxxx;
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode561 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float4 lerpResult23 = lerp( BricksColorUV3668 , temp_cast_2 , tex2DNode561.r);
			float4 BricksLerp578 = lerpResult23;
			float2 uv4_TexCoord656 = i.uv4_texcoord4 + ( half2( 0.015625,0 ) * staticSwitch676 );
			float4 PaintColorUV3658 = tex2D( _MainTex, uv4_TexCoord656 );
			float BricksMask_Blue573 = tex2DNode561.b;
			float3 temp_cast_3 = (( 1.0 - tex2DNode606.b )).xxx;
			float VertexBlue593 = i.vertexColor.b;
			float BricksMask_Alpha604 = tex2DNode561.a;
			float3 temp_cast_4 = (( 1.0 - ( ( 1.0 - VertexBlue593 ) * BricksMask_Alpha604 ) )).xxx;
			float PaintEdges471 = saturate( ( 1.0 - ( ( distance( temp_cast_3 , temp_cast_4 ) - _WhiteBrickRange ) / max( _WhiteBrickSmooth , 1E-05 ) ) ) );
			float PaintEdgesSelection476 = step( 0.1 , ( ( 1.0 - PaintEdges471 ) * step( _DarkBrickAmount , PaintEdges471 ) ) );
			float4 lerpResult10 = lerp( BricksLerp578 , ( ( ( PaintColorUV3658 + ( ( 1.0 - BricksMask_Blue573 ) * _BrickOverlay ) ) + ( PaintEdges471 * _WhiteBrick ) ) * ( 1.0 - ( ( PaintEdgesSelection476 * ( 1.0 - PaintEdges471 ) ) * _DarkBrick ) ) ) , HeightBricks385);
			float4 BricksBrightDarkLerp581 = lerpResult10;
			float BricksHeightBlue601 = tex2DNode606.a;
			float2 appendResult649 = (float2(( staticSwitch676 * 0.015625 ) , -0.25));
			float2 uv4_TexCoord650 = i.uv4_texcoord4 + appendResult649;
			float4 TransitionUV3654 = tex2D( _MainTex, uv4_TexCoord650 );
			float4 TransitionColor562 = ( BricksHeightBlue601 * TransitionUV3654 );
			float BricksStep406 = saturate( step( 0.1 , ( ( 1.0 - HeightBricks385 ) * step( _TransitionScale , HeightBricks385 ) ) ) );
			float4 lerpResult124 = lerp( BricksBrightDarkLerp581 , TransitionColor562 , BricksStep406);
			float4 LerpTransition584 = lerpResult124;
			float4 temp_cast_5 = (pow( tex2DNode606.g , _CementBrightness )).xxxx;
			float4 lerpResult544 = lerp( BricksColorUV3668 , temp_cast_5 , tex2DNode561.g);
			float4 UniqueBricksLerp547 = lerpResult544;
			float4 lerpResult548 = lerp( LerpTransition584 , UniqueBricksLerp547 , VertexAlpha521);
			float2 appendResult660 = (float2(temp_output_659_0 , -0.5));
			float2 uv4_TexCoord661 = i.uv4_texcoord4 + appendResult660;
			float4 DirtColorUV3663 = tex2D( _MainTex, uv4_TexCoord661 );
			float3 temp_cast_6 = (tex2DNode371.g).xxx;
			float VertexRed592 = i.vertexColor.r;
			float3 temp_cast_7 = (( 1.0 - VertexRed592 )).xxx;
			float temp_output_387_0 = ( tex2DNode371.a * saturate( ( 1.0 - ( ( distance( temp_cast_6 , temp_cast_7 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) ) );
			float4 lerpResult372 = lerp( lerpResult548 , ( BricksHeightBlue601 * DirtColorUV3663 ) , temp_output_387_0);
			o.Albedo = ( lerpResult372 * _Color ).rgb;
			float BricksTileSelection609 = tex2DNode606.r;
			float BricksDirt_Alpha614 = tex2DNode371.a;
			float lerpResult410 = lerp( ( BricksTileSelection609 * _BrickBareSmoothness ) , ( _BrickPaintSmoothness * ( 1.0 - ( BricksDirt_Alpha614 * _BrickDirtSmoothness ) ) * ( 1.0 - ( PaintEdges471 * _BrickDarkSmoothness ) ) ) , HeightBricks385);
			float BricksMainDirt625 = temp_output_387_0;
			float BricksUniqueSelection634 = tex2DNode606.g;
			float lerpResult632 = lerp( ( lerpResult410 * ( 1.0 - ( _BrickDirtMainSmoothness * BricksMainDirt625 ) ) ) , ( _BrickBareSmoothness * BricksUniqueSelection634 ) , VertexAlpha521);
			float Smoothness638 = lerpResult632;
			o.Smoothness = Smoothness638;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-1385.538;2224.476;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-5449.488,563.6172;Inherit;False;1994.059;650.9581;;11;12;11;521;5;4;3;6;592;593;599;600;Heightmap;1,0.5185516,0,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;11;-5365.744,847.2242;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;580;-5481.938,-1767.636;Inherit;False;1998.529;949.7259;;16;544;365;576;577;543;547;366;573;561;23;578;604;606;601;609;634;Lerp - Bricks with Unique ;0.8018868,0.3794415,0.1475169,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;593;-5006.916,1009.971;Inherit;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;570;-5516.229,-2967.577;Inherit;False;1236.638;830.2369;Comment;9;465;461;457;458;462;456;594;605;679;White Bricks;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;561;-5431.938,-1542.726;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;20;0;Create;True;0;0;0;False;0;False;-1;8f09dd62ab8dbe147aabae135c002c75;8f09dd62ab8dbe147aabae135c002c75;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;604;-4966.844,-1218.299;Inherit;False;BricksMask_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;594;-5430.605,-2316.847;Inherit;False;593;VertexBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;465;-5210.368,-2313.838;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;605;-5392.869,-2580.087;Inherit;False;604;BricksMask_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;461;-5103.702,-2578.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;606;-5015.03,-1697.253;Inherit;True;Property;_RGBAMaskC;RGBA Mask C;21;0;Create;True;0;0;0;False;0;False;-1;5cd6e5fc40f342846b61030f083de2fd;5cd6e5fc40f342846b61030f083de2fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;456;-4888.306,-2607.825;Inherit;False;Property;_WhiteBrickRange;White Brick Range;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;462;-4910.099,-2688.727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;457;-4888.225,-2510.588;Inherit;False;Property;_WhiteBrickSmooth;White Brick Smooth;6;0;Create;True;0;0;0;False;0;False;0;0.2811882;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;458;-4802.776,-2252.813;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;645;-2741.286,-3206.938;Inherit;False;2291.881;1053.203;Comment;24;676;647;675;663;662;661;660;654;653;650;649;668;658;648;657;665;651;656;666;655;667;659;652;646;UV3 Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;572;-4217.277,-2779.135;Inherit;False;1247.97;348.2783;Comment;7;471;472;473;474;475;506;476;Dark Bricks;0.58,0.58,0.58,1;0;0
Node;AmplifyShaderEditor.FunctionNode;679;-4546.589,-2691.178;Inherit;False;Color Mask;-1;;43;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;647;-2706.788,-2988.043;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;596;556.4391,-1820.656;Inherit;False;1724.298;1007.753;Comment;19;595;372;548;376;387;549;550;607;603;608;392;400;401;598;597;371;614;625;670;Lerp-Dirt;0.9433962,0.5693384,0.1913492,1;0;0
Node;AmplifyShaderEditor.IntNode;675;-2717.97,-2878.196;Inherit;False;Property;_CustomColor;Custom Color;28;0;Create;True;0;0;0;False;0;False;0;12;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;471;-4103.596,-2690.398;Inherit;False;PaintEdges;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;646;-2372.784,-2657.554;Inherit;False;Constant;_4Row;4 Row;33;0;Create;True;0;0;0;False;0;False;0.015625;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;676;-2461.97,-2922.196;Inherit;False;Property;_UseCustomColor;Use Custom Color;27;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;506;-4105.277,-2547.856;Inherit;False;Property;_DarkBrickAmount;Dark Brick Amount;8;0;Create;True;0;0;0;False;0;False;0;0.1;0.01;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;371;659.4146,-1368.232;Inherit;True;Property;_RGBA_Mask_A;RGBA_Mask_A;12;0;Create;True;0;0;0;False;0;False;-1;e61e67a9b8d15444a84d7d27624a2bbe;e61e67a9b8d15444a84d7d27624a2bbe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;472;-3794.71,-2729.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;659;-2064.502,-2476.287;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;473;-3768.813,-2597.12;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;597;1036.627,-1405.799;Inherit;False;BricksDirtRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;652;-2300.378,-3147.126;Half;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;474;-3614.83,-2678.03;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;655;-1932.858,-3141.239;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;667;-1859.71,-2277.484;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;599;-5361.875,693.276;Inherit;False;597;BricksDirtRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-4959.43,815.6754;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;651;-1663.487,-2976.25;Inherit;True;Property;_MainTex;Color Theme;1;0;Create;False;0;0;0;False;0;False;a4b54f4a931b12047a9252ab1e0b62a0;a4b54f4a931b12047a9252ab1e0b62a0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;656;-1614.212,-3156.938;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.09,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;573;-5012.613,-1436.045;Inherit;False;BricksMask_Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;598;1036.627,-1336.799;Inherit;False;BricksDirtBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;475;-3457.523,-2687.015;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;583;-3335.469,-1795.123;Inherit;False;2183.416;999.3752;Comment;21;575;491;556;571;510;492;500;509;499;493;504;496;554;555;553;501;10;581;386;579;671;Lerp - Dark/Bright Bricks;0.1439124,0.6785243,0.9245283,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-4201.641,883.4222;Float;False;Property;_DamageAmount;Damage Amount;9;0;Create;True;0;0;0;False;0;False;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;666;-1596.111,-2310.686;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;600;-4195.875,619.276;Inherit;False;598;BricksDirtBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4202.713,705.2323;Float;False;Property;_DamageSmoothness;Damage Smoothness;10;0;Create;True;0;0;0;False;0;False;0;7.170697;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;657;-1216.798,-3025.567;Inherit;True;Property;_TextureSample4;Texture Sample 4;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;476;-3290.304,-2688.879;Inherit;False;PaintEdgesSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;491;-3285.469,-1745.123;Inherit;False;471;PaintEdges;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;665;-1216.543,-2405.067;Inherit;True;Property;_TextureSample6;Texture Sample 6;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;575;-3239.541,-1172.409;Inherit;False;573;BricksMask_Blue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-3928.369,786.5243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;672;-4385.506,-1389.307;Inherit;False;300;165;;1;669;Bricks Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;510;-3036.46,-1540.043;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;592;-5008.916,931.9714;Inherit;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;554;-2963.49,-1170.734;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;6;-3781.197,634.7294;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;408;-3408.613,577.2896;Inherit;False;1419.998;506.2538;Bricks Edges;8;406;170;111;466;112;109;385;677;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-4808.92,-1288.625;Inherit;False;Property;_CementBrightness;Cement Brightness;2;0;Create;True;0;0;0;False;0;False;0;0.794;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;671;-2730.167,-991.153;Inherit;False;295;165;;1;644;Paint Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;648;-2031.054,-2786.042;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;668;-763.9916,-2348.844;Inherit;False;BricksColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;556;-3034.927,-1030.83;Inherit;False;Property;_BrickOverlay;Brick Overlay;3;0;Create;True;0;0;0;False;0;False;0;0.0215;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;658;-771.2516,-3013.643;Inherit;False;PaintColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;571;-3137.748,-1446.563;Inherit;False;476;PaintEdgesSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;492;-3039.855,-1649.199;Inherit;False;Property;_WhiteBrick;White Brick;4;0;Create;True;0;0;0;False;0;False;1;0.04023725;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;385;-3364.243,627.0996;Inherit;False;HeightBricks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;500;-3062.821,-1317.25;Inherit;False;Property;_DarkBrick;Dark Brick;7;0;Create;True;0;0;0;False;0;False;0;0.4222656;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;595;602.2433,-1138.684;Inherit;False;592;VertexRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-3358.613,901.2434;Inherit;False;Property;_TransitionScale;Transition Scale;11;0;Create;True;0;0;0;False;0;False;0;0.182;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;649;-1865.922,-2666.506;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.25;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;644;-2680.167,-941.153;Inherit;False;658;PaintColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;555;-2663.49,-1152.734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;669;-4335.506,-1339.307;Inherit;False;668;BricksColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;365;-4285.058,-1572.541;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;509;-2807.56,-1457.2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;650;-1613.105,-2703.454;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;392;816.8997,-1018.551;Inherit;False;Property;_DirtRange;Dirt Range;13;0;Create;True;0;0;0;False;0;False;0;0.321;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;608;1335.92,-1245.177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;400;822.8726,-898.2701;Inherit;False;Property;_DirtSmooth;Dirt Smooth;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;499;-2639.382,-1340.65;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;401;860.6641,-1134.253;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;553;-2416.185,-1153.642;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;112;-3051.044,640.2896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-3977.364,-1563.981;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;493;-2637.242,-1739.882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;466;-3016.379,724.3254;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;637;-2685.716,-502.0764;Inherit;False;2699.9;927.1524;Comment;25;632;636;631;630;410;633;629;628;411;611;616;620;627;612;626;617;610;624;623;618;619;622;615;621;638;Smoothness;0.761749,0.7843137,0.145098,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;1043.682,-1214.744;Inherit;False;BricksDirt_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;607;1396.92,-1259.177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;678;1225.124,-1133.079;Inherit;False;Color Mask;-1;;44;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;496;-2350.804,-1665.713;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;504;-2535.918,-1472.708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;653;-1204.82,-2828.184;Inherit;True;Property;_TextureSample1;Texture Sample 1;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-2847.852,669.1094;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;589;-1064.128,-1766.892;Inherit;False;1378.595;693.7728;Comment;8;380;562;407;124;584;582;602;673;Lerp - Transition;0.248395,0.755,0.3159424,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;578;-3726.164,-1565.868;Inherit;False;BricksLerp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-2614.226,-74.10902;Inherit;False;614;BricksDirt_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;622;-2622.635,288.0671;Inherit;False;Property;_BrickDarkSmoothness;BrickDark Smoothness;26;0;Create;True;0;0;0;False;0;False;0;0.6307253;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;568;-5421.079,-389.2057;Inherit;False;2455.184;788.8727;;16;515;405;514;357;15;14;517;516;16;520;446;522;567;566;569;640;Normal Map;0.1648719,0.5086809,0.8962264,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-2620.436,34.18157;Inherit;False;Property;_BrickDirtSmoothness;BrickDirt Smoothness;24;0;Create;True;0;0;0;False;0;False;0;0.2660194;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;1501.101,-1367.442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;621;-2616.17,173.8288;Inherit;False;471;PaintEdges;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;673;-966.3142,-1428.879;Inherit;False;295;165;;1;664;Transition Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;170;-2656.181,712.7185;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;654;-749.6047,-2811.347;Inherit;False;TransitionUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;601;-4534.694,-1626.725;Inherit;False;BricksHeightBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;386;-2014.407,-1522.945;Inherit;False;385;HeightBricks;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;579;-2008.018,-1744.281;Inherit;False;578;BricksLerp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;501;-2005.836,-1664.582;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;664;-916.3142,-1378.879;Inherit;False;654;TransitionUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;576;-4997.984,-930.3241;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;618;-2300.436,-12.81846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;625;1733.432,-1345.111;Inherit;False;BricksMainDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;609;-4557.495,-1785.771;Inherit;False;BricksTileSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;516;-5346.39,162.667;Inherit;True;Property;_BrickUniqueNM;Brick Unique NM;18;0;Create;True;0;0;0;False;0;False;1a870ccd827dd9d48b79710838d14ae3;1a870ccd827dd9d48b79710838d14ae3;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;640;-4917.102,270.9777;Inherit;False;Property;_BrickUniqueScale;Brick Unique Scale;19;0;Create;True;0;0;0;False;0;False;0;1.28;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;677;-2448.703,685.9851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;660;-1863.14,-2468.422;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;10;-1752.979,-1683.426;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;602;-985.6096,-1700.238;Inherit;False;601;BricksHeightBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;623;-2283.016,163.2805;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;617;-2635.716,-175.4937;Inherit;False;Property;_BrickPaintSmoothness;BrickPaint Smoothness;23;0;Create;True;0;0;0;False;0;False;0;0.251;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;517;-4562.131,161.2176;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;624;-2153.016,150.2805;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;626;-1795.42,240.2388;Inherit;False;625;BricksMainDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;620;-2191.436,-69.81847;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;612;-2625.461,-307.3878;Inherit;False;Property;_BrickBareSmoothness;BrickBare Smoothness;22;0;Create;True;0;0;0;False;0;False;0;0.6040428;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;610;-2625.633,-452.0764;Inherit;False;609;BricksTileSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-1843.871,110.6288;Inherit;False;Property;_BrickDirtMainSmoothness;BrickDirtMain Smoothness;25;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;380;-624.6746,-1548.943;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;406;-2229.539,636.6235;Inherit;False;BricksStep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;577;-4959.967,-899.9115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;661;-1603.323,-2506.37;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;543;-4393.067,-1182.597;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;581;-1507.053,-1685.001;Inherit;False;BricksBrightDarkLerp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;628;-1537.411,115.4741;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;611;-2176.893,-431.8211;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;634;-4573.307,-1706.614;Inherit;False;BricksUniqueSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;569;-3978.857,169.2027;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;411;-1810.71,-105.3051;Inherit;False;385;HeightBricks;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;616;-2001.525,-166.509;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;662;-1208.422,-2614.969;Inherit;True;Property;_TextureSample5;Texture Sample 5;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;515;-4894.436,31.14987;Inherit;False;Property;_PaintedBrickScale;Painted Brick Scale;17;0;Create;True;0;0;0;False;0;False;0;0.69;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;544;-3960.85,-978.9343;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;407;-431.0503,-1462.115;Inherit;False;406;BricksStep;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;562;-462.3398,-1553.048;Inherit;False;TransitionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;-454.4735,-1716.892;Inherit;False;581;BricksBrightDarkLerp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;357;-4880.689,-222.4424;Inherit;False;Property;_BrickScale;Brick Scale;16;0;Create;True;0;0;0;False;0;False;1;1.677;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;514;-5346.079,-318.5724;Inherit;True;Property;_BrickNM;Brick NM;15;0;Create;True;0;0;0;False;0;False;5b51302e23bec5547b188ac35d9f8845;5b51302e23bec5547b188ac35d9f8845;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;629;-1423.547,8.879265;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-4566.569,-39.71492;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-4582.008,-314.0273;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;405;-4140.282,-51.24776;Inherit;False;385;HeightBricks;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;521;-5008.086,1086.465;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;633;-1266.556,-194.2097;Inherit;False;634;BricksUniqueSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;124;-164.4545,-1712.08;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;663;-751.1837,-2585.702;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;547;-3735.672,-975.4582;Inherit;False;UniqueBricksLerp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;566;-3920.305,133.1726;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;410;-1635.196,-432.9204;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;631;-1005.922,75.21884;Inherit;False;521;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;636;-989.863,-266.1328;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-3967.293,-314.2065;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;630;-1330.832,-436.8817;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;567;-3815.149,-168.9061;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;584;63.19162,-1723.075;Inherit;False;LerpTransition;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;522;-3755.572,-35.7209;Inherit;False;521;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;670;1197.622,-1518.875;Inherit;False;663;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;603;1202.143,-1638.8;Inherit;False;601;BricksHeightBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;549;614.1591,-1625.656;Inherit;False;547;UniqueBricksLerp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;550;676.8445,-1517.215;Inherit;False;521;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;376;1496.089,-1522.247;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;548;923.5396,-1714.597;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;632;-767.8557,-433.3095;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;520;-3506.823,-318.9244;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;372;1739.938,-1714.77;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;446;-3223.893,-328.2058;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;638;-503.8536,-430.1296;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;681;2193.657,-1999.722;Inherit;False;Property;_Color;Color;29;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;639;2355.606,-1534.069;Inherit;False;638;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;680;2409.577,-1724.06;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;447;2345.227,-1630.055;Inherit;False;446;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2688.111,-1704.6;Float;False;True;-1;4;;0;0;Standard;DBK/Brick;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;674;1145.622,-1569.875;Inherit;False;286;165;;0;Dirt Color;1,1,1,1;0;0
WireConnection;593;0;11;3
WireConnection;604;0;561;4
WireConnection;465;0;594;0
WireConnection;461;0;465;0
WireConnection;461;1;605;0
WireConnection;462;0;461;0
WireConnection;458;0;606;3
WireConnection;679;1;462;0
WireConnection;679;3;458;0
WireConnection;679;4;456;0
WireConnection;679;5;457;0
WireConnection;471;0;679;0
WireConnection;676;1;647;0
WireConnection;676;0;675;0
WireConnection;472;0;471;0
WireConnection;659;0;676;0
WireConnection;659;1;646;0
WireConnection;473;0;506;0
WireConnection;473;1;471;0
WireConnection;597;0;371;1
WireConnection;474;0;472;0
WireConnection;474;1;473;0
WireConnection;655;0;652;0
WireConnection;655;1;676;0
WireConnection;667;0;659;0
WireConnection;12;0;11;2
WireConnection;12;1;599;0
WireConnection;656;1;655;0
WireConnection;573;0;561;3
WireConnection;598;0;371;3
WireConnection;475;1;474;0
WireConnection;666;1;667;0
WireConnection;657;0;651;0
WireConnection;657;1;656;0
WireConnection;476;0;475;0
WireConnection;665;0;651;0
WireConnection;665;1;666;0
WireConnection;5;0;3;0
WireConnection;5;1;12;0
WireConnection;510;0;491;0
WireConnection;592;0;11;1
WireConnection;554;0;575;0
WireConnection;6;0;600;0
WireConnection;6;1;5;0
WireConnection;6;2;4;0
WireConnection;648;0;676;0
WireConnection;648;1;646;0
WireConnection;668;0;665;0
WireConnection;658;0;657;0
WireConnection;385;0;6;0
WireConnection;649;0;648;0
WireConnection;555;0;554;0
WireConnection;555;1;556;0
WireConnection;365;0;606;1
WireConnection;365;1;366;0
WireConnection;509;0;571;0
WireConnection;509;1;510;0
WireConnection;650;1;649;0
WireConnection;608;0;371;4
WireConnection;499;0;509;0
WireConnection;499;1;500;0
WireConnection;401;0;595;0
WireConnection;553;0;644;0
WireConnection;553;1;555;0
WireConnection;112;0;385;0
WireConnection;23;0;669;0
WireConnection;23;1;365;0
WireConnection;23;2;561;1
WireConnection;493;0;491;0
WireConnection;493;1;492;0
WireConnection;466;0;109;0
WireConnection;466;1;385;0
WireConnection;614;0;371;4
WireConnection;607;0;608;0
WireConnection;678;1;401;0
WireConnection;678;3;371;2
WireConnection;678;4;392;0
WireConnection;678;5;400;0
WireConnection;496;0;553;0
WireConnection;496;1;493;0
WireConnection;504;0;499;0
WireConnection;653;0;651;0
WireConnection;653;1;650;0
WireConnection;111;0;112;0
WireConnection;111;1;466;0
WireConnection;578;0;23;0
WireConnection;387;0;607;0
WireConnection;387;1;678;0
WireConnection;170;1;111;0
WireConnection;654;0;653;0
WireConnection;601;0;606;4
WireConnection;501;0;496;0
WireConnection;501;1;504;0
WireConnection;576;0;561;2
WireConnection;618;0;615;0
WireConnection;618;1;619;0
WireConnection;625;0;387;0
WireConnection;609;0;606;1
WireConnection;677;0;170;0
WireConnection;660;0;659;0
WireConnection;10;0;579;0
WireConnection;10;1;501;0
WireConnection;10;2;386;0
WireConnection;623;0;621;0
WireConnection;623;1;622;0
WireConnection;517;0;516;0
WireConnection;517;5;640;0
WireConnection;624;0;623;0
WireConnection;620;0;618;0
WireConnection;380;0;602;0
WireConnection;380;1;664;0
WireConnection;406;0;677;0
WireConnection;577;0;576;0
WireConnection;661;1;660;0
WireConnection;543;0;606;2
WireConnection;543;1;366;0
WireConnection;581;0;10;0
WireConnection;628;0;627;0
WireConnection;628;1;626;0
WireConnection;611;0;610;0
WireConnection;611;1;612;0
WireConnection;634;0;606;2
WireConnection;569;0;517;0
WireConnection;616;0;617;0
WireConnection;616;1;620;0
WireConnection;616;2;624;0
WireConnection;662;0;651;0
WireConnection;662;1;661;0
WireConnection;544;0;669;0
WireConnection;544;1;543;0
WireConnection;544;2;577;0
WireConnection;562;0;380;0
WireConnection;629;0;628;0
WireConnection;14;0;514;0
WireConnection;14;5;515;0
WireConnection;15;0;514;0
WireConnection;15;5;357;0
WireConnection;521;0;11;4
WireConnection;124;0;582;0
WireConnection;124;1;562;0
WireConnection;124;2;407;0
WireConnection;663;0;662;0
WireConnection;547;0;544;0
WireConnection;566;0;569;0
WireConnection;410;0;611;0
WireConnection;410;1;616;0
WireConnection;410;2;411;0
WireConnection;636;0;612;0
WireConnection;636;1;633;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;16;2;405;0
WireConnection;630;0;410;0
WireConnection;630;1;629;0
WireConnection;567;0;566;0
WireConnection;584;0;124;0
WireConnection;376;0;603;0
WireConnection;376;1;670;0
WireConnection;548;0;584;0
WireConnection;548;1;549;0
WireConnection;548;2;550;0
WireConnection;632;0;630;0
WireConnection;632;1;636;0
WireConnection;632;2;631;0
WireConnection;520;0;16;0
WireConnection;520;1;567;0
WireConnection;520;2;522;0
WireConnection;372;0;548;0
WireConnection;372;1;376;0
WireConnection;372;2;387;0
WireConnection;446;0;520;0
WireConnection;638;0;632;0
WireConnection;680;0;372;0
WireConnection;680;1;681;0
WireConnection;0;0;680;0
WireConnection;0;1;447;0
WireConnection;0;4;639;0
ASEEND*/
//CHKSM=EF42711662FAB7C53DD4C407DB8AB65867FC305C