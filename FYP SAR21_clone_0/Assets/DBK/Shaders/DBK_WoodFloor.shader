// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/WoodFloor"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_DirtOverlay("Dirt Overlay", Range( 0.05 , 1)) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_DirtDamageOverlay("Dirt Damage Overlay", Range( 0.01 , 1)) = 0
		_EdgesOverlay("Edges Overlay", Range( 0 , 3)) = 0
		_EdgesDamageOverlay("Edges Damage Overlay", Range( 0 , 2)) = 0
		_TransitionAmount("Transition Amount", Range( 0.01 , 0.5)) = 0
		_DamageAmount("Damage Amount", Range( 0 , 1)) = 0.421177
		_DamageSmooth("Damage Smooth", Range( 0 , 100)) = 0
		_DamageMultiplier("Damage Multiplier", Range( 0 , 1)) = 0.1946161
		_NormalDamage("Normal Damage", 2D) = "bump" {}
		_NormalDamageScale("Normal Damage Scale", Range( 0 , 2)) = 0
		_NormalGood("Normal Good", 2D) = "bump" {}
		_NormalGoodScale("Normal Good Scale", Range( 0 , 2)) = 0
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 1)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 3)) = 0
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_RGBAMaskC("RGBA Mask C", 2D) = "white" {}
		_SmoothnessMain("Smoothness Main", Range( 0 , 1)) = 0
		_SmoothnessDamage("Smoothness Damage", Range( 0 , 1)) = 0
		_SmoothnessDirt("Smoothness Dirt", Range( 0 , 1)) = 0
		_SmoothnessMainDirt("Smoothness Main Dirt", Range( 0 , 2)) = 1
		_EdgeBrighntess("Edge Brighntess", Range( 0 , 2)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
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
		#pragma target 3.0
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
		uniform float _NormalGoodScale;
		uniform sampler2D _NormalDamage;
		uniform float4 _NormalDamage_ST;
		uniform float _NormalDamageScale;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _DamageMultiplier;
		uniform float _DamageAmount;
		uniform float _DamageSmooth;
		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _DirtOverlay;
		uniform float _EdgesOverlay;
		uniform float _DirtDamageOverlay;
		uniform float _TransitionAmount;
		uniform float _EdgeBrighntess;
		uniform float _EdgesDamageOverlay;
		uniform sampler2D _RGBAMaskC;
		uniform float4 _RGBAMaskC_ST;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _SmoothnessMain;
		uniform float _SmoothnessMainDirt;
		uniform float _SmoothnessDamage;
		uniform float _SmoothnessDirt;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalGood = i.uv_texcoord * _NormalGood_ST.xy + _NormalGood_ST.zw;
			float2 uv_NormalDamage = i.uv_texcoord * _NormalDamage_ST.xy + _NormalDamage_ST.zw;
			float2 uv_RGBAMaskA = i.uv_texcoord * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode178 = tex2D( _RGBAMaskA, uv_RGBAMaskA );
			float HeightMask10 = saturate(pow(((tex2DNode178.b*( ( ( ( 1.0 - tex2DNode178.g ) * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount ))*4)+(( ( ( ( 1.0 - tex2DNode178.g ) * _DamageMultiplier ) * i.vertexColor.g ) * _DamageAmount )*2),_DamageSmooth));
			float Heightmap11 = HeightMask10;
			float3 lerpResult21 = lerp( UnpackScaleNormal( tex2D( _NormalGood, uv_NormalGood ), _NormalGoodScale ) , UnpackScaleNormal( tex2D( _NormalDamage, uv_NormalDamage ), _NormalDamageScale ) , Heightmap11);
			float3 Normals92 = lerpResult21;
			o.Normal = Normals92;
			half2 _ColorsNumber = half2(0,-0.1);
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch338 = (float)_CustomColor;
			#else
				float staticSwitch338 = (float)_ColorSelect;
			#endif
			float2 temp_output_324_0 = ( half2( 0.015625,0 ) * staticSwitch338 );
			float2 uv_TexCoord328 = i.uv_texcoord * _ColorsNumber + temp_output_324_0;
			float4 Color1UV3309 = tex2D( _MainTex, uv_TexCoord328 );
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode268 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float4 temp_output_33_0 = ( Color1UV3309 * ( 1.0 - ( ( 1.0 - tex2DNode268.r ) * _DirtOverlay ) ) );
			float2 appendResult325 = (float2(temp_output_324_0.x , 0.5));
			float2 uv_TexCoord327 = i.uv_texcoord * _ColorsNumber + appendResult325;
			float4 Color2UV3307 = tex2D( _MainTex, uv_TexCoord327 );
			float HeightBricks256 = Heightmap11;
			float clampResult264 = clamp( step( 0.1 , ( ( 1.0 - HeightBricks256 ) * step( _TransitionAmount , HeightBricks256 ) ) ) , 0.0 , 1.0 );
			float BricksStep262 = clampResult264;
			float clampResult314 = clamp( ( Heightmap11 + BricksStep262 ) , 0.0 , 1.0 );
			float4 lerpResult14 = lerp( ( temp_output_33_0 + ( ( tex2DNode268.g * _EdgesOverlay ) * temp_output_33_0 ) ) , ( ( Color2UV3307 * pow( tex2DNode268.b , _DirtDamageOverlay ) ) + ( ( ( tex2DNode268.a + ( BricksStep262 * _EdgeBrighntess ) ) * _EdgesDamageOverlay ) * Color2UV3307 ) ) , clampResult314);
			float2 appendResult331 = (float2(temp_output_324_0.x , 0.1));
			float2 uv_TexCoord333 = i.uv_texcoord * _ColorsNumber + appendResult331;
			float4 DirtColorUV3311 = tex2D( _MainTex, uv_TexCoord333 );
			float2 uv_RGBAMaskC = i.uv_texcoord * _RGBAMaskC_ST.xy + _RGBAMaskC_ST.zw;
			float3 temp_cast_4 = (( tex2DNode178.r * _DirtMultiplier )).xxx;
			float3 temp_cast_5 = (( 1.0 - ( i.vertexColor.r * tex2DNode178.g ) )).xxx;
			float DirtHeight74 = saturate( ( 1.0 - ( ( distance( temp_cast_4 , temp_cast_5 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult30 = lerp( lerpResult14 , ( DirtColorUV3311 * tex2D( _RGBAMaskC, uv_RGBAMaskC ).r ) , ( DirtHeight74 * _DirtOpacity ));
			float4 Albedo103 = lerpResult30;
			o.Albedo = ( Albedo103 * _Color ).rgb;
			float GreenChannelRGBA123 = tex2DNode178.r;
			float RedChannelRGBA109 = tex2DNode178.g;
			float Smoothness117 = ( ( _SmoothnessMain * ( 1.0 - ( GreenChannelRGBA123 * _SmoothnessMainDirt ) ) * RedChannelRGBA109 ) * ( 1.0 - ( _SmoothnessDamage * Heightmap11 ) ) * ( 1.0 - ( _SmoothnessDirt * DirtHeight74 ) ) );
			o.Smoothness = Smoothness117;
			o.Alpha = 1;
			float2 uv4_RGBAMaskC = i.uv4_texcoord4 * _RGBAMaskC_ST.xy + _RGBAMaskC_ST.zw;
			float OpacityMask276 = tex2D( _RGBAMaskC, uv4_RGBAMaskC ).g;
			clip( OpacityMask276 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-1467.208;-526.8101;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;134;-781.6177,2695.788;Inherit;False;2599.879;576.3812;Comment;14;109;11;10;8;9;7;5;4;204;191;203;3;178;123;Height Selection;0.509434,0.1561944,0.4762029,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;135;-691.4587,1991.319;Inherit;False;2366.052;568.8823;Comment;10;74;25;27;26;24;23;29;2;201;206;Dirt;0.6037736,0.1110716,0.1110716,1;0;0
Node;AmplifyShaderEditor.SamplerNode;178;-721.4317,2830.978;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;21;0;Create;True;0;0;0;False;0;False;-1;6afe04ce43211ab4485f54e3c5396a55;6afe04ce43211ab4485f54e3c5396a55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-252.5237,2047.29;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;119.4439,2850.231;Float;False;Property;_DamageMultiplier;Damage Multiplier;9;0;Create;True;0;0;0;False;0;False;0.1946161;0.57;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;203;15.98356,2786.019;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;191;-203.5583,2714.96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;204;24.29795,2810.961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;395.1598,2725.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;718.6127,2734.034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;668.4471,3080.968;Float;False;Property;_DamageAmount;Damage Amount;7;0;Create;True;0;0;0;False;0;False;0.421177;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;901.0327,2755.771;Float;False;Property;_DamageSmooth;Damage Smooth;8;0;Create;True;0;0;0;False;0;False;0;17.4;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;1056.57,3018.909;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;10;1237.228,2911.356;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;1602.81,2911.001;Inherit;False;Heightmap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;274;1889.381,2813.723;Inherit;False;1290.191;448.9541;;8;257;255;256;258;259;261;264;262;Edges;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;1939.381,2877.038;Inherit;False;HeightBricks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;1944.042,3135.316;Inherit;False;Property;_TransitionAmount;Transition Amount;6;0;Create;True;0;0;0;False;0;False;0;0.291;0.01;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;258;2240.874,2875.573;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;321;-3213.242,-1034.155;Inherit;False;2080.08;813.5428;Comment;14;336;333;332;331;330;329;328;327;326;325;324;323;322;338;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;257;2283.266,3129.677;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;337;-3217.109,-590.6686;Inherit;False;Property;_CustomColor;Custom Color;31;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;322;-3207.256,-733.0098;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;2454.803,2870.184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;261;2649.621,2864.59;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;338;-3015.833,-657.9148;Inherit;False;Property;_UseCustomColor;Use Custom Color;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;323;-3075.449,-938.0146;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;-2713.152,-808.8217;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;326;-2710.455,-1006.135;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;264;2781.093,2873.358;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;133;-843.0728,-1935.745;Inherit;False;3720.08;1849.654;Comment;43;268;39;42;242;234;272;271;270;69;269;70;32;119;103;30;154;14;193;75;265;163;153;12;241;266;68;162;33;159;233;108;158;231;275;279;312;313;314;315;318;319;320;317;Albedo;0.3837695,0.9528302,0.2382075,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;325;-2547.157,-529.2484;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;328;-2273.561,-961.0344;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;329;-2272.996,-813.3356;Inherit;True;Property;_MainTex;Color Theme;2;0;Create;False;0;0;0;False;0;False;82be22460a6b51b4290f4e8782e70cef;82be22460a6b51b4290f4e8782e70cef;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;2966.573,2873.723;Inherit;False;BricksStep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;205;-342.5676,2584.3;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;268;-783.5381,-1444.786;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;22;0;Create;True;0;0;0;False;0;False;-1;None;f231781db1f345444b87eda03c56e007;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;318;-115.46,-1175.305;Inherit;False;Property;_EdgeBrighntess;Edge Brighntess;28;0;Create;True;0;0;0;False;0;False;0;0.9593118;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-436.7383,-1566.45;Inherit;False;Property;_DirtOverlay;Dirt Overlay;1;0;Create;True;0;0;0;False;0;False;0;0.727;0.05;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;332;-1848.449,-960.9294;Inherit;True;Property;_TextureSample2;Texture Sample 2;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;327;-2279.991,-547.6605;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;315;-45.1057,-1264.26;Inherit;False;262;BricksStep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;272;-138.1315,-1457.53;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;206;-8.156269,2456.055;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;234;-422.098,-1699.364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;331;-2545.619,-334.3139;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;267;-338.3058,2303.928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;309;-1401.322,-965.8037;Inherit;False;Color1UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;334.8324,2301.816;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;20;0;Create;True;0;0;0;False;0;False;0;0.91;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;-177.6673,-1811.287;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;330;-1843.243,-682.4217;Inherit;True;Property;_Texture4;Texture4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;270;-83.3316,-1686.529;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;269;198.8681,-1310.229;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;206.84,-1205.705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;305.9952,2060.244;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;271;37.66846,-1725.329;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;819.5394,2450.637;Inherit;False;Property;_DirtSmooth;Dirt Smooth;19;0;Create;True;0;0;0;False;0;False;0;0.725;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;701.7197,2187.721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;755.1041,2062.118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;750.0296,2333.203;Inherit;False;Property;_DirtRange;Dirt Range;18;0;Create;True;0;0;0;False;0;False;0;0.331;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-112.2834,-1422.774;Inherit;False;309;Color1UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;319;363.8401,-1294.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;233;111.2523,-1496.302;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;333;-2272.973,-373.1136;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-1357.339,-683.2271;Inherit;False;Color2UV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-603.7308,-961.3616;Inherit;False;Property;_DirtDamageOverlay;Dirt Damage Overlay;3;0;Create;True;0;0;0;False;0;False;0;0.6785237;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;158.1793,-1037.646;Inherit;False;Property;_EdgesDamageOverlay;Edges Damage Overlay;5;0;Create;True;0;0;0;False;0;False;0;0.3906324;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;106.6614,-1681.366;Inherit;False;Property;_EdgesOverlay;Edges Overlay;4;0;Create;True;0;0;0;False;0;False;0;1.46;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-248.6583,3002.61;Inherit;False;RedChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;411.0353,-1768.837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;266;590.6448,-587.4073;Inherit;False;262;BricksStep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-732.2277,25.78814;Inherit;False;1432.054;1002.007;Comment;19;100;79;116;85;114;115;102;117;77;111;129;110;101;149;196;197;124;253;254;Smoothness;0.8113208,0.2411,0.2411,1;0;0
Node;AmplifyShaderEditor.FunctionNode;25;1109.582,2049.314;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-400.4141,2631.045;Inherit;False;GreenChannelRGBA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;581.7223,-670.1532;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;476.032,-1113.879;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;336;-1831.972,-449.0633;Inherit;True;Property;_TextureSample5;Texture Sample 5;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;69;-208.5882,-1019.263;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;44.70953,-953.4666;Inherit;False;307;Color2UV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;298.8099,-1425.707;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-707.856,161.1956;Inherit;False;123;GreenChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;561.799,-1601.17;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;279;861.5404,-330.5377;Inherit;True;Property;_RGBAMaskC;RGBA Mask C;23;0;Create;True;0;0;0;False;0;False;a82b87e49cd04f84da5b9c8e6a307c18;a82b87e49cd04f84da5b9c8e6a307c18;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;687.6666,-998.1071;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;283.0078,-779.2682;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;1431.593,2041.321;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;265;870.755,-653.2372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-696.1155,280.8477;Inherit;False;Property;_SmoothnessMainDirt;Smoothness Main Dirt;27;0;Create;True;0;0;0;False;0;False;1;1.054981;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-685.5505,373.7146;Inherit;False;109;RedChannelRGBA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-1381.708,-497.4364;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-678.3173,477.1732;Inherit;False;Property;_SmoothnessDamage;Smoothness Damage;25;0;Create;True;0;0;0;False;0;False;0;0.8245484;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-653.0457,870.15;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;1881.887,-469.8284;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-662.7869,768.3034;Inherit;False;Property;_SmoothnessDirt;Smoothness Dirt;26;0;Create;True;0;0;0;False;0;False;0;0.7000955;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-672.512,577.5338;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-424.1155,159.8477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-1174.199,1196.995;Inherit;False;1768.983;664.8091;Normals;11;209;208;211;214;92;21;19;20;91;282;284;Normals;0.0572713,0.3924344,0.9339623,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;320;1394.455,-674.4347;Inherit;False;311;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;945.7884,-781.8021;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;866.4373,-1422.962;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;153;1884.946,-571.4988;Inherit;False;Property;_DirtOpacity;Dirt Opacity;17;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;275;1303.516,-329.2654;Inherit;True;Property;_WoodPlanks_Mask3_RGBA;WoodPlanks_Mask3_RGBA;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;314;1070.794,-677.0955;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;254;-164.6477,384.7161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-682.2276,75.78815;Inherit;False;Property;_SmoothnessMain;Smoothness Main;24;0;Create;True;0;0;0;False;0;False;0;0.663;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-281.6061,516.4995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-1030.127,1358.601;Inherit;False;Property;_NormalGoodScale;Normal Good Scale;13;0;Create;True;0;0;0;False;0;False;0;1.6;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-228.0898,849.6408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;1384.024,-810.2084;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-1040.127,1693.601;Inherit;False;Property;_NormalDamageScale;Normal Damage Scale;11;0;Create;True;0;0;0;False;0;False;0;1.470588;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-205.3196,152.6883;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;2173.847,-517.0167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;1685.033,-594.9026;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;253;-101.6477,320.7161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-31.16304,854.1271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-659.3217,1600.805;Inherit;True;Property;_NormalDamage;Normal Damage;10;0;Create;True;0;0;0;False;0;False;-1;354fbdac97090f6459e46bb63a83353a;8aab7f8423361ec4cb1daf1ebd5a78d7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;-621.2062,1494.927;Inherit;False;11;Heightmap;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;-62.6043,514.6291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-677.3759,1246.995;Inherit;True;Property;_NormalGood;Normal Good;12;0;Create;True;0;0;0;False;0;False;-1;8aab7f8423361ec4cb1daf1ebd5a78d7;354fbdac97090f6459e46bb63a83353a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;18.10329,75.21188;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;2197.153,-812.3801;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;280;1244.153,-52.2758;Inherit;False;706.5334;272.118;Comment;2;276;215;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;215;1294.153,-2.275823;Inherit;True;Property;_TextureSample3;Texture Sample 3;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;265.3045,75.88994;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-288.5388,1453.205;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;2535.817,-846.5422;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;487.448,81.02524;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;2172.572,1019.936;Inherit;False;103;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;340;2045.48,799.2138;Inherit;False;Property;_Color;Color;32;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;391.953,1431.551;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;276;1661.523,50.2796;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;2389.4,979.876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-629.3242,1805.088;Inherit;False;Property;_NormalDirtScale;Normal Dirt Scale;15;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-18.5174,1728.976;Inherit;False;74;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;2251.257,1119.209;Inherit;False;92;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;208;259.4826,1559.976;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;214;-18.81366,1562.861;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;211;-331.5174,1631.976;Inherit;True;Property;_NormalDirt;Normal Dirt;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;1268.046,-548.8735;Inherit;False;Property;_DirtColor;Dirt Color;16;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9176471,0.8779839,0.8212941,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-591.7585,-1154.071;Inherit;False;DirtDamage;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;2251.388,1392.16;Inherit;False;276;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;2242.768,1210.41;Inherit;False;117;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2531.312,1084.494;Float;False;True;-1;2;;0;0;Standard;DBK/WoodFloor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;29;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;203;0;2;2
WireConnection;191;0;178;2
WireConnection;204;0;203;0
WireConnection;4;0;191;0
WireConnection;4;1;3;0
WireConnection;5;0;4;0
WireConnection;5;1;204;0
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;10;0;178;3
WireConnection;10;1;9;0
WireConnection;10;2;8;0
WireConnection;11;0;10;0
WireConnection;256;0;11;0
WireConnection;258;0;256;0
WireConnection;257;0;255;0
WireConnection;257;1;256;0
WireConnection;259;0;258;0
WireConnection;259;1;257;0
WireConnection;261;1;259;0
WireConnection;338;1;322;0
WireConnection;338;0;337;0
WireConnection;324;0;323;0
WireConnection;324;1;338;0
WireConnection;264;0;261;0
WireConnection;325;0;324;0
WireConnection;328;0;326;0
WireConnection;328;1;324;0
WireConnection;262;0;264;0
WireConnection;205;0;178;2
WireConnection;332;0;329;0
WireConnection;332;1;328;0
WireConnection;327;0;326;0
WireConnection;327;1;325;0
WireConnection;272;0;268;2
WireConnection;206;0;205;0
WireConnection;234;0;268;1
WireConnection;331;0;324;0
WireConnection;267;0;178;1
WireConnection;309;0;332;0
WireConnection;231;0;234;0
WireConnection;231;1;39;0
WireConnection;330;0;329;0
WireConnection;330;1;327;0
WireConnection;270;0;272;0
WireConnection;269;0;268;4
WireConnection;317;0;315;0
WireConnection;317;1;318;0
WireConnection;201;0;2;1
WireConnection;201;1;206;0
WireConnection;271;0;270;0
WireConnection;27;0;267;0
WireConnection;27;1;29;0
WireConnection;26;0;201;0
WireConnection;319;0;269;0
WireConnection;319;1;317;0
WireConnection;233;0;231;0
WireConnection;333;0;326;0
WireConnection;333;1;331;0
WireConnection;307;0;330;0
WireConnection;109;0;178;2
WireConnection;242;0;271;0
WireConnection;242;1;108;0
WireConnection;25;1;26;0
WireConnection;25;3;27;0
WireConnection;25;4;23;0
WireConnection;25;5;24;0
WireConnection;123;0;178;1
WireConnection;159;0;319;0
WireConnection;159;1;158;0
WireConnection;336;0;329;0
WireConnection;336;1;333;0
WireConnection;69;0;268;3
WireConnection;69;1;70;0
WireConnection;33;0;312;0
WireConnection;33;1;233;0
WireConnection;241;0;242;0
WireConnection;241;1;33;0
WireConnection;162;0;159;0
WireConnection;162;1;313;0
WireConnection;68;0;313;0
WireConnection;68;1;69;0
WireConnection;74;0;25;0
WireConnection;265;0;12;0
WireConnection;265;1;266;0
WireConnection;311;0;336;0
WireConnection;196;0;124;0
WireConnection;196;1;197;0
WireConnection;163;0;68;0
WireConnection;163;1;162;0
WireConnection;193;0;33;0
WireConnection;193;1;241;0
WireConnection;275;0;279;0
WireConnection;314;0;265;0
WireConnection;254;0;111;0
WireConnection;100;0;79;0
WireConnection;100;1;149;0
WireConnection;114;0;116;0
WireConnection;114;1;85;0
WireConnection;14;0;193;0
WireConnection;14;1;163;0
WireConnection;14;2;314;0
WireConnection;129;0;196;0
WireConnection;154;0;75;0
WireConnection;154;1;153;0
WireConnection;42;0;320;0
WireConnection;42;1;275;1
WireConnection;253;0;254;0
WireConnection;115;0;114;0
WireConnection;20;5;284;0
WireConnection;101;0;100;0
WireConnection;19;5;282;0
WireConnection;110;0;77;0
WireConnection;110;1;129;0
WireConnection;110;2;253;0
WireConnection;30;0;14;0
WireConnection;30;1;42;0
WireConnection;30;2;154;0
WireConnection;215;0;279;0
WireConnection;102;0;110;0
WireConnection;102;1;101;0
WireConnection;102;2;115;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;91;0
WireConnection;103;0;30;0
WireConnection;117;0;102;0
WireConnection;92;0;21;0
WireConnection;276;0;215;2
WireConnection;339;0;104;0
WireConnection;339;1;340;0
WireConnection;208;1;214;0
WireConnection;208;2;209;0
WireConnection;214;0;211;0
WireConnection;214;1;21;0
WireConnection;211;5;285;0
WireConnection;119;0;268;3
WireConnection;0;0;339;0
WireConnection;0;1;93;0
WireConnection;0;4;118;0
WireConnection;0;10;277;0
ASEEND*/
//CHKSM=C88AED6496FE069AC1D63E781EAF62395589E863