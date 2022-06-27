// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Wallpaper"
{
	Properties
	{
		[PerRendererData]_WallpaperNumber("Wallpaper Number", Int) = 0
		[PerRendererData]_WallpaperRow("Wallpaper Row", Int) = 0
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_ColorTheme("Color Theme", 2D) = "white" {}
		_PaperBrightness("Paper Brightness", Range( 0 , 2)) = 0
		_DirtOverlay("Dirt Overlay", Range( 0 , 1)) = 0
		_EdgesOverlayMultiply("Edges Overlay Multiply", Range( 0 , 2)) = 0
		_EdgesOverlayPower("Edges Overlay Power", Range( 0.01 , 2)) = 0
		_DirtDamageOverlay("Dirt Damage Overlay", Range( 0.01 , 1)) = 0
		_EdgesAmount("Edges Amount", Range( 0.01 , 1)) = 0
		_EdgesBrigthness("Edges Brigthness", Range( 0 , 1)) = 0
		_TransitionAmount("Transition Amount", Range( 0.001 , 0.15)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0.421177
		_DamageSmooth("Damage Smooth", Range( 0 , 100)) = 0
		_DamageMultiplier("Damage Multiplier", Range( 0 , 1)) = 0.1946161
		_WallpaperNM("Wallpaper NM", 2D) = "bump" {}
		_WallpaperNMScale("Wallpaper NM Scale", Range( 0 , 2)) = 0
		_EdgesNormals("Edges Normals", Range( 0 , 1)) = 0
		_DamageNormalsExtra("Damage Normals Extra", Range( 0 , 1)) = 0
		_WallpaperDamageNMScale("Wallpaper Damage NM Scale", Range( 0 , 2)) = 0
		_WallpaperDamageNM("Wallpaper Damage NM", 2D) = "bump" {}
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 2)) = 0
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_RGBA_Mask_A("RGBA_Mask_A", 2D) = "white" {}
		_RGBA_Mask_B("RGBA_Mask_B", 2D) = "white" {}
		_SmoothnessMain("Smoothness Main", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_MainTex("Opacity Mask", 2D) = "white" {}
		_PatternTexture("Pattern Texture", 2D) = "white" {}
		_PatternStrenght("Pattern Strenght", Range( 0 , 1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Toggle(_USECUSTOMCOLOR_ON)] _UseCustomColor("Use Custom Color", Float) = 0
		_CustomColor("Custom Color", Int) = 0
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "Pattern"="True" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv3_texcoord3;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float2 uv4_texcoord4;
		};

		uniform sampler2D _WallpaperNM;
		uniform float4 _WallpaperNM_ST;
		uniform float _WallpaperNMScale;
		uniform sampler2D _WallpaperDamageNM;
		uniform float4 _WallpaperDamageNM_ST;
		uniform float _WallpaperDamageNMScale;
		uniform sampler2D _RGBA_Mask_A;
		uniform float4 _RGBA_Mask_A_ST;
		uniform float _DamageMultiplier;
		uniform float _DamageAmount;
		uniform float _DamageSmooth;
		uniform float _EdgesNormals;
		uniform float _DamageNormalsExtra;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _EdgesAmount;
		uniform sampler2D _ColorTheme;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _PatternTexture;
		uniform int _WallpaperNumber;
		uniform int _WallpaperRow;
		uniform float _PatternStrenght;
		uniform sampler2D _RGBA_Mask_B;
		uniform float4 _RGBA_Mask_B_ST;
		uniform float _DirtOverlay;
		uniform float _EdgesOverlayMultiply;
		uniform float _EdgesOverlayPower;
		uniform float _DirtDamageOverlay;
		uniform float _PaperBrightness;
		uniform float _TransitionAmount;
		uniform float _EdgesBrigthness;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _SmoothnessMain;
		uniform float _SmoothnessDamage;
		uniform float _SmoothnessDirt;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv3_WallpaperNM = i.uv3_texcoord3 * _WallpaperNM_ST.xy + _WallpaperNM_ST.zw;
			float2 uv3_WallpaperDamageNM = i.uv3_texcoord3 * _WallpaperDamageNM_ST.xy + _WallpaperDamageNM_ST.zw;
			float2 uv3_RGBA_Mask_A = i.uv3_texcoord3 * _RGBA_Mask_A_ST.xy + _RGBA_Mask_A_ST.zw;
			float4 tex2DNode232 = tex2D( _RGBA_Mask_A, uv3_RGBA_Mask_A );
			float HeightMask10 = saturate(pow(((tex2DNode232.g*( ( ( tex2DNode232.r * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount ))*4)+(( ( ( tex2DNode232.r * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount )*2),_DamageSmooth));
			float Heightmap11 = HeightMask10;
			float EdgesNoNormals220 = ( i.vertexColor.b * _EdgesNormals );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode205 = tex2D( _MainTex, uv_MainTex );
			float4 temp_cast_0 = (_EdgesAmount).xxxx;
			float3 desaturateInitialColor215 = pow( ( 1.0 - tex2DNode205 ) , temp_cast_0 ).rgb;
			float desaturateDot215 = dot( desaturateInitialColor215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar215 = lerp( desaturateInitialColor215, desaturateDot215.xxx, 1.0 );
			float3 CutoutEdges216 = desaturateVar215;
			float3 lerpResult21 = lerp( UnpackScaleNormal( tex2D( _WallpaperNM, uv3_WallpaperNM ), _WallpaperNMScale ) , UnpackScaleNormal( tex2D( _WallpaperDamageNM, uv3_WallpaperDamageNM ), _WallpaperDamageNMScale ) , ( ( Heightmap11 * ( 1.0 - EdgesNoNormals220 ) ) + ( i.vertexColor.r * _DamageNormalsExtra ) + CutoutEdges216 ));
			float3 Normals92 = lerpResult21;
			o.Normal = Normals92;
			half2 _ColorsNumber = half2(0,-0.07);
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch325 = (float)_CustomColor;
			#else
				float staticSwitch325 = (float)_ColorSelect;
			#endif
			float2 temp_output_298_0 = ( half2( 0.015625,0 ) * staticSwitch325 );
			float2 uv_TexCoord301 = i.uv_texcoord * _ColorsNumber + temp_output_298_0;
			float4 ColorSelection1306 = tex2D( _ColorTheme, uv_TexCoord301 );
			float2 appendResult283 = (float2(( _WallpaperNumber * 0.25 ) , ( 0.25 * _WallpaperRow )));
			float2 uv4_TexCoord282 = i.uv4_texcoord4 + appendResult283;
			float4 tex2DNode167 = tex2D( _PatternTexture, uv4_TexCoord282 );
			float4 lerpResult170 = lerp( ColorSelection1306 , tex2DNode167 , ( tex2DNode167.a * _PatternStrenght ));
			float2 uv3_RGBA_Mask_B = i.uv3_texcoord3 * _RGBA_Mask_B_ST.xy + _RGBA_Mask_B_ST.zw;
			float4 tex2DNode236 = tex2D( _RGBA_Mask_B, uv3_RGBA_Mask_B );
			float4 temp_output_33_0 = ( lerpResult170 * pow( tex2DNode236.r , _DirtOverlay ) );
			float2 appendResult320 = (float2(temp_output_298_0.x , 0.5));
			float2 uv_TexCoord304 = i.uv_texcoord * _ColorsNumber + appendResult320;
			float4 ColorSelection2307 = tex2D( _ColorTheme, uv_TexCoord304 );
			float4 temp_output_68_0 = ( ColorSelection2307 * pow( ( tex2DNode236.b + EdgesNoNormals220 ) , _DirtDamageOverlay ) );
			float4 lerpResult14 = lerp( ( temp_output_33_0 + ( pow( ( tex2DNode236.g + ( tex2DNode236.g * _EdgesOverlayMultiply ) ) , _EdgesOverlayPower ) * temp_output_33_0 ) ) , ( temp_output_68_0 + ( tex2DNode236.a * temp_output_68_0 * _PaperBrightness ) ) , Heightmap11);
			float HeightBricks172 = Heightmap11;
			float BricksStep179 = step( 0.1 , ( ( 1.0 - HeightBricks172 ) * step( _TransitionAmount , HeightBricks172 ) ) );
			float2 appendResult323 = (float2(temp_output_298_0.x , 0.1));
			float2 uv_TexCoord321 = i.uv_texcoord * _ColorsNumber + appendResult323;
			float4 ColorSelection3312 = tex2D( _ColorTheme, uv_TexCoord321 );
			float Mask1_Alpha242 = tex2DNode232.a;
			float3 temp_cast_7 = (( tex2DNode232.b * _DirtMultiplier )).xxx;
			float3 temp_cast_8 = (( 1.0 - i.vertexColor.r )).xxx;
			float DirtHeight74 = saturate( ( 1.0 - ( ( distance( temp_cast_7 , temp_cast_8 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult30 = lerp( ( lerpResult14 + float4( ( ( BricksStep179 + CutoutEdges216 ) * _EdgesBrigthness ) , 0.0 ) ) , ( ColorSelection3312 * Mask1_Alpha242 ) , ( DirtHeight74 * _DirtOpacity ));
			float4 Albedo103 = lerpResult30;
			o.Albedo = ( Albedo103 * _Color ).rgb;
			float RedChannelRGBA109 = tex2DNode232.r;
			float GreenChannelRGBA123 = tex2DNode232.b;
			float Smoothness117 = ( ( _SmoothnessMain * RedChannelRGBA109 * ( 1.0 - GreenChannelRGBA123 ) ) * ( 1.0 - ( _SmoothnessDamage * Heightmap11 ) ) * ( 1.0 - ( _SmoothnessDirt * DirtHeight74 ) ) );
			o.Smoothness = Smoothness117;
			o.Alpha = 1;
			float4 OpacityMask244 = tex2DNode205;
			clip( OpacityMask244.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-1517.64;-1347.484;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;134;-1277.213,2687.843;Inherit;False;2503.377;583.2743;Comment;12;109;11;10;9;8;7;5;4;3;232;242;233;Height Selection;0.509434,0.1561944,0.4762029,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;135;-1306.344,2033.41;Inherit;False;2366.052;568.8823;Comment;8;74;25;27;26;24;23;29;2;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-449.9545,2826.074;Float;False;Property;_DamageMultiplier;Damage Multiplier;16;0;Create;True;0;0;0;False;0;False;0.1946161;0.933;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;232;-1271.327,2721.222;Inherit;True;Property;_RGBA_Mask_A;RGBA_Mask_A;28;0;Create;True;0;0;0;False;0;False;-1;e6ac9406856f8bf4e85d66e726dbe060;e6ac9406856f8bf4e85d66e726dbe060;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;324;293.0599,-2533.788;Inherit;False;Property;_CustomColor;Custom Color;38;0;Create;True;0;0;0;False;0;False;0;10;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-195.0272,2744.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;296;312.2529,-2703.548;Inherit;False;Property;_ColorSelect;ColorSelect;3;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;295;468.1774,-2961.371;Inherit;False;2080.08;813.5428;Comment;15;307;306;305;304;302;301;300;299;298;297;312;320;321;308;323;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;2;-940.595,2086.092;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;102.6365,2752.039;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;76.35336,3073.023;Float;False;Property;_DamageAmount;Damage Amount;14;0;Create;True;0;0;0;False;0;False;0.421177;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;325;577.0599,-2545.788;Inherit;False;Property;_UseCustomColor;Use Custom Color;37;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;233;-918.0777,2917.441;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-1274.629,1135.605;Inherit;False;1735.028;784.3454;Normals;15;229;220;21;19;20;202;199;231;203;200;91;230;204;247;248;Normals;0.0572713,0.3924344,0.9339623,1;0;0
Node;AmplifyShaderEditor.Vector2Node;297;599.9699,-2867.231;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;289;-1789.236,-1711.071;Inherit;False;Constant;_Multiply025;Multiply0.25;37;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;464.4769,3010.964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;293;-1800.524,-1575.304;Inherit;False;Property;_WallpaperRow;Wallpaper Row;1;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;292;-1796.524,-1893.304;Inherit;False;Property;_WallpaperNumber;Wallpaper Number;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;347.9393,2742.826;Float;False;Property;_DamageSmooth;Damage Smooth;15;0;Create;True;0;0;0;False;0;False;0;10.1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;326;-590.2656,2932.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;923.2674,-2748.038;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-1139.008,1796.862;Inherit;False;Property;_EdgesNormals;Edges Normals;19;0;Create;True;0;0;0;False;0;False;0;0.3026367;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-813.6605,1780.499;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;10;655.4541,2899.971;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-1526.236,-1770.071;Inherit;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-1536.236,-1621.071;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;299;973.9644,-2940.351;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.07;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;320;1134.262,-2456.464;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;983.1667,2892.173;Inherit;False;Heightmap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;304;1401.428,-2474.877;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;171;1315.374,2732.28;Inherit;False;1169.387;427.1835;;7;179;177;176;174;175;173;172;Edges;0.4111784,0.7731025,0.8301887,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;300;1435.069,-2714.55;Inherit;True;Property;_ColorTheme;Color Theme;4;0;Create;True;0;0;0;False;0;False;a4547a6a35e23814ab82698a0f3f7d4a;a4547a6a35e23814ab82698a0f3f7d4a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;133;-1222.661,-2015.46;Inherit;False;4870.594;1869.285;Comment;49;167;164;168;170;17;119;69;103;30;154;132;14;75;42;51;153;12;163;162;32;52;68;33;54;105;38;55;150;70;107;39;108;196;188;209;210;211;217;218;222;223;226;236;239;243;272;273;282;294;Albedo;0.3837695,0.9528302,0.2382075,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;246;-1217.964,-2567.308;Inherit;False;1419.581;433.1211;Comment;7;205;213;214;215;216;244;212;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;301;1286.858,-2858.251;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;283;-1360.467,-1700.609;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.3333;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-719.0734,1672.675;Inherit;False;EdgesNoNormals;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;1349.684,2824.657;Inherit;False;HeightBricks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;125.6202,-1049.985;Inherit;False;220;EdgesNoNormals;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;302;1826.969,-2877.146;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;205;-1167.964,-2516.308;Inherit;True;Property;_MainTex;Opacity Mask;33;0;Create;False;0;0;0;False;0;False;-1;be41953d2ca4b0b4f89e06fdbeeda334;be41953d2ca4b0b4f89e06fdbeeda334;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;305;1838.176,-2609.638;Inherit;True;Property;_Texture4;Texture4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;282;-1076.342,-1412.276;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;173;1365.374,3056.234;Inherit;False;Property;_TransitionAmount;Transition Amount;13;0;Create;True;0;0;0;False;0;False;0;0.01762983;0.001;0.15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;236;305.1062,-1969.333;Inherit;True;Property;_RGBA_Mask_B;RGBA_Mask_B;29;0;Create;True;0;0;0;False;0;False;-1;None;3134e140cac552146a35a689f8f93bab;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;238;716.1061,-1815.333;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;174;1704.598,3050.594;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;175;1662.206,2796.49;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;2228.475,-2556.98;Inherit;False;ColorSelection2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-524.3712,-1126.385;Float;False;Property;_PatternStrenght;Pattern Strenght;35;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;167;-711.4208,-1440.303;Inherit;True;Property;_PatternTexture;Pattern Texture;34;0;Create;True;0;0;0;False;0;False;-1;1676207b8d1aab0408ea1a16aa263bfc;1676207b8d1aab0408ea1a16aa263bfc;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;246.4186,-952.9891;Inherit;False;Property;_DirtDamageOverlay;Dirt Damage Overlay;10;0;Create;True;0;0;0;False;0;False;0;0.7208843;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;568.2552,-1097.129;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;877.0781,-1734.238;Inherit;False;Property;_EdgesOverlayMultiply;Edges Overlay Multiply;8;0;Create;True;0;0;0;False;0;False;0;0.381546;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-699.7548,-2249.187;Inherit;False;Property;_EdgesAmount;Edges Amount;11;0;Create;True;0;0;0;False;0;False;0;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;213;-544.7942,-2358.147;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;306;2200.311,-2825.673;Inherit;False;ColorSelection1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;69;700.4685,-989.1737;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;214;-383.2169,-2347.697;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;234;-900.8375,2319.999;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;323;1135.8,-2261.53;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;667.7515,-1587.083;Inherit;False;Property;_DirtOverlay;Dirt Overlay;7;0;Create;True;0;0;0;False;0;False;0;0.520268;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-176.2321,-1173.909;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;1203.294,-1821.191;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;-120.7169,-1634.68;Inherit;False;306;ColorSelection1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;430.0994,-501.6479;Inherit;False;307;ColorSelection2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;237;742.1061,-1937.333;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;1884.135,2793.101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;239;735.4521,-1166.92;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-275.2918,2358.439;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;26;0;Create;True;0;0;0;False;0;False;0;1.397719;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;321;1408.446,-2300.33;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;860.5824,-849.9954;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;215;-230.3269,-2340.957;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;235;-864.0374,2300.8;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;1389.079,-1965.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;967.1252,-1636.778;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;177;2080.957,2804.508;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;1165.079,-1661.238;Inherit;False;Property;_EdgesOverlayPower;Edges Overlay Power;9;0;Create;True;0;0;0;False;0;False;0;2;0.01;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;170;143.4417,-1478.325;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;28.70817,2262.439;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;204.7082,2486.439;Inherit;False;Property;_DirtSmooth;Dirt Smooth;25;0;Create;True;0;0;0;False;0;False;0;0.6488973;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;188.7082,2358.439;Inherit;False;Property;_DirtRange;Dirt Range;24;0;Create;True;0;0;0;False;0;False;0;0.2685022;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;156.7082,2118.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;2242.909,2789.641;Inherit;False;BricksStep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;240;1541.707,-1053.777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;1410.353,-886.8408;Inherit;False;Property;_PaperBrightness;Paper Brightness;6;0;Create;True;0;0;0;False;0;False;0;0.93;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;1177.97,-1454.479;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;54;1501.079,-1821.238;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;308;1849.447,-2376.28;Inherit;True;Property;_TextureSample5;Texture Sample 5;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;223;1036.699,-957.6698;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;216;-41.38292,-2345.457;Inherit;False;CutoutEdges;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;242;-891.323,3115.7;Inherit;False;Mask1_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;492.7082,2086.439;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;2232.332,-2359.642;Inherit;False;ColorSelection3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;1777.493,-1626.848;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;1679.214,-1034.847;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;2308.676,-1304.716;Inherit;False;216;CutoutEdges;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;2308.485,-1468.263;Inherit;False;179;BricksStep;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;1926.505,-739.2333;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;2035.214,-1452.673;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-888.428,2967.918;Inherit;False;GreenChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;1856.177,-840.1815;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;131;-1230.477,3.887017;Inherit;False;1432.054;1002.007;Comment;15;100;79;116;85;114;115;102;117;77;111;124;129;110;101;149;Smoothness;0.8113208,0.2411,0.2411,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;217;2512.676,-1329.716;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;211;2227.875,-1198.726;Inherit;False;Property;_EdgesBrigthness;Edges Brigthness;12;0;Create;True;0;0;0;False;0;False;0;0.115;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;243;2089.73,-380.0698;Inherit;False;242;Mask1_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;812.7082,2086.439;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;1906.884,-581.6776;Inherit;False;312;ColorSelection3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-1122.762,538.6327;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1152.106,234.2945;Inherit;False;123;GreenChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-1144.427,846.4692;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;200;-564.2057,1568.531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-564.6842,1814.221;Inherit;False;Property;_DamageNormalsExtra;Damage Normals Extra;20;0;Create;True;0;0;0;False;0;False;0;0.797;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1136.567,447.272;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;31;0;Create;True;0;0;0;False;0;False;0;0.7497235;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-872.913,2846.269;Inherit;False;RedChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-758.337,1425.306;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;2638.269,-488.9693;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;2544.874,-1159.726;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;153;2634.869,-646.2133;Inherit;False;Property;_DirtOpacity;Dirt Opacity;27;0;Create;True;0;0;0;False;0;False;0;0.7411765;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;2157.548,-852.3235;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;2402.819,-553.4088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1147.037,744.4023;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;32;0;Create;True;0;0;0;False;0;False;0;0.5843806;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;2925.771,-557.7311;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-491.9702,1434.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-787.5701,207.7872;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-764.3616,494.5984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;231;-436.5243,1653.164;Inherit;False;216;CutoutEdges;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;248;-176.0531,1833.143;Inherit;False;Property;_WallpaperDamageNMScale;Wallpaper Damage NM Scale;21;0;Create;True;0;0;0;False;0;False;0;1.44;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-726.3403,827.7397;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-1019.908,1254.706;Inherit;False;Property;_WallpaperNMScale;Wallpaper NM Scale;18;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-220.7481,1667.851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1151.477,59.88702;Inherit;False;Property;_SmoothnessMain;Smoothness Main;30;0;Create;True;0;0;0;False;0;False;0;0.7176471;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;132;2568.773,-718.1605;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;209;2635.089,-858.7277;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1145.254,150.5504;Inherit;False;109;RedChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;56.39363,1567.953;Inherit;True;Property;_WallpaperDamageNM;Wallpaper Damage NM;22;0;Create;True;0;0;0;False;0;False;-1;0da19aae1d657d543b1ed240be84f780;0da19aae1d657d543b1ed240be84f780;True;2;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.21;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;115;-529.4136,832.226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;-560.8548,492.728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-565.1472,57.31076;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-684.1607,1185.605;Inherit;True;Property;_WallpaperNM;Wallpaper NM;17;0;Create;True;0;0;0;False;0;False;-1;5a27fac40c9b3844c8307dd41bde1736;5a27fac40c9b3844c8307dd41bde1736;True;2;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;3042.748,-857.265;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;-272.4643,1414.513;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-232.946,53.98882;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;9.679614,1214.28;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;3383.34,-865.3452;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;244;-564.115,-2505.866;Inherit;False;OpacityMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;259.3993,1249.066;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;2498.588,2082.309;Inherit;False;103;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-12.80255,43.12411;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;328;2402.615,1857.568;Inherit;False;Property;_Color;Color;39;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-196.1545,-1833.021;Inherit;False;Property;_ColorMain;Color Main;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.235872,0.5554137,0.624,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;1816.492,-459.4988;Inherit;False;Property;_DirtColor;Dirt Color;23;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2783019,0.5013245,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;751.0162,-1882.703;Inherit;False;Splinters;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;290.5832,-699.5139;Inherit;False;Property;_PaperColor;Paper Color;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.545,0.5014,0.4287331,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;93;2584.273,2188.582;Inherit;False;92;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;2573.149,2306.75;Inherit;False;117;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;245;2575.78,2406.285;Inherit;False;244;OpacityMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;2734.535,2093.23;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2863.328,2118.867;Float;False;True;-1;2;;0;0;Standard;DBK/Wallpaper;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;36;-1;-1;-1;1;Pattern=True;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;232;1
WireConnection;4;1;3;0
WireConnection;5;0;4;0
WireConnection;5;1;2;2
WireConnection;325;1;296;0
WireConnection;325;0;324;0
WireConnection;233;0;232;2
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;326;0;233;0
WireConnection;298;0;297;0
WireConnection;298;1;325;0
WireConnection;229;0;2;3
WireConnection;229;1;230;0
WireConnection;10;0;326;0
WireConnection;10;1;9;0
WireConnection;10;2;8;0
WireConnection;288;0;292;0
WireConnection;288;1;289;0
WireConnection;290;0;289;0
WireConnection;290;1;293;0
WireConnection;320;0;298;0
WireConnection;11;0;10;0
WireConnection;304;0;299;0
WireConnection;304;1;320;0
WireConnection;301;0;299;0
WireConnection;301;1;298;0
WireConnection;283;0;288;0
WireConnection;283;1;290;0
WireConnection;220;0;229;0
WireConnection;172;0;11;0
WireConnection;302;0;300;0
WireConnection;302;1;301;0
WireConnection;305;0;300;0
WireConnection;305;1;304;0
WireConnection;282;1;283;0
WireConnection;238;0;236;2
WireConnection;174;0;173;0
WireConnection;174;1;172;0
WireConnection;175;0;172;0
WireConnection;307;0;305;0
WireConnection;167;1;282;0
WireConnection;226;0;236;3
WireConnection;226;1;222;0
WireConnection;213;0;205;0
WireConnection;306;0;302;0
WireConnection;69;0;226;0
WireConnection;69;1;70;0
WireConnection;214;0;213;0
WireConnection;214;1;212;0
WireConnection;234;0;232;3
WireConnection;323;0;298;0
WireConnection;168;0;167;4
WireConnection;168;1;164;0
WireConnection;107;0;238;0
WireConnection;107;1;108;0
WireConnection;237;0;236;2
WireConnection;176;0;175;0
WireConnection;176;1;174;0
WireConnection;239;0;236;4
WireConnection;321;0;299;0
WireConnection;321;1;323;0
WireConnection;68;0;273;0
WireConnection;68;1;69;0
WireConnection;215;0;214;0
WireConnection;235;0;234;0
WireConnection;105;0;237;0
WireConnection;105;1;107;0
WireConnection;38;0;236;1
WireConnection;38;1;39;0
WireConnection;177;1;176;0
WireConnection;170;0;272;0
WireConnection;170;1;167;0
WireConnection;170;2;168;0
WireConnection;27;0;235;0
WireConnection;27;1;29;0
WireConnection;26;0;2;1
WireConnection;179;0;177;0
WireConnection;240;0;239;0
WireConnection;33;0;170;0
WireConnection;33;1;38;0
WireConnection;54;0;105;0
WireConnection;54;1;55;0
WireConnection;308;0;300;0
WireConnection;308;1;321;0
WireConnection;223;0;68;0
WireConnection;216;0;215;0
WireConnection;242;0;232;4
WireConnection;25;1;26;0
WireConnection;25;3;27;0
WireConnection;25;4;23;0
WireConnection;25;5;24;0
WireConnection;312;0;308;0
WireConnection;52;0;54;0
WireConnection;52;1;33;0
WireConnection;162;0;240;0
WireConnection;162;1;223;0
WireConnection;162;2;196;0
WireConnection;51;0;33;0
WireConnection;51;1;52;0
WireConnection;123;0;232;3
WireConnection;163;0;68;0
WireConnection;163;1;162;0
WireConnection;217;0;188;0
WireConnection;217;1;218;0
WireConnection;74;0;25;0
WireConnection;200;0;220;0
WireConnection;109;0;232;1
WireConnection;210;0;217;0
WireConnection;210;1;211;0
WireConnection;14;0;51;0
WireConnection;14;1;163;0
WireConnection;14;2;12;0
WireConnection;42;0;294;0
WireConnection;42;1;243;0
WireConnection;154;0;75;0
WireConnection;154;1;153;0
WireConnection;199;0;91;0
WireConnection;199;1;200;0
WireConnection;129;0;124;0
WireConnection;100;0;79;0
WireConnection;100;1;149;0
WireConnection;114;0;116;0
WireConnection;114;1;85;0
WireConnection;203;0;2;1
WireConnection;203;1;204;0
WireConnection;132;0;42;0
WireConnection;209;0;14;0
WireConnection;209;1;210;0
WireConnection;20;5;248;0
WireConnection;115;0;114;0
WireConnection;101;0;100;0
WireConnection;110;0;77;0
WireConnection;110;1;111;0
WireConnection;110;2;129;0
WireConnection;19;5;247;0
WireConnection;30;0;209;0
WireConnection;30;1;132;0
WireConnection;30;2;154;0
WireConnection;202;0;199;0
WireConnection;202;1;203;0
WireConnection;202;2;231;0
WireConnection;102;0;110;0
WireConnection;102;1;101;0
WireConnection;102;2;115;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;202;0
WireConnection;103;0;30;0
WireConnection;244;0;205;0
WireConnection;92;0;21;0
WireConnection;117;0;102;0
WireConnection;119;0;236;3
WireConnection;327;0;104;0
WireConnection;327;1;328;0
WireConnection;0;0;327;0
WireConnection;0;1;93;0
WireConnection;0;4;118;0
WireConnection;0;10;245;0
ASEEND*/
//CHKSM=81B35B3DB4BBF5305EB4647A1FC8DF4F68BC5098