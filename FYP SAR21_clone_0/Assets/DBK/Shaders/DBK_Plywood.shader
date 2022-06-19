// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Plywood"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_ColorTheme("Color Theme", 2D) = "white" {}
		_DirtOverlay("Dirt Overlay", Range( 0 , 1)) = 0
		_EdgesOverlayMultiply("Edges Overlay Multiply", Range( 0 , 2)) = 0
		_EdgesOverlayPower("Edges Overlay Power", Range( 0 , 2)) = 0
		_SplintersOverlay("Splinters Overlay", Range( 0 , 1)) = 0
		_BrightAreas("Bright Areas", Range( 0 , 1)) = 0
		_EdgesBrightness("Edges Brightness", Range( 0 , 2)) = 0
		_PlywoodDamageNM("Plywood Damage NM", 2D) = "bump" {}
		_PlywoodDamgeNMScale("Plywood Damge NM Scale", Range( 0 , 2)) = 0
		_PlywoodNM("Plywood NM", 2D) = "bump" {}
		_PlywoodNMScale("Plywood NM Scale", Range( 0 , 2)) = 0
		_MainTex("RGBA Mask A", 2D) = "white" {}
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0.421177
		[DamageMaxGay]_DamageSmooth("Damage Smooth", Range( 0 , 100)) = 0
		_DamageMultiplier("Damage Multiplier", Range( 0 , 1)) = 0.1946161
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 2)) = 0
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_SmoothnessWood("Smoothness Wood", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
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
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv4_texcoord4;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform sampler2D _PlywoodNM;
		uniform float4 _PlywoodNM_ST;
		uniform float _PlywoodNMScale;
		uniform sampler2D _PlywoodDamageNM;
		uniform float4 _PlywoodDamageNM_ST;
		uniform float _PlywoodDamgeNMScale;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _DamageMultiplier;
		uniform float _DamageAmount;
		uniform float _DamageSmooth;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _ColorTheme;
		uniform int _ColorSelect;
		uniform float _DirtOverlay;
		uniform float _SplintersOverlay;
		uniform float _EdgesOverlayMultiply;
		uniform float _EdgesOverlayPower;
		uniform float _BrightAreas;
		uniform float _EdgesBrightness;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _SmoothnessWood;
		uniform float _SmoothnessDamage;
		uniform float _SmoothnessDirt;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv4_PlywoodNM = i.uv4_texcoord4 * _PlywoodNM_ST.xy + _PlywoodNM_ST.zw;
			float2 uv4_PlywoodDamageNM = i.uv4_texcoord4 * _PlywoodDamageNM_ST.xy + _PlywoodDamageNM_ST.zw;
			float2 uv4_RGBAMaskB = i.uv4_texcoord4 * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode1 = tex2D( _RGBAMaskB, uv4_RGBAMaskB );
			float HeightMask10 = saturate(pow(((( 1.0 - tex2DNode1.a )*( ( ( tex2DNode1.r * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount ))*4)+(( ( ( tex2DNode1.r * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount )*2),_DamageSmooth));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode236 = tex2D( _MainTex, uv_MainTex );
			float3 temp_cast_0 = (pow( ( 1.0 - tex2DNode236.a ) , 0.46 )).xxx;
			float3 desaturateInitialColor181 = temp_cast_0;
			float desaturateDot181 = dot( desaturateInitialColor181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar181 = lerp( desaturateInitialColor181, desaturateDot181.xxx, 1.0 );
			float3 CutoutEdges182 = desaturateVar181;
			float3 Heightmap11 = ( HeightMask10 + CutoutEdges182 );
			float3 lerpResult21 = lerp( UnpackScaleNormal( tex2D( _PlywoodNM, uv4_PlywoodNM ), _PlywoodNMScale ) , UnpackScaleNormal( tex2D( _PlywoodDamageNM, uv4_PlywoodDamageNM ), _PlywoodDamgeNMScale ) , Heightmap11);
			float3 Normals92 = lerpResult21;
			o.Normal = Normals92;
			half2 _ColorsNumber = half2(0,-0.1);
			float2 temp_output_274_0 = ( half2( 0.015625,0 ) * _ColorSelect );
			float2 uv_TexCoord278 = i.uv_texcoord * _ColorsNumber + temp_output_274_0;
			float4 Color1UV3259 = tex2D( _ColorTheme, uv_TexCoord278 );
			float2 uv4_MainTex = i.uv4_texcoord4 * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode229 = tex2D( _MainTex, uv4_MainTex );
			float2 appendResult275 = (float2(temp_output_274_0.x , 0.5));
			float2 uv_TexCoord277 = i.uv_texcoord * _ColorsNumber + appendResult275;
			float4 Color2UV3258 = tex2D( _ColorTheme, uv_TexCoord277 );
			float3 clampResult221 = clamp( ( Heightmap11 + pow( ( tex2DNode229.g + ( tex2DNode229.g * _EdgesOverlayMultiply ) ) , _EdgesOverlayPower ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float4 lerpResult14 = lerp( ( Color1UV3259 * pow( tex2DNode229.r , _DirtOverlay ) ) , ( Color2UV3258 * pow( tex2DNode229.b , _SplintersOverlay ) ) , float4( clampResult221 , 0.0 ));
			float2 appendResult284 = (float2(temp_output_274_0.x , 0.1));
			float2 uv_TexCoord285 = i.uv_texcoord * _ColorsNumber + appendResult284;
			float4 DirtColorUV3260 = tex2D( _ColorTheme, uv_TexCoord285 );
			float HeightMaskBlue232 = tex2DNode1.b;
			float3 temp_cast_5 = (( tex2DNode1.g * _DirtMultiplier )).xxx;
			float3 temp_cast_6 = (( 1.0 - ( i.vertexColor.r * tex2DNode1.r ) )).xxx;
			float DirtHeight74 = saturate( ( 1.0 - ( ( distance( temp_cast_5 , temp_cast_6 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult30 = lerp( ( lerpResult14 + ( i.vertexColor.a * _BrightAreas * lerpResult14 ) + ( float4( CutoutEdges182 , 0.0 ) * _EdgesBrightness * lerpResult14 ) ) , ( DirtColorUV3260 * HeightMaskBlue232 ) , saturate( ( DirtHeight74 * _DirtOpacity ) ));
			float4 Albedo103 = lerpResult30;
			o.Albedo = ( Albedo103 * _Color ).rgb;
			float RedChannelRGBA109 = tex2DNode1.r;
			float GreenChannelRGBA123 = tex2DNode1.g;
			float Splinters119 = tex2DNode229.b;
			float3 Smoothness117 = ( ( _SmoothnessWood * RedChannelRGBA109 * ( 1.0 - GreenChannelRGBA123 ) ) * ( 1.0 - ( _SmoothnessDamage * ( 1.0 - Splinters119 ) * Heightmap11 ) ) * ( 1.0 - ( _SmoothnessDirt * DirtHeight74 ) ) );
			o.Smoothness = Smoothness117.x;
			o.Alpha = 1;
			float OpacityMask225 = tex2DNode236.a;
			clip( OpacityMask225 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-125.5053;343.5759;2.956739;True;False
Node;AmplifyShaderEditor.CommentaryNode;133;-1063.658,-1922.222;Inherit;False;4646.898;1760.805;Comment;36;233;264;42;196;30;237;238;75;103;223;198;199;14;222;224;197;119;175;33;221;69;38;165;262;263;12;54;70;39;55;105;107;229;108;235;287;Albedo;0.3837695,0.9528302,0.2382075,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;235;-989.7699,-1897.58;Inherit;True;Property;_MainTex;RGBA Mask A;12;0;Create;False;0;0;0;False;0;False;04d81ebac7469fd4f914698f8d42bae3;04d81ebac7469fd4f914698f8d42bae3;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;227;-647.2953,-2426.147;Inherit;False;1189.001;454.9998;Comment;6;193;177;181;225;182;236;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;134;-746.2286,2682.982;Inherit;False;2042.616;505.1451;Comment;14;3;1;4;5;7;9;6;8;10;123;109;184;194;232;Height Selection;0.509434,0.1561944,0.4762029,1;0;0
Node;AmplifyShaderEditor.SamplerNode;236;-627.7699,-2323.58;Inherit;True;Property;_TextureSample0;Texture Sample 0;28;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;193;-277.2947,-2136.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;135;-742.0518,1994.971;Inherit;False;1773.052;556.8823;Comment;10;29;27;24;23;26;25;74;2;170;265;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-136.5159,2834.405;Float;False;Property;_DamageMultiplier;Damage Multiplier;15;0;Create;True;0;0;0;False;0;False;0.1946161;0.618;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-696.2286,2752.74;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;20;0;Create;True;0;0;0;False;0;False;-1;None;86aa9166f25685443af56f01a5e6ca8a;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;21.5301,2734.282;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;177;-53.29473,-2120.147;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;271;615.7833,-2788.104;Inherit;False;2080.08;813.5428;Comment;16;286;285;284;281;280;278;277;276;275;274;273;272;259;258;260;247;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;2;-698.4534,2066.788;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;181;106.7053,-2104.147;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;273;747.5758,-2693.964;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.IntNode;272;725.8193,-2515.291;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;65.26547,3051.196;Float;False;Property;_DamageAmount;Damage Amount;13;0;Create;True;0;0;0;False;0;False;0.421177;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;243.3713,2733.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;298.7054,-2120.147;Inherit;False;CutoutEdges;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;1070.873,-2574.771;Inherit;False;2;2;0;FLOAT2;0,0;False;1;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;6;139.4983,2919.777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;467.343,2726.12;Float;False;Property;_DamageSmooth;Damage Smooth;14;0;Create;True;0;0;0;False;1;DamageMaxGay;False;0;57.2;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;494.9657,2997.131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;229;-591.2513,-1895.21;Inherit;True;Property;_PlywoodDirtMaskRGBA;Plywood Dirt Mask RGBA;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;275;1281.868,-2283.198;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;108;53.3148,-1711.913;Inherit;False;Property;_EdgesOverlayMultiply;Edges Overlay Multiply;3;0;Create;True;0;0;0;False;0;False;0;0.75;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;10;743.837,2891.374;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;276;1121.57,-2767.084;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;184;850.8368,3052.233;Inherit;False;182;CutoutEdges;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;247;1556.029,-2567.285;Inherit;True;Property;_ColorTheme;Color Theme;1;0;Create;True;0;0;0;False;0;False;a32069a720abdd54197636040b9ff88f;a32069a720abdd54197636040b9ff88f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;352.9571,-1714.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;194;1077.328,2889.083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;278;1555.464,-2714.984;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;277;1549.034,-2301.61;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-140.6028,2486.835;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;19;0;Create;True;0;0;0;False;0;False;0;1.19;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;569.5569,-1859.074;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;1225.937,2897.981;Inherit;False;Heightmap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;281;1980.575,-2714.879;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;280;1985.781,-2436.371;Inherit;True;Property;_Texture4;Texture4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-73.5936,2051.793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;317.1829,-1553.605;Inherit;False;Property;_EdgesOverlayPower;Edges Overlay Power;4;0;Create;True;0;0;0;False;0;False;0;1.57;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;44.68418,2186.423;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;258;2420.763,-2420.663;Inherit;False;Color2UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;284;1283.406,-2088.263;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;191.1681,2436.854;Inherit;False;Property;_DirtSmooth;Dirt Smooth;18;0;Create;True;0;0;0;False;0;False;0;0.919;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;135.3116,2074.37;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;693.9828,-1698.106;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;699.2614,-639.4361;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;2424.053,-2646.831;Inherit;False;Color1UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;143.5719,2307.128;Inherit;False;Property;_DirtRange;Dirt Range;17;0;Create;True;0;0;0;False;0;False;0;0.058;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-119.4735,-948.863;Inherit;False;Property;_SplintersOverlay;Splinters Overlay;5;0;Create;True;0;0;0;False;0;False;0;0.3312967;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-343.3542,-1276.327;Inherit;False;Property;_DirtOverlay;Dirt Overlay;2;0;Create;True;0;0;0;False;0;False;0;0.281;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;69;177.938,-1000.364;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;396.2587,-1207.281;Inherit;False;259;Color1UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;967.3132,-680.6255;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;25;465.9896,2052.965;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;192.5356,-1326.078;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;263;-403.5208,-514.3214;Inherit;False;258;Color2UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;285;1556.052,-2127.063;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;341.6737,-787.3752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;687.1138,-1341.253;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;286;1997.052,-2203.013;Inherit;True;Property;_TextureSample5;Texture Sample 5;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-401.9734,-1564.391;Inherit;False;Splinters;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;788.0005,2044.972;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;221;1158.004,-673.0017;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;131;-722.0502,27.74768;Inherit;False;1432.054;1002.007;Comment;17;100;79;122;120;116;85;114;115;102;117;77;111;124;129;110;101;149;Smoothness;0.8113208,0.2411,0.2411,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-614.8227,667.0175;Inherit;False;119;Splinters;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;1593.088,-602.4937;Inherit;False;182;CutoutEdges;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-345.9555,2968.955;Inherit;False;GreenChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;197;1332.871,-1365.505;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;199;1308.826,-1085.712;Inherit;False;Property;_BrightAreas;Bright Areas;6;0;Create;True;0;0;0;False;0;False;0;0.435;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;1331.791,-818.5005;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;2405.334,-2175.284;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;2340.671,-335.8779;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;1521.834,-493.939;Inherit;False;Property;_EdgesBrightness;Edges Brightness;7;0;Create;True;0;0;0;False;0;False;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;232;-257.0614,2729.339;Inherit;False;HeightMaskBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;2313.265,-234.7779;Inherit;False;Property;_DirtOpacity;Dirt Opacity;16;0;Create;True;0;0;0;False;0;False;0;0.6989186;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-724.0117,1165.481;Inherit;False;1171.65;670.8091;Normals;7;228;92;21;19;91;20;230;Normals;0.0572713,0.3924344,0.9339623,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-625.1398,549.1328;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;23;0;Create;True;0;0;0;False;0;False;0;0.9486387;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-621.6784,276.1552;Inherit;False;123;GreenChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-534.6767,813.6535;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;21;0;Create;True;0;0;0;False;0;False;0;0.8738884;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-341.663,3070.334;Inherit;False;RedChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-614.3345,431.4934;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;2323.127,-675.6005;Inherit;False;260;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;122;-407.1365,660.7415;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-507.4825,914.7542;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;2597.291,-304.1847;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;1855.835,-693.8391;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;1681.618,-1141.415;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;2309.262,-571.1226;Inherit;False;232;HeightMaskBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-697.0707,1652.733;Inherit;False;Property;_PlywoodDamgeNMScale;Plywood Damge NM Scale;9;0;Create;True;0;0;0;False;0;False;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-672.0501,77.74767;Inherit;False;Property;_SmoothnessWood;Smoothness Wood;22;0;Create;True;0;0;0;False;0;False;0;0.319;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-270.1417,229.6478;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-700.0433,1278.79;Inherit;False;Property;_PlywoodNMScale;Plywood NM Scale;11;0;Create;True;0;0;0;False;0;False;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-196.9333,547.459;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;2569.565,-668.8295;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-123.395,857.0247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;2109.599,-837.7999;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;287;2801.582,-439.6581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-653.8271,165.411;Inherit;False;109;RedChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;4.092283,546.0908;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-412.5223,1215.481;Inherit;True;Property;_PlywoodNM;Plywood NM;10;0;Create;True;0;0;0;False;0;False;-1;76e5ce818444e0d4c99809e43e58eebe;76e5ce818444e0d4c99809e43e58eebe;True;3;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;2830.154,-838.1873;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-56.71875,81.17141;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-370.468,1592.291;Inherit;True;Property;_PlywoodDamageNM;Plywood Damage NM;8;0;Create;True;0;0;0;False;0;False;-1;b1c6f48ae52428445954efaf41a87b35;b1c6f48ae52428445954efaf41a87b35;True;3;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;115;68.58083,852.4777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-376.8484,1464.627;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;3227.293,-850.4442;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;-31.68486,1421.691;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;275.4826,77.84946;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;1679.554,949.442;Inherit;False;103;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;204.6376,1433.382;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;225;-213.2947,-2296.147;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;497.6258,82.98476;Inherit;False;Smoothness;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;289;1665.774,712.4402;Inherit;False;Property;_Color;Color;25;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;1859.694,942.1024;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;1720.239,1050.715;Inherit;False;92;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;1709.115,1168.883;Inherit;False;117;Smoothness;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;1718.299,1289.075;Inherit;False;225;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-504.1084,2325.87;Inherit;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2004.294,1002;Float;False;True;-1;2;;0;0;Standard;DBK/Plywood;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;24;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;236;0;235;0
WireConnection;193;0;236;4
WireConnection;4;0;1;1
WireConnection;4;1;3;0
WireConnection;177;0;193;0
WireConnection;181;0;177;0
WireConnection;5;0;4;0
WireConnection;5;1;2;2
WireConnection;182;0;181;0
WireConnection;274;0;273;0
WireConnection;274;1;272;0
WireConnection;6;0;1;4
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;229;0;235;0
WireConnection;275;0;274;0
WireConnection;10;0;6;0
WireConnection;10;1;9;0
WireConnection;10;2;8;0
WireConnection;107;0;229;2
WireConnection;107;1;108;0
WireConnection;194;0;10;0
WireConnection;194;1;184;0
WireConnection;278;0;276;0
WireConnection;278;1;274;0
WireConnection;277;0;276;0
WireConnection;277;1;275;0
WireConnection;105;0;229;2
WireConnection;105;1;107;0
WireConnection;11;0;194;0
WireConnection;281;0;247;0
WireConnection;281;1;278;0
WireConnection;280;0;247;0
WireConnection;280;1;277;0
WireConnection;170;0;2;1
WireConnection;170;1;1;1
WireConnection;27;0;1;2
WireConnection;27;1;29;0
WireConnection;258;0;280;0
WireConnection;284;0;274;0
WireConnection;26;0;170;0
WireConnection;54;0;105;0
WireConnection;54;1;55;0
WireConnection;259;0;281;0
WireConnection;69;0;229;3
WireConnection;69;1;70;0
WireConnection;165;0;12;0
WireConnection;165;1;54;0
WireConnection;25;1;26;0
WireConnection;25;3;27;0
WireConnection;25;4;23;0
WireConnection;25;5;24;0
WireConnection;38;0;229;1
WireConnection;38;1;39;0
WireConnection;285;0;276;0
WireConnection;285;1;284;0
WireConnection;175;0;263;0
WireConnection;175;1;69;0
WireConnection;33;0;262;0
WireConnection;33;1;38;0
WireConnection;286;0;247;0
WireConnection;286;1;285;0
WireConnection;119;0;229;3
WireConnection;74;0;25;0
WireConnection;221;0;165;0
WireConnection;123;0;1;2
WireConnection;14;0;33;0
WireConnection;14;1;175;0
WireConnection;14;2;221;0
WireConnection;260;0;286;0
WireConnection;232;0;1;3
WireConnection;109;0;1;1
WireConnection;122;0;120;0
WireConnection;237;0;75;0
WireConnection;237;1;238;0
WireConnection;223;0;222;0
WireConnection;223;1;224;0
WireConnection;223;2;14;0
WireConnection;198;0;197;4
WireConnection;198;1;199;0
WireConnection;198;2;14;0
WireConnection;129;0;124;0
WireConnection;100;0;79;0
WireConnection;100;1;122;0
WireConnection;100;2;149;0
WireConnection;42;0;264;0
WireConnection;42;1;233;0
WireConnection;114;0;116;0
WireConnection;114;1;85;0
WireConnection;196;0;14;0
WireConnection;196;1;198;0
WireConnection;196;2;223;0
WireConnection;287;0;237;0
WireConnection;101;0;100;0
WireConnection;19;5;230;0
WireConnection;30;0;196;0
WireConnection;30;1;42;0
WireConnection;30;2;287;0
WireConnection;110;0;77;0
WireConnection;110;1;111;0
WireConnection;110;2;129;0
WireConnection;20;5;228;0
WireConnection;115;0;114;0
WireConnection;103;0;30;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;91;0
WireConnection;102;0;110;0
WireConnection;102;1;101;0
WireConnection;102;2;115;0
WireConnection;92;0;21;0
WireConnection;225;0;236;4
WireConnection;117;0;102;0
WireConnection;288;0;104;0
WireConnection;288;1;289;0
WireConnection;265;0;2;4
WireConnection;0;0;288;0
WireConnection;0;1;93;0
WireConnection;0;4;118;0
WireConnection;0;10;226;0
ASEEND*/
//CHKSM=44BBF9287B5C6DC49579292EE85C3A6F5BDB85D2