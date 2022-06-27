// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Drywall"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_EdgesOverlay("Edges Overlay", Range( 0 , 2)) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_EdgesMultiply("Edges Multiply", Range( 0 , 1)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0.421177
		_DamageSmoothness("Damage Smoothness", Range( 0 , 10)) = 0
		_DamageMultiplier("Damage Multiplier", Range( 0 , 3)) = 0.1946161
		_DrywallNM("Drywall NM", 2D) = "bump" {}
		_DrywallNmScale("Drywall Nm Scale", Range( 1 , 2)) = 1
		_DamageNMScale("Damage NM Scale", Range( 0 , 2)) = 0
		_DrywallDamageNM("Drywall Damage NM", 2D) = "bump" {}
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 4)) = 0
		_DirtBrightness("Dirt Brightness", Range( 0 , 2)) = 0
		_TransitionAmount("Transition Amount", Range( 0 , 0.5)) = 0
		_TransitionBrightness("Transition Brightness", Range( 0 , 0.25)) = 0
		_ExtraTransition("Extra Transition", Range( 0 , 1)) = 0
		_ExtraTransitionRange("Extra Transition Range", Range( 0 , 1)) = 0
		_EdgeBrightness("Edge Brightness", Range( 0.01 , 1)) = 0
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_SmoothnessMain("Smoothness Main", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_InsideBrightness("Inside Brightness", Range( 0 , 1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Toggle(_USECUSTOMCOLOR_ON)] _UseCustomColor("Use Custom Color", Float) = 0
		_CustomColor("Custom Color", Int) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
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
			float2 uv4_texcoord4;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform sampler2D _DrywallNM;
		uniform float4 _DrywallNM_ST;
		uniform float _DrywallNmScale;
		uniform sampler2D _DrywallDamageNM;
		uniform float4 _DrywallDamageNM_ST;
		uniform float _DamageNMScale;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _DamageMultiplier;
		uniform float _DamageAmount;
		uniform float _DamageSmoothness;
		uniform float _TransitionAmount;
		uniform float _ExtraTransition;
		uniform float _ExtraTransitionRange;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _EdgeBrightness;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform float _EdgesMultiply;
		uniform float _EdgesOverlay;
		uniform float _TransitionBrightness;
		uniform float _DirtBrightness;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float _InsideBrightness;
		uniform float4 _Color;
		uniform float _SmoothnessMain;
		uniform float _SmoothnessDamage;
		uniform float _SmoothnessDirt;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv4_DrywallNM = i.uv4_texcoord4 * _DrywallNM_ST.xy + _DrywallNM_ST.zw;
			float2 uv4_DrywallDamageNM = i.uv4_texcoord4 * _DrywallDamageNM_ST.xy + _DrywallDamageNM_ST.zw;
			float2 uv4_RGBAMaskA = i.uv4_texcoord4 * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode351 = tex2D( _RGBAMaskA, uv4_RGBAMaskA );
			float HeightMask10 = saturate(pow(((( 1.0 - tex2DNode351.g )*( ( ( tex2DNode351.r * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount ))*4)+(( ( ( tex2DNode351.r * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount )*2),_DamageSmoothness));
			float Heightmap11 = HeightMask10;
			float temp_output_311_0 = step( 0.1 , Heightmap11 );
			float HeightBricks227 = Heightmap11;
			float DrywallStep234 = ( temp_output_311_0 * ( 1.0 - step( 0.1 , ( ( 1.0 - HeightBricks227 ) * step( _TransitionAmount , HeightBricks227 ) ) ) ) );
			float RedChannelRGBA109 = tex2DNode351.r;
			float3 temp_cast_0 = (pow( RedChannelRGBA109 , _ExtraTransition )).xxx;
			float VertexBlue365 = i.vertexColor.b;
			float3 temp_cast_1 = (( 1.0 - VertexBlue365 )).xxx;
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode363 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float3 temp_cast_2 = (pow( ( 1.0 - tex2DNode363.a ) , _EdgeBrightness )).xxx;
			float3 desaturateInitialColor341 = temp_cast_2;
			float desaturateDot341 = dot( desaturateInitialColor341, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar341 = lerp( desaturateInitialColor341, desaturateDot341.xxx, 1.0 );
			float3 CutoutEdges342 = desaturateVar341;
			float3 clampResult346 = clamp( CutoutEdges342 , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float3 temp_output_327_0 = ( DrywallStep234 * ( ( 1.0 - step( 0.1 , ( 1.0 - saturate( ( 1.0 - ( ( distance( temp_cast_0 , temp_cast_1 ) - _ExtraTransitionRange ) / max( 1.0 , 1E-05 ) ) ) ) ) ) ) + clampResult346 ) );
			float3 EdgesDamages199 = temp_output_327_0;
			float3 lerpResult21 = lerp( UnpackScaleNormal( tex2D( _DrywallNM, uv4_DrywallNM ), _DrywallNmScale ) , UnpackScaleNormal( tex2D( _DrywallDamageNM, uv4_DrywallDamageNM ), _DamageNMScale ) , EdgesDamages199);
			float3 Normals92 = lerpResult21;
			o.Normal = Normals92;
			half2 _ColorsNumber = half2(0,-0.1);
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch415 = (float)_CustomColor;
			#else
				float staticSwitch415 = (float)_ColorSelect;
			#endif
			float2 temp_output_404_0 = ( half2( 0.015625,0 ) * staticSwitch415 );
			float2 uv_TexCoord406 = i.uv_texcoord * _ColorsNumber + temp_output_404_0;
			float4 PaintColorUV3389 = tex2D( _MainTex, uv_TexCoord406 );
			float2 uv4_RGBAMaskB = i.uv4_texcoord4 * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode356 = tex2D( _RGBAMaskB, uv4_RGBAMaskB );
			float temp_output_38_0 = pow( tex2DNode356.r , _EdgesMultiply );
			float2 appendResult405 = (float2(temp_output_404_0.x , 0.5));
			float2 uv_TexCoord410 = i.uv_texcoord * _ColorsNumber + appendResult405;
			float4 PaperColorUV3388 = tex2D( _MainTex, uv_TexCoord410 );
			float CombinedWhiteEdges298 = temp_output_311_0;
			float4 lerpResult14 = lerp( ( ( PaintColorUV3389 * temp_output_38_0 ) + ( tex2DNode356.g * _EdgesOverlay * PaintColorUV3389 ) ) , ( PaperColorUV3388 * temp_output_38_0 ) , CombinedWhiteEdges298);
			float2 appendResult408 = (float2(temp_output_404_0.x , 0.1));
			float2 uv_TexCoord409 = i.uv_texcoord * _ColorsNumber + appendResult408;
			float4 DirtColorUV3390 = tex2D( _MainTex, uv_TexCoord409 );
			float MasksBlueChannel357 = tex2DNode356.b;
			float3 temp_cast_8 = (( tex2DNode351.b * _DirtMultiplier )).xxx;
			float3 temp_cast_9 = (( 1.0 - i.vertexColor.r )).xxx;
			float DirtHeight74 = saturate( ( 1.0 - ( ( distance( temp_cast_8 , temp_cast_9 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult30 = lerp( ( lerpResult14 + float4( ( _TransitionBrightness * temp_output_327_0 ) , 0.0 ) ) , ( DirtColorUV3390 * _DirtBrightness * MasksBlueChannel357 ) , ( DirtHeight74 * _DirtOpacity ));
			float VertexAlpha394 = i.vertexColor.a;
			float4 Albedo103 = ( lerpResult30 + ( _InsideBrightness * VertexAlpha394 ) );
			o.Albedo = ( Albedo103 * _Color ).rgb;
			float GreenChannelRGBA123 = tex2DNode351.b;
			float Smoothness117 = ( ( _SmoothnessMain * RedChannelRGBA109 * ( 1.0 - GreenChannelRGBA123 ) ) * ( 1.0 - ( _SmoothnessDamage * Heightmap11 ) ) * ( 1.0 - ( _SmoothnessDirt * DirtHeight74 ) ) );
			o.Smoothness = Smoothness117;
			o.Alpha = 1;
			float OpacityMask348 = tex2DNode363.a;
			clip( OpacityMask348 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-2288.99;-370.4757;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;134;-1206.99,2682.982;Inherit;False;2503.377;583.2743;Comment;11;109;10;9;8;7;5;4;3;171;351;123;Height Selection;0.509434,0.1561944,0.4762029,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-379.7335,2821.213;Float;False;Property;_DamageMultiplier;Damage Multiplier;6;0;Create;True;0;0;0;False;0;False;0.1946161;0.9764708;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;135;-1194.44,1994.971;Inherit;False;2366.052;568.8823;Comment;10;74;25;27;26;24;23;29;2;365;394;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.SamplerNode;351;-912.1873,2715.417;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;21;0;Create;True;0;0;0;False;0;False;-1;None;52c51b0aba2d52049a0039ac53b25058;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-757.2028,2057.218;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-84.46453,2719.668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;146.5747,3068.162;Float;False;Property;_DamageAmount;Damage Amount;4;0;Create;True;0;0;0;False;0;False;0.421177;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;206.9929,2720.801;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;417.6602,2771.365;Float;False;Property;_DamageSmoothness;Damage Smoothness;5;0;Create;True;0;0;0;False;0;False;0;2.157442;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;543.3022,3001.186;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;171;-171.0711,2935.237;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;10;734.6751,2888.11;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1273.509,-1917.229;Inherit;False;4564.586;1775.997;Comment;46;103;30;177;154;199;14;75;175;153;327;206;173;68;312;107;33;317;343;38;108;334;187;39;184;181;182;188;183;189;185;344;346;352;356;357;358;359;366;392;393;398;396;399;395;417;416;Albedo;0.3837695,0.9528302,0.2382075,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;400;613.1146,-2901.809;Inherit;False;2118.08;820.5428;Comment;18;401;414;415;390;412;409;388;408;413;389;410;411;405;406;407;403;404;402;Color Selection;0.1367925,0.7533706,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;350;-860.0266,-2467.628;Inherit;False;1262.172;492.4163;;7;339;338;340;348;341;342;363;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;1115.904,2810.507;Inherit;False;Heightmap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;347;1507.2,2636.428;Inherit;False;1643.551;654.2539;Comment;11;227;230;229;231;232;314;315;234;311;298;228;Edges Selection;0.257921,0.3129856,0.3396226,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;359;-1201.896,-1850.589;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;22;0;Create;True;0;0;0;False;0;False;1e202a45b34cf0a40a1bbdd395ef58be;1e202a45b34cf0a40a1bbdd395ef58be;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;365;-508.8416,2215.643;Inherit;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;227;1612.87,2929.494;Inherit;False;HeightBricks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;363;-825.0666,-2399.31;Inherit;True;Property;_Alpha;Alpha;29;0;Create;True;0;0;0;False;0;False;-1;None;1e202a45b34cf0a40a1bbdd395ef58be;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;414;656.4115,-2395.22;Inherit;False;Property;_CustomColor;Custom Color;29;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;1592.433,3147.998;Inherit;False;Property;_TransitionAmount;Transition Amount;16;0;Create;True;0;0;0;False;0;False;0;0.2578627;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-489.5917,2971.007;Inherit;False;RedChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;401;670.4244,-2498.637;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.OneMinusNode;230;1915.815,2903.79;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;498.4656,-1639.217;Inherit;False;109;RedChannelRGBA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;-590.2468,-2143.214;Inherit;False;Property;_EdgeBrightness;Edge Brightness;20;0;Create;True;0;0;0;False;0;False;0;0.071;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;526.2505,-1510.852;Inherit;False;Property;_ExtraTransition;Extra Transition;18;0;Create;True;0;0;0;False;0;False;0;0.6327256;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;592.4382,-1748.618;Inherit;False;365;VertexBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;229;2006.143,3157.682;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;339;-471.6558,-2288.222;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;415;855.4115,-2516.22;Inherit;False;Property;_UseCustomColor;Use Custom Color;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;402;782.9074,-2807.669;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;188;836.25,-1580.852;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;558.202,-1327.611;Inherit;False;Constant;_ExtraTransitionSmooth;Extra Transition Smooth;30;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;340;-246.2454,-2271.213;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;560.2022,-1423.612;Inherit;False;Property;_ExtraTransitionRange;Extra Transition Range;19;0;Create;True;0;0;0;False;0;False;0;0.9323106;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;403;1156.902,-2880.788;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;2177.681,2918.334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;185;822.0997,-1670.922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;404;1106.205,-2688.476;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;406;1590.794,-2828.689;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;232;2346.498,2911.74;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;405;1317.199,-2396.903;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;407;1591.359,-2680.99;Inherit;True;Property;_MainTex;Color Theme;2;0;Create;False;0;0;0;False;0;False;bb0f9730de8f0ca408817cf80c16d43b;bb0f9730de8f0ca408817cf80c16d43b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;181;1034.265,-1597.46;Inherit;False;Color Mask;-1;;42;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;341;-56.35638,-2273.473;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;411;2015.904,-2828.584;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;342;159.1468,-2270.973;Inherit;False;CutoutEdges;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;410;1584.364,-2415.315;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;184;1275.752,-1597.97;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;314;2514.828,2880.308;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;353;-596.3284,2323.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;311;1563.817,2741.708;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;356;-872.1693,-1849.18;Inherit;True;Property;_DrywallMasksRGBA;Drywall Masks RGBA;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;354;-502.4089,2282.909;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-863.5118,-1535.091;Inherit;False;Property;_EdgesMultiply;Edges Multiply;3;0;Create;True;0;0;0;False;0;False;0;0.2141723;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;1030.834,-1241.397;Inherit;False;342;CutoutEdges;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;389;2468.354,-2709.089;Inherit;False;PaintColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-158.7884,2320.672;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;14;0;Create;True;0;0;0;False;0;False;0;0.49;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;408;1318.737,-2201.968;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;2730.945,2742.357;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;413;2019.105,-2604.217;Inherit;True;Property;_Texture4;Texture4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;187;1332.683,-1452.006;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;2907.751,2744.064;Inherit;False;DrywallStep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;392;-570.7952,-1282.448;Inherit;False;389;PaintColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;334;1482.878,-1442.244;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;241.9845,2061.206;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;281.0203,2428.742;Inherit;False;Property;_DirtSmooth;Dirt Smooth;13;0;Create;True;0;0;0;False;0;False;0;0.5117475;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;346;1286.248,-1245.582;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;388;2459,-2512.793;Inherit;False;PaperColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;271.6346,2330.272;Inherit;False;Property;_DirtRange;Dirt Range;12;0;Create;True;0;0;0;False;0;False;0;0.271;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;-410.5631,-1549.538;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;180.967,2213.838;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-251.3405,-1706.98;Inherit;False;Property;_EdgesOverlay;Edges Overlay;1;0;Create;True;0;0;0;False;0;False;0;0.7000335;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;409;1591.382,-2240.768;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;343;1522.645,-1270.129;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;-605.5667,-476.5;Inherit;False;388;PaperColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-82.56279,-1413.641;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;412;2032.381,-2316.718;Inherit;True;Property;_TextureSample5;Texture Sample 5;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;25;606.6013,2052.965;Inherit;False;Color Mask;-1;;45;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;317;1328.689,-1045.568;Inherit;False;234;DrywallStep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;35.83928,-1815.961;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;298;1807.638,2683.119;Inherit;False;CombinedWhiteEdges;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;1783.245,-1233.628;Inherit;False;Property;_TransitionBrightness;Transition Brightness;17;0;Create;True;0;0;0;False;0;False;0;0.1448386;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-187.7414,-731.4948;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;-465.1458,-1723.602;Inherit;False;MasksBlueChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;206;333.8858,-1403.081;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;927.6121,2044.972;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;1660.998,-1081.641;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;537.1083,-618.2622;Inherit;False;298;CombinedWhiteEdges;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;390;2476.421,-2299.148;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-498.9074,3088.021;Inherit;False;GreenChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;1930.634,-318.5371;Inherit;False;Property;_DirtOpacity;Dirt Opacity;11;0;Create;True;0;0;0;False;0;False;0;0.4645321;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;1359.052,-634.0307;Inherit;False;390;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;394;-504.3716,2401.103;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;416;1344.088,-540.0545;Inherit;False;Property;_DirtBrightness;Dirt Brightness;15;0;Create;True;0;0;0;False;0;False;0;1.872941;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;1385.167,-422.9358;Inherit;False;357;MasksBlueChannel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;1983.256,-441.9628;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-1193.983,29.06497;Inherit;False;1432.054;1002.007;Comment;15;100;79;116;85;114;115;102;117;77;111;124;129;110;101;149;Smoothness;0.8113208,0.2411,0.2411,1;0;0
Node;AmplifyShaderEditor.LerpOp;14;825.8331,-754.7638;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;1972.99,-1104.617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;2346.555,-845.7107;Inherit;False;394;VertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;1660.119,-568.0616;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;396;2164.555,-983.7107;Inherit;False;Property;_InsideBrightness;Inside Brightness;26;0;Create;True;0;0;0;False;0;False;0;0.032;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;2241.74,-405.4815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;2026.856,-740.748;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-1097.268,570.8107;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1118.543,769.5803;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;25;0;Create;True;0;0;0;False;0;False;0;0.717;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1106.073,471.4499;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;24;0;Create;True;0;0;0;False;0;False;0;0.9162138;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1127.612,277.4723;Inherit;False;123;GreenChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-1192.5,1212.228;Inherit;False;1234.106;667.8091;Normals;7;192;92;21;20;19;225;368;Normals;0.0572713,0.3924344,0.9339623,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-1086.801,867.4269;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-727.8657,519.7764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;397;2545.555,-942.7107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;2412.346,-743.7818;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1125.76,166.7284;Inherit;False;109;RedChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;368;-1149.677,1332.773;Inherit;False;Property;_DrywallNmScale;Drywall Nm Scale;8;0;Create;True;0;0;0;False;0;False;1;1;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1144.983,74.06497;Inherit;False;Property;_SmoothnessMain;Smoothness Main;23;0;Create;True;0;0;0;False;0;False;0;0.3685294;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;1751.13,-951.6766;Inherit;False;EdgesDamages;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-689.8444,852.9177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1144.763,1696.468;Inherit;False;Property;_DamageNMScale;Damage NM Scale;9;0;Create;True;0;0;0;False;0;False;0;1.142248;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-751.0742,232.9651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-852.5544,1259.228;Inherit;True;Property;_DrywallNM;Drywall NM;7;0;Create;True;0;0;0;False;0;False;-1;627acaa140421924586f777a2c9b082e;627acaa140421924586f777a2c9b082e;True;3;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;225;-831.1521,1510.938;Inherit;False;199;EdgesDamages;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;101;-524.359,517.9059;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-492.9178,857.4039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-528.6514,82.48871;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-859.0859,1612.038;Inherit;True;Property;_DrywallDamageNM;Drywall Damage NM;10;0;Create;True;0;0;0;False;0;False;-1;627acaa140421924586f777a2c9b082e;4ea5083d09e1aa747b5ad9a32ad2cb74;True;3;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;395;2718.108,-737.2672;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;2949.186,-739.2769;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-196.4505,79.16676;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-422.4622,1472.899;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;348;-442.2703,-2401.564;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;3048.374,823.2759;Inherit;False;103;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-206.3949,1304.129;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;25.69324,84.30206;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;419;3036.531,631.6446;Inherit;False;Property;_Color;Color;30;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;93;3109.059,980.5488;Inherit;False;92;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;3133.195,1208.616;Inherit;False;348;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;3094.935,1089.717;Inherit;False;117;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;418;3281.45,798.3068;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3443.114,935.8339;Float;False;True;-1;4;;0;0;Standard;DBK/Drywall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;27;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;351;1
WireConnection;4;1;3;0
WireConnection;5;0;4;0
WireConnection;5;1;2;2
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;171;0;351;2
WireConnection;10;0;171;0
WireConnection;10;1;9;0
WireConnection;10;2;8;0
WireConnection;11;0;10;0
WireConnection;365;0;2;3
WireConnection;227;0;11;0
WireConnection;363;0;359;0
WireConnection;109;0;351;1
WireConnection;230;0;227;0
WireConnection;229;0;228;0
WireConnection;229;1;227;0
WireConnection;339;0;363;4
WireConnection;415;1;401;0
WireConnection;415;0;414;0
WireConnection;188;0;352;0
WireConnection;188;1;189;0
WireConnection;340;0;339;0
WireConnection;340;1;338;0
WireConnection;231;0;230;0
WireConnection;231;1;229;0
WireConnection;185;0;366;0
WireConnection;404;0;402;0
WireConnection;404;1;415;0
WireConnection;406;0;403;0
WireConnection;406;1;404;0
WireConnection;232;1;231;0
WireConnection;405;0;404;0
WireConnection;181;1;185;0
WireConnection;181;3;188;0
WireConnection;181;4;182;0
WireConnection;181;5;183;0
WireConnection;341;0;340;0
WireConnection;411;0;407;0
WireConnection;411;1;406;0
WireConnection;342;0;341;0
WireConnection;410;0;403;0
WireConnection;410;1;405;0
WireConnection;184;0;181;0
WireConnection;314;0;232;0
WireConnection;353;0;351;3
WireConnection;311;1;11;0
WireConnection;356;0;359;0
WireConnection;354;0;353;0
WireConnection;389;0;411;0
WireConnection;408;0;404;0
WireConnection;315;0;311;0
WireConnection;315;1;314;0
WireConnection;413;0;407;0
WireConnection;413;1;410;0
WireConnection;187;1;184;0
WireConnection;234;0;315;0
WireConnection;334;0;187;0
WireConnection;26;0;2;1
WireConnection;346;0;344;0
WireConnection;388;0;413;0
WireConnection;38;0;356;1
WireConnection;38;1;39;0
WireConnection;27;0;354;0
WireConnection;27;1;29;0
WireConnection;409;0;403;0
WireConnection;409;1;408;0
WireConnection;343;0;334;0
WireConnection;343;1;346;0
WireConnection;33;0;392;0
WireConnection;33;1;38;0
WireConnection;412;0;407;0
WireConnection;412;1;409;0
WireConnection;25;1;26;0
WireConnection;25;3;27;0
WireConnection;25;4;23;0
WireConnection;25;5;24;0
WireConnection;107;0;356;2
WireConnection;107;1;108;0
WireConnection;107;2;392;0
WireConnection;298;0;311;0
WireConnection;68;0;393;0
WireConnection;68;1;38;0
WireConnection;357;0;356;3
WireConnection;206;0;33;0
WireConnection;206;1;107;0
WireConnection;74;0;25;0
WireConnection;327;0;317;0
WireConnection;327;1;343;0
WireConnection;390;0;412;0
WireConnection;123;0;351;3
WireConnection;394;0;2;4
WireConnection;14;0;206;0
WireConnection;14;1;68;0
WireConnection;14;2;312;0
WireConnection;175;0;173;0
WireConnection;175;1;327;0
WireConnection;417;0;399;0
WireConnection;417;1;416;0
WireConnection;417;2;358;0
WireConnection;154;0;75;0
WireConnection;154;1;153;0
WireConnection;177;0;14;0
WireConnection;177;1;175;0
WireConnection;100;0;79;0
WireConnection;100;1;149;0
WireConnection;397;0;396;0
WireConnection;397;1;398;0
WireConnection;30;0;177;0
WireConnection;30;1;417;0
WireConnection;30;2;154;0
WireConnection;199;0;327;0
WireConnection;114;0;116;0
WireConnection;114;1;85;0
WireConnection;129;0;124;0
WireConnection;19;5;368;0
WireConnection;101;0;100;0
WireConnection;115;0;114;0
WireConnection;110;0;77;0
WireConnection;110;1;111;0
WireConnection;110;2;129;0
WireConnection;20;5;192;0
WireConnection;395;0;30;0
WireConnection;395;1;397;0
WireConnection;103;0;395;0
WireConnection;102;0;110;0
WireConnection;102;1;101;0
WireConnection;102;2;115;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;225;0
WireConnection;348;0;363;4
WireConnection;92;0;21;0
WireConnection;117;0;102;0
WireConnection;418;0;104;0
WireConnection;418;1;419;0
WireConnection;0;0;418;0
WireConnection;0;1;93;0
WireConnection;0;4;118;0
WireConnection;0;10;349;0
ASEEND*/
//CHKSM=3CC575FF8014D2B90F3D9A11051888E0046D4381