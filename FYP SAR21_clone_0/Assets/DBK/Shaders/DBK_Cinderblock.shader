// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Cinderblock"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_EdgesOverlay("Edges Overlay", Range( 0 , 2)) = 0
		_EdgesMultiply("Edges Multiply", Range( 0 , 1)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0.421177
		_DamageSmoothness("Damage Smoothness", Range( 0 , 20)) = 0
		_DamageMultiplier("Damage Multiplier", Range( 0 , 3)) = 0.1946161
		_PaintNM("Paint NM", 2D) = "bump" {}
		_PaintNMScale("Paint NM Scale", Range( 1 , 2)) = 1
		_PaintSharpness("Paint Sharpness", Range( 0 , 1)) = 0
		_PaintBareSmooth("Paint Bare Smooth", Range( 0 , 1)) = 0
		_PaintBareRange("Paint Bare Range", Range( 0 , 1)) = 0
		_PaintEdgesMultiply("Paint Edges Multiply", Range( 0 , 1)) = 1
		_TransitionNM("Transition NM", 2D) = "bump" {}
		_TransitionNMScale("Transition NM Scale", Range( 1 , 2)) = 0
		_PaintDamageNM("Paint Damage NM", 2D) = "bump" {}
		_PaintDamageNMScale("Paint Damage NM Scale", Range( 1 , 2)) = 1
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 4)) = 0
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_RGBAMaskC("RGBA Mask C", 2D) = "white" {}
		_TransitionBrighthness("Transition Brighthness", Range( 1 , 2)) = 0
		_SmoothnessMain("Smoothness Main", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_PaintSmoothness("Paint Smoothness", Range( 0 , 1)) = 0
		_ChippedPaintScale("Chipped Paint Scale", Range( 0 , 1)) = 0
		_ChippedPaintBrightness("Chipped Paint Brightness", Range( 0 , 1)) = 0
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
		#pragma target 3.0
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv4_texcoord4;
		};

		uniform sampler2D _PaintNM;
		uniform float4 _PaintNM_ST;
		uniform float _PaintNMScale;
		uniform sampler2D _PaintDamageNM;
		uniform float4 _PaintDamageNM_ST;
		uniform float _PaintDamageNMScale;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _DamageMultiplier;
		uniform float _DamageAmount;
		uniform float _DamageSmoothness;
		uniform sampler2D _RGBAMaskC;
		uniform float4 _RGBAMaskC_ST;
		uniform float _PaintBareRange;
		uniform float _PaintBareSmooth;
		uniform float _ChippedPaintScale;
		uniform sampler2D _TransitionNM;
		uniform float4 _TransitionNM_ST;
		uniform float _TransitionNMScale;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _EdgesMultiply;
		uniform float _EdgesOverlay;
		uniform float _ChippedPaintBrightness;
		uniform float _PaintSharpness;
		uniform float _PaintEdgesMultiply;
		uniform float _TransitionBrighthness;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _SmoothnessMain;
		uniform float _SmoothnessDamage;
		uniform float _SmoothnessDirt;
		uniform float _PaintSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_PaintNM = i.uv_texcoord * _PaintNM_ST.xy + _PaintNM_ST.zw;
			float2 uv_PaintDamageNM = i.uv_texcoord * _PaintDamageNM_ST.xy + _PaintDamageNM_ST.zw;
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode351 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float HeightMask10 = saturate(pow(((( 1.0 - tex2DNode351.g )*( ( ( tex2DNode351.r * _DamageMultiplier ) * ( 1.0 - i.vertexColor.g ) ) * _DamageAmount ))*4)+(( ( ( tex2DNode351.r * _DamageMultiplier ) * ( 1.0 - i.vertexColor.g ) ) * _DamageAmount )*2),_DamageSmoothness));
			float Heightmap11 = HeightMask10;
			float MainShapeSelect298 = step( 0.06 , Heightmap11 );
			float2 uv_RGBAMaskC = i.uv_texcoord * _RGBAMaskC_ST.xy + _RGBAMaskC_ST.zw;
			float3 temp_cast_0 = (( 1.0 - tex2D( _RGBAMaskC, uv_RGBAMaskC ).r )).xxx;
			float VertexBlue365 = i.vertexColor.b;
			float4 tex2DNode556 = tex2D( _RGBAMaskC, uv_RGBAMaskC );
			float3 temp_cast_1 = (( 1.0 - ( ( 1.0 - VertexBlue365 ) * tex2DNode556.g ) )).xxx;
			float temp_output_482_0 = saturate( ( 1.0 - ( ( distance( temp_cast_0 , temp_cast_1 ) - _PaintBareRange ) / max( _PaintBareSmooth , 1E-05 ) ) ) );
			float PaintConcreteSelection512 = temp_output_482_0;
			float temp_output_517_0 = ( PaintConcreteSelection512 * ( 1.0 - MainShapeSelect298 ) );
			float temp_output_537_0 = step( 0.1 , temp_output_517_0 );
			float ChippedPaintSelection542 = temp_output_537_0;
			float3 lerpResult419 = lerp( UnpackScaleNormal( tex2D( _PaintNM, uv_PaintNM ), _PaintNMScale ) , UnpackScaleNormal( tex2D( _PaintDamageNM, uv_PaintDamageNM ), _PaintDamageNMScale ) , ( MainShapeSelect298 + ( ChippedPaintSelection542 * _ChippedPaintScale ) ));
			float2 uv_TransitionNM = i.uv_texcoord * _TransitionNM_ST.xy + _TransitionNM_ST.zw;
			float HeightDamage403 = Heightmap11;
			float clampResult411 = clamp( step( 0.1 , ( ( 1.0 - HeightDamage403 ) * step( 0.06 , HeightDamage403 ) ) ) , 0.0 , 1.0 );
			float TransitionSelect234 = clampResult411;
			float3 lerpResult421 = lerp( lerpResult419 , UnpackScaleNormal( tex2D( _TransitionNM, uv_TransitionNM ), _TransitionNMScale ) , TransitionSelect234);
			float3 Normals92 = lerpResult421;
			o.Normal = Normals92;
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch562 = (float)_CustomColor;
			#else
				float staticSwitch562 = (float)_ColorSelect;
			#endif
			float2 uv4_TexCoord444 = i.uv4_texcoord4 + ( half2( 0.015625,0 ) * staticSwitch562 );
			float4 PaintColorUV3447 = tex2D( _MainTex, uv4_TexCoord444 );
			float2 uv_RGBAMaskA = i.uv_texcoord * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode356 = tex2D( _RGBAMaskA, uv_RGBAMaskA );
			float temp_output_38_0 = pow( tex2DNode356.r , _EdgesMultiply );
			float RGBA_Mask_C_Blue557 = tex2DNode556.b;
			float temp_output_442_0 = ( staticSwitch562 * 0.015625 );
			float2 appendResult445 = (float2(temp_output_442_0 , -0.75));
			float2 uv4_TexCoord448 = i.uv4_texcoord4 + appendResult445;
			float4 BricksColorUV3450 = tex2D( _MainTex, uv4_TexCoord448 );
			float4 lerpResult14 = lerp( ( ( PaintColorUV3447 * temp_output_38_0 ) + ( tex2DNode356.g * _EdgesOverlay * PaintColorUV3447 ) ) , ( ( RGBA_Mask_C_Blue557 * BricksColorUV3450 ) * temp_output_38_0 ) , MainShapeSelect298);
			float2 appendResult436 = (float2(( staticSwitch562 * 0.015625 ) , -0.25));
			float2 uv4_TexCoord438 = i.uv4_texcoord4 + appendResult436;
			float4 TransitionUV3443 = tex2D( _MainTex, uv4_TexCoord438 );
			float RGBA_Mask_A_Alpha549 = tex2DNode356.a;
			float4 lerpResult493 = lerp( lerpResult14 , ( TransitionUV3443 * RGBA_Mask_A_Alpha549 * _ChippedPaintBrightness ) , temp_output_537_0);
			float PaintEdges496 = temp_output_482_0;
			float PaintEdgesSelection501 = step( 0.1 , ( ( 1.0 - PaintEdges496 ) * step( _PaintSharpness , PaintEdges496 ) ) );
			float RGBA_Mask_C_Alpha559 = tex2DNode556.a;
			float4 lerpResult428 = lerp( ( lerpResult493 + ( lerpResult493 * ( PaintEdgesSelection501 * _PaintEdgesMultiply ) ) ) , ( TransitionUV3443 * RGBA_Mask_C_Alpha559 * _TransitionBrighthness ) , TransitionSelect234);
			float2 appendResult451 = (float2(temp_output_442_0 , -0.5));
			float2 uv4_TexCoord452 = i.uv4_texcoord4 + appendResult451;
			float4 DirtColorUV3454 = tex2D( _MainTex, uv4_TexCoord452 );
			float RGBA_Mask_A_Blue357 = tex2DNode356.b;
			float3 temp_cast_4 = (( tex2DNode351.b * _DirtMultiplier )).xxx;
			float3 temp_cast_5 = (( 1.0 - i.vertexColor.r )).xxx;
			float DirtHeight74 = saturate( ( 1.0 - ( ( distance( temp_cast_4 , temp_cast_5 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult30 = lerp( lerpResult428 , ( DirtColorUV3454 * RGBA_Mask_A_Blue357 ) , ( DirtHeight74 * _DirtOpacity ));
			float4 Albedo103 = lerpResult30;
			o.Albedo = ( Albedo103 * _Color ).rgb;
			float RedChannelRGBA109 = tex2DNode351.r;
			float RGBA_Mask_B_Blue123 = tex2DNode351.b;
			float Smoothness117 = ( ( _SmoothnessMain * RedChannelRGBA109 * ( 1.0 - RGBA_Mask_B_Blue123 ) ) * ( 1.0 - ( _SmoothnessDamage * Heightmap11 ) ) * ( 1.0 - ( _SmoothnessDirt * DirtHeight74 ) ) * ( 1.0 - ( _PaintSmoothness * ChippedPaintSelection542 ) ) );
			o.Smoothness = Smoothness117;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-2190.206;-316.6879;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;135;-1194.44,1994.971;Inherit;False;2366.052;568.8823;Comment;11;74;25;27;26;24;23;29;2;365;394;455;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;134;-1206.99,2682.982;Inherit;False;2503.377;583.2743;Comment;10;10;9;8;7;5;4;3;171;351;123;Height Selection;0.509434,0.1561944,0.4762029,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;2;-757.2028,2057.218;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-379.7335,2821.213;Float;False;Property;_DamageMultiplier;Damage Multiplier;6;0;Create;True;0;0;0;False;0;False;0.1946161;1.011765;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;351;-907.8105,2704.417;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;22;0;Create;True;0;0;0;False;0;False;-1;None;36dc5c35c19ead2438f7384c005c4dec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;472;-4049.996,-186.3063;Inherit;False;2464.19;1163.684;;21;554;500;499;512;497;498;527;496;557;482;481;479;480;478;491;476;475;556;473;559;501;Paint Selection;0.7075472,0.3504361,0.3504361,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;365;-467.4164,2136.786;Inherit;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-73.46453,2727.668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;455;-262.321,2539.21;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;561;-3094.484,-3112.716;Inherit;False;Property;_CustomColor;Custom Color;32;0;Create;True;0;0;0;False;0;False;0;24;False;0;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;554;-4008.359,-160.4862;Inherit;True;Property;_RGBAMaskC;RGBA Mask C;23;0;Create;True;0;0;0;False;0;False;fc4a808ec7c4a64449ce82e3dde090ed;fc4a808ec7c4a64449ce82e3dde090ed;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.IntNode;433;-3031.63,-3272.782;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;2;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;432;-2533.093,-3517.641;Inherit;False;1976.506;1065.818;Comment;21;454;453;452;451;450;449;448;447;446;445;444;443;442;441;440;439;438;437;436;435;434;UV3 Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;473;-3500.345,67.26288;Inherit;False;365;VertexBlue;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;556;-3694.912,220.776;Inherit;True;Property;_TextureSample5;Texture Sample 5;37;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;146.5747,3068.162;Float;False;Property;_DamageAmount;Damage Amount;4;0;Create;True;0;0;0;False;0;False;0.421177;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;206.9929,2720.801;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;434;-2479.966,-2968.256;Inherit;False;Constant;_4Row;4 Row;33;0;Create;True;0;0;0;False;0;False;0.015625;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;475;-3290.345,71.26288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;562;-2777.797,-3136.974;Inherit;False;Property;_UseCustomColor;Use Custom Color;31;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;437;-2474.216,-3461.531;Half;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;476;-3092.47,75.45566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;491;-3489.9,-153.9644;Inherit;True;Property;_TextureSample4;Texture Sample 4;31;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;442;-2150.684,-2790.989;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;422.6602,2757.365;Float;False;Property;_DamageSmoothness;Damage Smoothness;5;0;Create;True;0;0;0;False;0;False;0;7.554716;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;171;-244.2357,2891.214;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;534.6979,3006.103;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;478;-3035.993,415.0668;Inherit;False;Property;_PaintBareSmooth;Paint Bare Smooth;10;0;Create;True;0;0;0;False;0;False;0;0.137882;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;479;-2910.001,-3.531291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;445;-1966.894,-2588.187;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;481;-2943.47,177.3946;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;-3066.359,278.0897;Inherit;False;Property;_PaintBareRange;Paint Bare Range;11;0;Create;True;0;0;0;False;0;False;0;0.2841567;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;441;-2040.041,-3451.94;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.HeightMapBlendNode;10;734.6751,2888.11;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;471;-2560.028,-2346.793;Inherit;False;5811.946;1825.076;Comment;49;461;103;30;428;42;154;493;467;358;153;75;465;431;357;522;14;457;68;206;507;312;33;107;508;38;469;468;108;392;39;356;517;359;516;532;537;538;539;533;541;520;542;549;550;531;519;518;558;560;Albedo;0.2337576,0.4811321,0.444901,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;439;-1788.671,-3293.953;Inherit;True;Property;_MainTex;Color Theme;1;0;Create;False;0;0;0;False;0;False;fb0e05ef0dc56c643af47507dafa28c9;fb0e05ef0dc56c643af47507dafa28c9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;448;-1686.066,-2615.64;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;1122.697,2788.105;Inherit;False;Heightmap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;444;-1721.396,-3468.641;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.09,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;482;-2719.83,186.1267;Inherit;False;Color Mask;-1;;46;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;347;1466.574,2661.82;Inherit;False;1643.551;654.2539;Comment;5;234;311;298;427;403;Edges Selection;0.257921,0.3129856,0.3396226,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;435;-2138.236,-3096.744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;496;-2484.384,421.4072;Inherit;False;PaintEdges;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;446;-1323.982,-3336.27;Inherit;True;Property;_TextureSample0;Texture Sample 0;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;449;-1321.735,-2707.77;Inherit;True;Property;_TextureSample1;Texture Sample 1;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;436;-1973.106,-2977.208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.25;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;311;1584.04,2713.125;Inherit;False;2;0;FLOAT;0.06;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;359;-2298.368,-2187.763;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;21;0;Create;True;0;0;0;False;0;False;c5b8bd607021dc54688766ddf7b34f7e;c5b8bd607021dc54688766ddf7b34f7e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;527;-2559.476,679.1678;Inherit;False;Property;_PaintSharpness;Paint Sharpness;9;0;Create;True;0;0;0;False;0;False;0;0.05448932;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;497;-2257.984,430.9422;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;557;-3310.091,384.1233;Inherit;False;RGBA_Mask_C_Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1234.936,-1754.07;Inherit;False;Property;_EdgesMultiply;Edges Multiply;3;0;Create;True;0;0;0;False;0;False;0;0.127;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;498;-2223.333,666.5544;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;447;-915.4203,-3339.346;Inherit;False;PaintColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;450;-916.4847,-2694.496;Inherit;False;BricksColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;438;-1720.289,-3014.156;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;298;1804.173,2711.446;Inherit;False;MainShapeSelect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;356;-1422.46,-2173.42;Inherit;True;Property;_DrywallMasksRGBA;Drywall Masks RGBA;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-748.8354,-2050.87;Inherit;False;Property;_EdgesOverlay;Edges Overlay;2;0;Create;True;0;0;0;False;0;False;0;0.99;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;518;-553.2474,-609.2643;Inherit;False;298;MainShapeSelect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;512;-2287.345,183.5659;Inherit;False;PaintConcreteSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;392;-704.22,-1934.445;Inherit;False;447;PaintColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;403;1612.396,2990.228;Inherit;False;HeightDamage;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;558;-2109.802,-1573.358;Inherit;False;557;RGBA_Mask_C_Blue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;499;-2082.503,436.5532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;-914.0545,-1879.05;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;468;-2120.228,-1232.99;Inherit;False;450;BricksColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;440;-1312.004,-3138.886;Inherit;True;Property;_TextureSample2;Texture Sample 2;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;469;-1724.345,-1439.198;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;405;2022.787,2964.644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;443;-976.4545,-3151.179;Inherit;False;TransitionUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;549;-1268.053,-1540.746;Inherit;False;RGBA_Mask_A_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;406;2041.7,3134.671;Inherit;False;2;0;FLOAT;0.06;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;500;-1949.727,428.6552;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-462.3109,-1759.892;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;516;-552.943,-733.6182;Inherit;False;512;PaintConcreteSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;519;-312.796,-606.6918;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;353;-596.3284,2323.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-298.451,-2127.203;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;354;-503.7858,2262.255;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-141.1315,2314.786;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;20;0;Create;True;0;0;0;False;0;False;0;1.8;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;550;-340.3118,-1124.957;Inherit;False;549;RGBA_Mask_A_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-783.6109,-1434.568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;508;-314.5325,-1194.106;Inherit;False;443;TransitionUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;517;-140.0878,-731.4105;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;206;-172.4041,-1740.326;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;404;2234.64,2971.578;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-394.5615,-1343.984;Inherit;False;298;MainShapeSelect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;501;-1846.885,434.8227;Inherit;False;PaintEdgesSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;451;-1970.324,-2779.125;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;541;-346.5269,-1000.985;Inherit;False;Property;_ChippedPaintBrightness;Chipped Paint Brightness;30;0;Create;True;0;0;0;False;0;False;0;0.7164301;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;271.6346,2330.272;Inherit;False;Property;_DirtRange;Dirt Range;18;0;Create;True;0;0;0;False;0;False;0;0.1642492;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;537;97.52898,-821.8026;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;281.0203,2428.742;Inherit;False;Property;_DirtSmooth;Dirt Smooth;19;0;Create;True;0;0;0;False;0;False;0;0.6499785;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;193.5245,2211.745;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;239.8916,2038.183;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;427;2404.476,2850.879;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;-6.016148,-1459.435;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;452;-1710.507,-2817.073;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;507;32.96743,-1187.094;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;532;478.6758,-1132.002;Inherit;False;501;PaintEdgesSelection;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;531;454.3657,-1021.835;Inherit;False;Property;_PaintEdgesMultiply;Paint Edges Multiply;12;0;Create;True;0;0;0;False;0;False;1;0.7249268;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;559;-3325.349,497.8126;Inherit;False;RGBA_Mask_C_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;542;286.0273,-778.1387;Inherit;False;ChippedPaintSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;606.6013,2052.965;Inherit;False;Color Mask;-1;;47;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-1186.52,1212.228;Inherit;False;2217.59;772.2878;Normals;15;92;421;20;422;419;192;511;19;525;368;420;526;544;414;456;Normals;0.0572713,0.3924344,0.9339623,1;0;0
Node;AmplifyShaderEditor.LerpOp;493;417.1435,-1493.812;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;411;2560.331,2966.05;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;453;-1315.606,-2925.671;Inherit;True;Property;_TextureSample3;Texture Sample 3;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;741.1937,-1057.137;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-1193.983,29.06497;Inherit;False;1432.054;1002.007;Comment;17;100;79;116;85;114;115;102;117;77;111;124;129;110;101;149;543;545;Smoothness;0.8113208,0.2411,0.2411,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;2683.256,2887.833;Inherit;False;TransitionSelect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-894.0018,1875.326;Inherit;False;Property;_ChippedPaintScale;Chipped Paint Scale;29;0;Create;True;0;0;0;False;0;False;0;0.6712158;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;927.6121,2044.972;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;544;-902.4153,1796.298;Inherit;False;542;ChippedPaintSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-544.9074,2925.021;Inherit;False;RGBA_Mask_B_Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;560;708.0324,-1860.815;Inherit;False;559;RGBA_Mask_C_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;457;726.3074,-1978.714;Inherit;False;443;TransitionUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;539;796.3911,-1304.731;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;-1235.504,-1606.14;Inherit;False;RGBA_Mask_A_Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;454;-939.9523,-2907.292;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;522;722.6014,-1778.297;Inherit;False;Property;_TransitionBrighthness;Transition Brighthness;24;0;Create;True;0;0;0;False;0;False;0;1;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-1093.801,745.4269;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;545;-1121.522,923.387;Inherit;False;542;ChippedPaintSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-588.2394,1770.069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1125.543,647.5803;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;27;0;Create;True;0;0;0;False;0;False;0;0.717;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-1097.268,570.8107;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;420;-721.9943,1682.005;Inherit;False;298;MainShapeSelect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;456;-1158.028,1297.584;Inherit;False;Property;_PaintDamageNMScale;Paint Damage NM Scale;16;0;Create;True;0;0;0;False;0;False;1;1.686;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-477.5917,2710.007;Inherit;False;RedChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1106.073,471.4499;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;26;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;368;-1141.677,1537.644;Inherit;False;Property;_PaintNMScale;Paint NM Scale;8;0;Create;True;0;0;0;False;0;False;1;1;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;543;-1096.017,849.2885;Inherit;False;Property;_PaintSmoothness;Paint Smoothness;28;0;Create;True;0;0;0;False;0;False;0;0.703;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;431;1161.991,-1219.53;Inherit;False;234;TransitionSelect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;1962.811,-911.7857;Inherit;False;Property;_DirtOpacity;Dirt Opacity;17;0;Create;True;0;0;0;False;0;False;0;0.6802217;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;2021.985,-1019.806;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;538;938.81,-1481.365;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;1813.07,-1180.011;Inherit;False;357;RGBA_Mask_A_Blue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;1127.17,-1826.628;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;465;1826.139,-1271.987;Inherit;False;454;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1117.612,285.4723;Inherit;False;123;RGBA_Mask_B_Blue;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1126.983,80.06497;Inherit;False;Property;_SmoothnessMain;Smoothness Main;25;0;Create;True;0;0;0;False;0;False;0;0.597;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-727.8657,519.7764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;546;-662.5221,917.387;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;414;-816.5972,1247.892;Inherit;True;Property;_PaintDamageNM;Paint Damage NM;15;0;Create;True;0;0;0;False;0;False;-1;None;d1d411d7a31f14d49b99e9c1fa51f3c4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;2272.441,-942.821;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-696.8444,730.9177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-326.2736,1459.711;Inherit;False;Property;_TransitionNMScale;Transition NM Scale;14;0;Create;True;0;0;0;False;0;False;0;1;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;511;-442.0588,1670.912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-751.0742,232.9651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1125.76,166.7284;Inherit;False;109;RedChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;2177.072,-1247.505;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;428;1367.317,-1485.967;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-816.5949,1466.751;Inherit;True;Property;_PaintNM;Paint NM;7;0;Create;True;0;0;0;False;0;False;-1;627acaa140421924586f777a2c9b082e;627acaa140421924586f777a2c9b082e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-34.91782,1359.43;Inherit;True;Property;_TransitionNM;Transition NM;13;0;Create;True;0;0;0;False;0;False;-1;58b2fbb6335706a479441801837ecb0e;58b2fbb6335706a479441801837ecb0e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;419;-356.6055,1292.776;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;422;72.38788,1590.532;Inherit;False;234;TransitionSelect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;-524.359,517.9059;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-499.9178,735.4039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-528.6514,82.48871;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;2396.641,-1459.204;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;547;-478.4636,865.1716;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;2967.738,-1474.061;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-196.4505,79.16676;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;421;378.1456,1299.306;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;564;3000.686,578.0137;Inherit;False;Property;_Color;Color;33;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;104;3020.374,853.2759;Inherit;False;103;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;678.4165,1301.041;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;25.69324,84.30206;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;3092.935,1072.717;Inherit;False;117;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;563;3254.605,793.6759;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;520;60.68848,-618.5786;Inherit;False;DamageInsideSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;461;-1029.856,-2246.793;Inherit;False;RGBA_Mask_A_Red;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;394;-473.0793,2176.715;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;3101.059,954.5488;Inherit;False;92;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3443.114,935.8339;Float;False;True;-1;2;;0;0;Standard;DBK/Cinderblock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;365;0;2;3
WireConnection;4;0;351;1
WireConnection;4;1;3;0
WireConnection;455;0;2;2
WireConnection;556;0;554;0
WireConnection;5;0;4;0
WireConnection;5;1;455;0
WireConnection;475;0;473;0
WireConnection;562;1;433;0
WireConnection;562;0;561;0
WireConnection;476;0;475;0
WireConnection;476;1;556;2
WireConnection;491;0;554;0
WireConnection;442;0;562;0
WireConnection;442;1;434;0
WireConnection;171;0;351;2
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;479;0;491;1
WireConnection;445;0;442;0
WireConnection;481;0;476;0
WireConnection;441;0;437;0
WireConnection;441;1;562;0
WireConnection;10;0;171;0
WireConnection;10;1;9;0
WireConnection;10;2;8;0
WireConnection;448;1;445;0
WireConnection;11;0;10;0
WireConnection;444;1;441;0
WireConnection;482;1;481;0
WireConnection;482;3;479;0
WireConnection;482;4;480;0
WireConnection;482;5;478;0
WireConnection;435;0;562;0
WireConnection;435;1;434;0
WireConnection;496;0;482;0
WireConnection;446;0;439;0
WireConnection;446;1;444;0
WireConnection;449;0;439;0
WireConnection;449;1;448;0
WireConnection;436;0;435;0
WireConnection;311;1;11;0
WireConnection;497;0;496;0
WireConnection;557;0;556;3
WireConnection;498;0;527;0
WireConnection;498;1;496;0
WireConnection;447;0;446;0
WireConnection;450;0;449;0
WireConnection;438;1;436;0
WireConnection;298;0;311;0
WireConnection;356;0;359;0
WireConnection;512;0;482;0
WireConnection;403;0;11;0
WireConnection;499;0;497;0
WireConnection;499;1;498;0
WireConnection;38;0;356;1
WireConnection;38;1;39;0
WireConnection;440;0;439;0
WireConnection;440;1;438;0
WireConnection;469;0;558;0
WireConnection;469;1;468;0
WireConnection;405;0;403;0
WireConnection;443;0;440;0
WireConnection;549;0;356;4
WireConnection;406;1;403;0
WireConnection;500;1;499;0
WireConnection;33;0;392;0
WireConnection;33;1;38;0
WireConnection;519;0;518;0
WireConnection;353;0;351;3
WireConnection;107;0;356;2
WireConnection;107;1;108;0
WireConnection;107;2;392;0
WireConnection;354;0;353;0
WireConnection;68;0;469;0
WireConnection;68;1;38;0
WireConnection;517;0;516;0
WireConnection;517;1;519;0
WireConnection;206;0;33;0
WireConnection;206;1;107;0
WireConnection;404;0;405;0
WireConnection;404;1;406;0
WireConnection;501;0;500;0
WireConnection;451;0;442;0
WireConnection;537;1;517;0
WireConnection;27;0;354;0
WireConnection;27;1;29;0
WireConnection;26;0;2;1
WireConnection;427;1;404;0
WireConnection;14;0;206;0
WireConnection;14;1;68;0
WireConnection;14;2;312;0
WireConnection;452;1;451;0
WireConnection;507;0;508;0
WireConnection;507;1;550;0
WireConnection;507;2;541;0
WireConnection;559;0;556;4
WireConnection;542;0;537;0
WireConnection;25;1;26;0
WireConnection;25;3;27;0
WireConnection;25;4;23;0
WireConnection;25;5;24;0
WireConnection;493;0;14;0
WireConnection;493;1;507;0
WireConnection;493;2;537;0
WireConnection;411;0;427;0
WireConnection;453;0;439;0
WireConnection;453;1;452;0
WireConnection;533;0;532;0
WireConnection;533;1;531;0
WireConnection;234;0;411;0
WireConnection;74;0;25;0
WireConnection;123;0;351;3
WireConnection;539;0;493;0
WireConnection;539;1;533;0
WireConnection;357;0;356;3
WireConnection;454;0;453;0
WireConnection;525;0;544;0
WireConnection;525;1;526;0
WireConnection;109;0;351;1
WireConnection;538;0;493;0
WireConnection;538;1;539;0
WireConnection;467;0;457;0
WireConnection;467;1;560;0
WireConnection;467;2;522;0
WireConnection;100;0;79;0
WireConnection;100;1;149;0
WireConnection;546;0;543;0
WireConnection;546;1;545;0
WireConnection;414;5;456;0
WireConnection;154;0;75;0
WireConnection;154;1;153;0
WireConnection;114;0;116;0
WireConnection;114;1;85;0
WireConnection;511;0;420;0
WireConnection;511;1;525;0
WireConnection;129;0;124;0
WireConnection;42;0;465;0
WireConnection;42;1;358;0
WireConnection;428;0;538;0
WireConnection;428;1;467;0
WireConnection;428;2;431;0
WireConnection;19;5;368;0
WireConnection;20;5;192;0
WireConnection;419;0;19;0
WireConnection;419;1;414;0
WireConnection;419;2;511;0
WireConnection;101;0;100;0
WireConnection;115;0;114;0
WireConnection;110;0;77;0
WireConnection;110;1;111;0
WireConnection;110;2;129;0
WireConnection;30;0;428;0
WireConnection;30;1;42;0
WireConnection;30;2;154;0
WireConnection;547;0;546;0
WireConnection;103;0;30;0
WireConnection;102;0;110;0
WireConnection;102;1;101;0
WireConnection;102;2;115;0
WireConnection;102;3;547;0
WireConnection;421;0;419;0
WireConnection;421;1;20;0
WireConnection;421;2;422;0
WireConnection;92;0;421;0
WireConnection;117;0;102;0
WireConnection;563;0;104;0
WireConnection;563;1;564;0
WireConnection;520;0;517;0
WireConnection;461;0;356;1
WireConnection;394;0;2;4
WireConnection;0;0;563;0
WireConnection;0;1;93;0
WireConnection;0;4;118;0
ASEEND*/
//CHKSM=12F5B8F6B9564EEBB05F34D52CECA4E118C5FF03