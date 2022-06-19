// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Tile"
{
	Properties
	{
		[PerRendererData]_WallpaperNumber("Wallpaper Number", Int) = 0
		[PerRendererData]_WallpaperRow("Wallpaper Row", Int) = 0
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_DamageAmount("Damage Amount", Range( 0 , 2)) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_DirtDamageOverlay("Dirt Damage Overlay", Range( 0.01 , 1)) = 0
		_DirtOverlay("Dirt Overlay", Range( 0.05 , 1)) = 0
		_EdgesOverlayPower("Edges Overlay Power", Range( 0.01 , 2)) = 0
		_EdgesDamagePower("Edges Damage Power", Range( 0.01 , 2)) = 0
		_EdgesDamageMultiply("Edges Damage Multiply", Range( 0 , 2)) = 0
		_EdgesOverlayMultiply("Edges Overlay Multiply", Range( 0 , 2)) = 0
		_NormalDamage("Normal Damage", 2D) = "bump" {}
		_NormalDamageScale("Normal Damage Scale", Range( 0 , 2)) = 0
		_NormalGood("Normal Good", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 2)) = 0
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 3)) = 0
		_DirtPower("Dirt Power", Range( 0 , 1)) = 0
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_RGBAMaskC("RGBA Mask C", 2D) = "white" {}
		_SmoothnessMain("Smoothness Main", Range( 0 , 1)) = 0
		_SmoothnessOverlayDirt("Smoothness Overlay Dirt", Range( 0 , 2)) = 1
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 2)) = 0
		_Pattern("Pattern", 2D) = "white" {}
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
		#pragma target 3.5
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv4_texcoord4;
		};

		uniform sampler2D _NormalGood;
		uniform float4 _NormalGood_ST;
		uniform float _NormalScale;
		uniform sampler2D _NormalDamage;
		uniform float4 _NormalDamage_ST;
		uniform float _NormalDamageScale;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _DamageAmount;
		uniform sampler2D _Pattern;
		uniform int _WallpaperNumber;
		uniform int _WallpaperRow;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _DirtOverlay;
		uniform float _EdgesOverlayMultiply;
		uniform float _EdgesOverlayPower;
		uniform sampler2D _RGBAMaskC;
		uniform float4 _RGBAMaskC_ST;
		uniform float _DirtDamageOverlay;
		uniform float _EdgesDamageMultiply;
		uniform float _EdgesDamagePower;
		uniform float _DirtMultiplier;
		uniform float _DirtPower;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _SmoothnessMain;
		uniform float _SmoothnessOverlayDirt;
		uniform float _SmoothnessDirt;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalGood = i.uv_texcoord * _NormalGood_ST.xy + _NormalGood_ST.zw;
			float2 uv_NormalDamage = i.uv_texcoord * _NormalDamage_ST.xy + _NormalDamage_ST.zw;
			float2 uv_RGBAMaskA = i.uv_texcoord * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode290 = tex2D( _RGBAMaskA, uv_RGBAMaskA );
			float3 temp_cast_0 = (( 1.0 - ( i.vertexColor.g * ( 1.0 - tex2DNode290.g ) ) )).xxx;
			float Heightmap11 = saturate( ( 1.0 - ( ( distance( temp_cast_0 , float3( 0,0,0 ) ) - _DamageAmount ) / max( 0.0 , 1E-05 ) ) ) );
			float3 lerpResult21 = lerp( UnpackScaleNormal( tex2D( _NormalGood, uv_NormalGood ), _NormalScale ) , UnpackScaleNormal( tex2D( _NormalDamage, uv_NormalDamage ), _NormalDamageScale ) , Heightmap11);
			float3 Normals92 = lerpResult21;
			o.Normal = Normals92;
			float2 appendResult363 = (float2(( _WallpaperNumber * 0.25 ) , ( 0.25 * _WallpaperRow )));
			float2 uv4_TexCoord364 = i.uv4_texcoord4 + appendResult363;
			float4 tex2DNode320 = tex2D( _Pattern, uv4_TexCoord364 );
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch429 = (float)_CustomColor;
			#else
				float staticSwitch429 = (float)_ColorSelect;
			#endif
			float2 temp_output_420_0 = ( half2( 0.015625,0 ) * staticSwitch429 );
			float2 uv_TexCoord412 = i.uv_texcoord * half2( 0,-0.5 ) + temp_output_420_0;
			float4 Color1_UV3398 = tex2D( _MainTex, uv_TexCoord412 );
			float4 lerpResult314 = lerp( tex2DNode320 , Color1_UV3398 , ( 1.0 - tex2DNode320.a ));
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode294 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float clampResult225 = clamp( pow( tex2DNode294.r , _DirtOverlay ) , 0.0 , 1.0 );
			float4 temp_output_33_0 = ( lerpResult314 * clampResult225 );
			float clampResult226 = clamp( pow( ( tex2DNode294.g + ( tex2DNode294.g * _EdgesOverlayMultiply ) ) , _EdgesOverlayPower ) , 0.0 , 1.0 );
			float2 uv_RGBAMaskC = i.uv_texcoord * _RGBAMaskC_ST.xy + _RGBAMaskC_ST.zw;
			float4 tex2DNode238 = tex2D( _RGBAMaskC, uv_RGBAMaskC );
			float4 temp_cast_3 = (tex2DNode238.g).xxxx;
			float TilesMaskBlue291 = tex2DNode290.b;
			float4 lerpResult230 = lerp( lerpResult314 , temp_cast_3 , ( 1.0 - TilesMaskBlue291 ));
			float4 temp_output_68_0 = ( lerpResult230 * pow( tex2DNode294.a , _DirtDamageOverlay ) );
			float4 lerpResult14 = lerp( ( temp_output_33_0 + ( clampResult226 * temp_output_33_0 ) ) , ( temp_output_68_0 + ( pow( ( tex2DNode294.b + ( tex2DNode294.b * _EdgesDamageMultiply ) ) , _EdgesDamagePower ) * temp_output_68_0 ) ) , Heightmap11);
			float2 uv_TexCoord426 = i.uv_texcoord * half2( 0,0 ) + temp_output_420_0;
			float4 Color2_UV3397 = tex2D( _MainTex, uv_TexCoord426 );
			float GreenChannelRGBA123 = tex2DNode290.a;
			float3 temp_cast_4 = (( GreenChannelRGBA123 * _DirtMultiplier )).xxx;
			float3 temp_cast_5 = (( 1.0 - ( i.vertexColor.r * pow( GreenChannelRGBA123 , _DirtPower ) ) )).xxx;
			float DirtHeight74 = saturate( ( 1.0 - ( ( distance( temp_cast_4 , temp_cast_5 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult30 = lerp( lerpResult14 , ( tex2DNode238.b * Color2_UV3397 ) , ( DirtHeight74 * _DirtOpacity ));
			float4 Albedo103 = lerpResult30;
			o.Albedo = ( Albedo103 * _Color ).rgb;
			float temp_output_102_0 = ( _SmoothnessMain * ( _SmoothnessMain * ( 1.0 - ( GreenChannelRGBA123 * _SmoothnessOverlayDirt ) ) ) );
			float DirtDamage119 = tex2DNode294.a;
			float lerpResult268 = lerp( temp_output_102_0 , ( temp_output_102_0 * DirtDamage119 * TilesMaskBlue291 ) , Heightmap11);
			float DirtOpacity308 = _DirtOpacity;
			float Smoothness117 = ( lerpResult268 * ( 1.0 - ( ( _SmoothnessDirt * DirtHeight74 ) * DirtOpacity308 ) ) );
			o.Smoothness = Smoothness117;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-1581.408;43.07578;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;385;-523.2515,-2746.168;Inherit;False;2080.08;813.5428;Comment;12;398;397;424;427;419;387;420;426;412;392;425;409;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;428;-600.1649,-2315.965;Inherit;False;Property;_CustomColor;Custom Color;29;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;387;-428.2156,-2480.639;Inherit;False;Property;_ColorSelect;ColorSelect;2;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;134;-728.531,2709.884;Inherit;False;2599.879;576.3812;Comment;11;220;246;184;183;11;276;277;279;289;291;290;Damaged Tiles;0.509434,0.1561944,0.4762029,1;0;0
Node;AmplifyShaderEditor.Vector2Node;419;-422.459,-2630.028;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;359;-1405.167,-1428.887;Inherit;False;Constant;_Multiply025;Multiply0.25;37;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;360;-1416.454,-1293.12;Inherit;False;Property;_WallpaperRow;Wallpaper Row;1;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;429;-316.1649,-2327.965;Inherit;False;Property;_UseCustomColor;Use Custom Color;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;358;-1412.454,-1611.12;Inherit;False;Property;_WallpaperNumber;Wallpaper Number;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;290;-831.4916,2816.513;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;21;0;Create;True;0;0;0;False;0;False;-1;ef4f2e343c18d7b41a0c058777bd28da;ef4f2e343c18d7b41a0c058777bd28da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;-1152.167,-1338.887;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;135;-709.3894,2020.599;Inherit;False;2366.052;568.8823;Comment;13;74;25;27;26;24;23;29;2;201;206;241;123;242;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.Vector2Node;424;-52.46458,-2683.148;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.5;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;362;-1142.167,-1487.887;Inherit;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;420;-50.16165,-2497.835;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;242;-432.8618,2485.778;Inherit;False;Property;_DirtPower;Dirt Power;19;0;Create;True;0;0;0;False;0;False;0;0.5444034;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-533.5322,2305.618;Inherit;False;GreenChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;363;-960.1577,-1421.132;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.3333;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;392;410.4057,-2458.247;Inherit;True;Property;_MainTex;Color Theme;4;0;Create;False;0;0;0;False;0;False;afc3fc4ad6ff2594abf8b82f1071e28f;afc3fc4ad6ff2594abf8b82f1071e28f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;412;274.4286,-2628.048;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;409;803.5032,-2615.336;Inherit;True;Property;_TextureSample0;Texture Sample 0;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;241;-58.82509,2379.27;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;364;-778.6368,-1367.524;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;133;-515.7352,-1796.963;Inherit;False;5246.069;1580;Comment;52;239;103;30;154;305;14;75;213;51;12;163;132;52;162;119;68;161;33;226;225;230;157;54;160;69;228;38;308;105;232;70;159;55;153;39;299;158;107;227;303;292;297;108;314;300;315;296;294;320;404;405;430;Albedo;0.3837695,0.9528302,0.2382075,1;0;0
Node;AmplifyShaderEditor.SamplerNode;320;-266.7873,-1663.382;Inherit;True;Property;_Pattern;Pattern;27;0;Create;True;0;0;0;False;0;False;-1;01e3ac9ffafa5b34f830c98b19e0e384;01e3ac9ffafa5b34f830c98b19e0e384;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;398;1197.808,-2614.399;Inherit;False;Color1_UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;294;1105.478,-1691.173;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;22;0;Create;True;0;0;0;False;0;False;-1;None;2336892881a6bbd4ab5698bd21876f7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-270.4548,2076.569;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;206;158.2119,2368.431;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;404;364.5085,-1129.233;Inherit;False;398;Color1_UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;315;130.2301,-1355.012;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;427;-50.65396,-2182.699;Half;False;Constant;_ColorsNumber2;ColorsNumber2;19;0;Create;True;0;0;0;False;1;;False;0,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;29;316.9011,2331.094;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;18;0;Create;True;0;0;0;False;0;False;0;0.1188804;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;273.9639,2097.522;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;296;1867.222,-1724.996;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;801.6085,2479.915;Inherit;False;Property;_DirtSmooth;Dirt Smooth;16;0;Create;True;0;0;0;False;0;False;0;0.9263648;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;300;1864.904,-1142.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;276;-28.69685,2772.396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;297;1912.601,-1614.537;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;291;-464.6983,3028.438;Inherit;False;TilesMaskBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;426;215.8987,-2216.374;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;314;635.8597,-1296.479;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;648.7888,2229.999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;732.0987,2362.481;Inherit;False;Property;_DirtRange;Dirt Range;17;0;Create;True;0;0;0;False;0;False;0;0.5338895;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;715.9734,2102.997;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;2005.879,-1541.54;Inherit;False;Property;_EdgesOverlayMultiply;Edges Overlay Multiply;10;0;Create;True;0;0;0;False;0;False;0;1.478378;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;303;75.72958,-406.9148;Inherit;True;Property;_RGBAMaskC;RGBA Mask C;23;0;Create;True;0;0;0;False;0;False;ebaf393a176609441b3b578b1ebcdc5e;ebaf393a176609441b3b578b1ebcdc5e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;425;788.2529,-2301.263;Inherit;True;Property;_TextureSample1;Texture Sample 1;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;292;639.1418,-341.518;Inherit;False;291;TilesMaskBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;1091.652,2078.592;Inherit;False;Color Mask;-1;;43;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;277;32.08484,2847.282;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;2076.069,-894.5472;Inherit;False;Property;_EdgesDamageMultiply;Edges Damage Multiply;9;0;Create;True;0;0;0;False;0;False;0;0.9314082;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;1583.447,-1455.303;Inherit;False;Property;_DirtOverlay;Dirt Overlay;6;0;Create;True;0;0;0;False;0;False;0;0.635;0.05;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-732.2277,25.78814;Inherit;False;1976.367;974.5626;Comment;22;274;275;117;269;268;115;114;270;149;116;102;271;85;110;77;129;196;124;197;293;311;309;Smoothness;0.8113208,0.2411,0.2411,1;0;0
Node;AmplifyShaderEditor.WireNode;227;1050.76,-653.124;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;431;1507.825,-1720.548;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;299;1940.392,-1120.423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;2285.695,-1602.695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;289;-172.1424,3019.996;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;430;1461.526,-955.3632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;1853.686,-1517.329;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;232;1050.887,-533.7041;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;3690.272,-476.7158;Inherit;False;Property;_DirtOpacity;Dirt Opacity;15;0;Create;True;0;0;0;False;0;False;0;0.8803338;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;1413.662,2070.599;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-731.1155,291.8477;Inherit;False;Property;_SmoothnessOverlayDirt;Smoothness Overlay Dirt;25;0;Create;True;0;0;0;False;0;False;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;2471.479,-1746.741;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-722.856,151.1956;Inherit;False;123;GreenChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;228;1077.193,-580.012;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;279;175.6924,2873.42;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;238;1172.278,-394.1183;Inherit;True;Property;_TextureSample4;Texture Sample 4;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;2376.12,-1017.344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;2247.479,-1440.741;Inherit;False;Property;_EdgesOverlayPower;Edges Overlay Power;7;0;Create;True;0;0;0;False;0;False;0;1.012751;0.01;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;1276.769,-824.8056;Inherit;False;Property;_DirtDamageOverlay;Dirt Damage Overlay;5;0;Create;True;0;0;0;False;0;False;0;0.8330839;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;397;1213.047,-2308.777;Inherit;False;Color2_UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;405;2931.925,-333.9401;Inherit;False;397;Color2_UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-579.2249,847.8217;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-435.1155,203.8477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;308;3989.963,-477.3792;Inherit;False;DirtOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;69;1581.762,-927.3444;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;374.7331,3014.98;Inherit;False;Property;_DamageAmount;Damage Amount;3;0;Create;True;0;0;0;False;0;False;0;1.02;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;160;2510.567,-1147.052;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;2610.874,-1634.228;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;2283.752,-768.9916;Inherit;False;Property;_EdgesDamagePower;Edges Damage Power;8;0;Create;True;0;0;0;False;0;False;0;1.395429;0.01;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;225;2037.762,-1406.984;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;246;349.198,2832.609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-634.9373,709.36;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;26;0;Create;True;0;0;0;False;0;False;0;1.097945;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;230;1534.676,-598.19;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-196.7146,746.9595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-291.4318,191.1183;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-729.2276,54.78815;Inherit;False;Property;_SmoothnessMain;Smoothness Main;24;0;Create;True;0;0;0;False;0;False;0;0.845;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-199.8445,886.5016;Inherit;False;308;DirtOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;226;2766.581,-1544.227;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;183;756.3236,2823.656;Inherit;False;Color Mask;-1;;44;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;3267.976,-293.2285;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;161;2638.42,-972.4114;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;1855.308,-596.8416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;2279.227,-1303.369;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-28.27484,752.1343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;1118.649,2864.153;Inherit;False;Heightmap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;1589.058,-1024.914;Inherit;False;DirtDamage;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;2901.879,-1436.441;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;132;3473.594,-286.3862;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;2791.799,-813.5814;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-151.3564,116.825;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-5.892738,52.49275;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;-175.0299,443.5446;Inherit;False;119;DirtDamage;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-183.2276,519.139;Inherit;False;291;TilesMaskBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;131.5625,739.7897;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-764.5289,1166.806;Inherit;False;1697.426;661.7903;Normals;11;208;211;209;248;92;21;19;91;20;312;313;Normals;0.0572713,0.3924344,0.9339623,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;3109.919,-1327.458;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;2879.261,-476.5795;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;3670.174,-316.7711;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;213;3712.866,-576.6442;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;2965.55,-615.9837;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;158.4706,389.9429;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;274;600.0728,763.8091;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;501.1919,221.6741;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;-712.9877,1292.15;Inherit;False;Property;_NormalScale;Normal Scale;14;0;Create;True;0;0;0;False;0;False;0;1.06;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;-639.9873,1615.15;Inherit;False;Property;_NormalDamageScale;Normal Damage Scale;12;0;Create;True;0;0;0;False;0;False;0;1.4;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;305;3756.465,-586.5727;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;3215.544,-641.0801;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;4027.174,-378.234;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-283.0939,1464.738;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;539.1506,48.25682;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;275;644.3156,692.7097;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-321.2094,1570.616;Inherit;True;Property;_NormalDamage;Normal Damage;11;0;Create;True;0;0;0;False;0;False;-1;b7ec0014e820a4c4b8c0ce2bbab75c9c;b7ec0014e820a4c4b8c0ce2bbab75c9c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-339.2636,1216.806;Inherit;True;Property;_NormalGood;Normal Good;13;0;Create;True;0;0;0;False;0;False;-1;389fd9279fe1c704dacbb1453299af06;389fd9279fe1c704dacbb1453299af06;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;4125.151,-638.7672;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;49.57352,1423.016;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;860.7011,56.25188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;4376.012,-628.0964;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;1113.901,54.22897;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;727.0653,1413.362;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;2227.808,737.5997;Inherit;False;103;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;433;2239.146,394.0642;Inherit;False;Property;_Color;Color;30;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;118;2256.004,939.0735;Inherit;False;117;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;2264.493,847.8726;Inherit;False;92;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;208;565.5949,1486.787;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;211;-1.40509,1578.787;Inherit;True;Property;_DustRocks_normal;DustRocks_normal;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;209;345.5949,1678.787;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;1653.627,-1821.409;Inherit;False;DirtGood;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;248;303.1685,1511.449;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-332.3855,2827.262;Inherit;False;TilesCheckerSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;432;2405.066,672.7263;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2548.548,813.1577;Float;False;True;-1;3;;0;0;Standard;DBK/Tile;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;429;1;387;0
WireConnection;429;0;428;0
WireConnection;361;0;359;0
WireConnection;361;1;360;0
WireConnection;362;0;358;0
WireConnection;362;1;359;0
WireConnection;420;0;419;0
WireConnection;420;1;429;0
WireConnection;123;0;290;4
WireConnection;363;0;362;0
WireConnection;363;1;361;0
WireConnection;412;0;424;0
WireConnection;412;1;420;0
WireConnection;409;0;392;0
WireConnection;409;1;412;0
WireConnection;241;0;123;0
WireConnection;241;1;242;0
WireConnection;364;1;363;0
WireConnection;320;1;364;0
WireConnection;398;0;409;0
WireConnection;206;0;241;0
WireConnection;315;0;320;4
WireConnection;201;0;2;1
WireConnection;201;1;206;0
WireConnection;296;0;294;2
WireConnection;300;0;294;3
WireConnection;276;0;2;2
WireConnection;297;0;296;0
WireConnection;291;0;290;3
WireConnection;426;0;427;0
WireConnection;426;1;420;0
WireConnection;314;0;320;0
WireConnection;314;1;404;0
WireConnection;314;2;315;0
WireConnection;27;0;123;0
WireConnection;27;1;29;0
WireConnection;26;0;201;0
WireConnection;425;0;392;0
WireConnection;425;1;426;0
WireConnection;25;1;26;0
WireConnection;25;3;27;0
WireConnection;25;4;23;0
WireConnection;25;5;24;0
WireConnection;277;0;276;0
WireConnection;227;0;314;0
WireConnection;431;0;294;1
WireConnection;299;0;300;0
WireConnection;107;0;297;0
WireConnection;107;1;108;0
WireConnection;289;0;290;2
WireConnection;430;0;294;4
WireConnection;38;0;431;0
WireConnection;38;1;39;0
WireConnection;232;0;292;0
WireConnection;74;0;25;0
WireConnection;105;0;296;0
WireConnection;105;1;107;0
WireConnection;228;0;227;0
WireConnection;279;0;277;0
WireConnection;279;1;289;0
WireConnection;238;0;303;0
WireConnection;159;0;299;0
WireConnection;159;1;158;0
WireConnection;397;0;425;0
WireConnection;196;0;124;0
WireConnection;196;1;197;0
WireConnection;308;0;153;0
WireConnection;69;0;430;0
WireConnection;69;1;70;0
WireConnection;160;0;299;0
WireConnection;160;1;159;0
WireConnection;54;0;105;0
WireConnection;54;1;55;0
WireConnection;225;0;38;0
WireConnection;246;0;279;0
WireConnection;230;0;228;0
WireConnection;230;1;238;2
WireConnection;230;2;232;0
WireConnection;114;0;116;0
WireConnection;114;1;85;0
WireConnection;129;0;196;0
WireConnection;226;0;54;0
WireConnection;183;3;246;0
WireConnection;183;4;184;0
WireConnection;306;0;238;3
WireConnection;306;1;405;0
WireConnection;161;0;160;0
WireConnection;161;1;157;0
WireConnection;68;0;230;0
WireConnection;68;1;69;0
WireConnection;33;0;314;0
WireConnection;33;1;225;0
WireConnection;309;0;114;0
WireConnection;309;1;311;0
WireConnection;11;0;183;0
WireConnection;119;0;430;0
WireConnection;52;0;226;0
WireConnection;52;1;33;0
WireConnection;132;0;306;0
WireConnection;162;0;161;0
WireConnection;162;1;68;0
WireConnection;110;0;77;0
WireConnection;110;1;129;0
WireConnection;102;0;77;0
WireConnection;102;1;110;0
WireConnection;115;0;309;0
WireConnection;51;0;33;0
WireConnection;51;1;52;0
WireConnection;213;0;132;0
WireConnection;163;0;68;0
WireConnection;163;1;162;0
WireConnection;270;0;102;0
WireConnection;270;1;271;0
WireConnection;270;2;293;0
WireConnection;274;0;115;0
WireConnection;305;0;213;0
WireConnection;14;0;51;0
WireConnection;14;1;163;0
WireConnection;14;2;12;0
WireConnection;154;0;75;0
WireConnection;154;1;153;0
WireConnection;268;0;102;0
WireConnection;268;1;270;0
WireConnection;268;2;149;0
WireConnection;275;0;274;0
WireConnection;20;5;312;0
WireConnection;19;5;313;0
WireConnection;30;0;14;0
WireConnection;30;1;305;0
WireConnection;30;2;154;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;91;0
WireConnection;269;0;268;0
WireConnection;269;1;275;0
WireConnection;103;0;30;0
WireConnection;117;0;269;0
WireConnection;92;0;21;0
WireConnection;208;1;248;0
WireConnection;208;2;209;0
WireConnection;239;0;431;0
WireConnection;248;0;21;0
WireConnection;248;1;211;0
WireConnection;220;0;290;1
WireConnection;432;0;104;0
WireConnection;432;1;433;0
WireConnection;0;0;432;0
WireConnection;0;1;93;0
WireConnection;0;4;118;0
ASEEND*/
//CHKSM=EFA01DFBE21948FD22C3598CBAFA561ABCC5FF9B