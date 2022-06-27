// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DBK/Carpet"
{
	Properties
	{
		[PerRendererData]_ColorSelect("ColorSelect", Int) = 0
		_Brightness("Brightness", Range( 0 , 1)) = 0
		_MainTex("Color Theme", 2D) = "white" {}
		_Darkness("Darkness", Range( 0 , 1)) = 0
		_Edges("Edges", Range( 0.05 , 1)) = 0
		_Threshold("Threshold", Range( 0 , 1)) = 0
		_RGBAMaskB("RGBA Mask B", 2D) = "white" {}
		_RGBAMaskA("RGBA Mask A", 2D) = "white" {}
		_DirtOpacity("Dirt Opacity", Range( 0 , 1)) = 0
		_DirtSmooth("Dirt Smooth", Range( 0 , 2)) = 0
		_DirtMultiplier("Dirt Multiplier", Range( 0 , 2)) = 0
		_DirtRange("Dirt Range", Range( 0 , 1)) = 0
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
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 4.0
		#pragma shader_feature _USECUSTOMCOLOR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv4_texcoord4;
		};

		uniform sampler2D _MainTex;
		uniform int _ColorSelect;
		uniform int _CustomColor;
		uniform sampler2D _RGBAMaskA;
		uniform float4 _RGBAMaskA_ST;
		uniform float _Brightness;
		uniform float _Darkness;
		uniform float _Edges;
		uniform sampler2D _RGBAMaskB;
		uniform float4 _RGBAMaskB_ST;
		uniform float _DirtMultiplier;
		uniform float _DirtRange;
		uniform float _DirtSmooth;
		uniform float _DirtOpacity;
		uniform float4 _Color;
		uniform float _Threshold;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half2 _ColorsNumber = half2(0,-0.1);
			#ifdef _USECUSTOMCOLOR_ON
				float staticSwitch168 = (float)_CustomColor;
			#else
				float staticSwitch168 = (float)_ColorSelect;
			#endif
			float2 temp_output_154_0 = ( half2( 0.015625,0 ) * staticSwitch168 );
			float2 uv_TexCoord158 = i.uv_texcoord * _ColorsNumber + temp_output_154_0;
			float4 PrimaryColor146 = tex2D( _MainTex, uv_TexCoord158 );
			float2 uv_RGBAMaskA = i.uv_texcoord * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode115 = tex2D( _RGBAMaskA, uv_RGBAMaskA );
			float2 appendResult155 = (float2(temp_output_154_0.x , 0.5));
			float2 uv_TexCoord157 = i.uv_texcoord * _ColorsNumber + appendResult155;
			float4 UndersideColorUV3145 = tex2D( _MainTex, uv_TexCoord157 );
			float2 uv4_RGBAMaskA = i.uv4_texcoord4 * _RGBAMaskA_ST.xy + _RGBAMaskA_ST.zw;
			float4 tex2DNode39 = tex2D( _RGBAMaskA, uv4_RGBAMaskA );
			float3 temp_cast_3 = (pow( ( 1.0 - tex2DNode39.b ) , _Edges )).xxx;
			float3 desaturateInitialColor43 = temp_cast_3;
			float desaturateDot43 = dot( desaturateInitialColor43, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar43 = lerp( desaturateInitialColor43, desaturateDot43.xxx, 1.0 );
			float3 CutoutEdges44 = desaturateVar43;
			float4 lerpResult47 = lerp( ( ( PrimaryColor146 * tex2DNode115.r ) * ( i.vertexColor.g + _Brightness ) * _Darkness ) , ( UndersideColorUV3145 * tex2DNode115.a ) , float4( ( ( ( 1.0 - i.vertexColor.b ) * CutoutEdges44 ) + i.vertexColor.b ) , 0.0 ));
			float2 uv_RGBAMaskB = i.uv_texcoord * _RGBAMaskB_ST.xy + _RGBAMaskB_ST.zw;
			float4 tex2DNode102 = tex2D( _RGBAMaskB, uv_RGBAMaskB );
			float CarpetMaskAlpha108 = tex2DNode102.a;
			float2 appendResult161 = (float2(temp_output_154_0.x , 0.1));
			float2 uv_TexCoord163 = i.uv_texcoord * _ColorsNumber + appendResult161;
			float4 DirtColorUV3147 = tex2D( _MainTex, uv_TexCoord163 );
			float CarpetMaskBlue106 = tex2DNode102.b;
			float3 temp_cast_6 = (( tex2DNode102.g * _DirtMultiplier )).xxx;
			float VertexRed124 = i.vertexColor.r;
			float3 temp_cast_7 = (( 1.0 - ( VertexRed124 * tex2DNode102.r ) )).xxx;
			float DirtHeight17 = saturate( ( 1.0 - ( ( distance( temp_cast_6 , temp_cast_7 ) - _DirtRange ) / max( _DirtSmooth , 1E-05 ) ) ) );
			float4 lerpResult31 = lerp( lerpResult47 , ( ( CarpetMaskAlpha108 * DirtColorUV3147 ) * i.vertexColor.g * ( CarpetMaskBlue106 + tex2DNode115.a ) ) , ( DirtHeight17 * _DirtOpacity ));
			float4 Albedo99 = lerpResult31;
			o.Albedo = ( Albedo99 * _Color ).rgb;
			o.Alpha = 1;
			clip( tex2DNode115.a - ( i.vertexColor.g * _Threshold ));
			float OpactiyMask103 = ( 1.0 * tex2DNode39.b );
			clip( OpactiyMask103 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
2560;133;1920;1132;-2020.158;1560.929;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;123;-1911.083,-1806.42;Inherit;False;4081.375;1257.844;Comment;30;48;83;82;98;96;79;109;107;75;90;33;89;30;27;111;28;47;29;31;99;10;116;115;78;124;149;150;151;169;170;Color;0.1824493,0.9433962,0.7611771,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;116;-1917.046,-946.8057;Inherit;True;Property;_RGBAMaskA;RGBA Mask A;7;0;Create;True;0;0;0;False;0;False;42a1b663743ff5248a4855153721288b;42a1b663743ff5248a4855153721288b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;152;-1898.772,-2799.62;Inherit;False;2080.08;813.5428;Comment;16;166;163;162;161;160;159;158;157;156;155;154;153;128;168;147;146;Color Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;118;-1490.074,-106.2381;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.IntNode;167;-1918.424,-2280.001;Inherit;False;Property;_CustomColor;Custom Color;14;0;Create;True;0;0;0;False;0;False;0;18;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;128;-1878.462,-2434.449;Inherit;False;Property;_ColorSelect;ColorSelect;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.WireNode;119;-1441.84,-33.79586;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;114;-738.0974,-114.3639;Inherit;False;1727.915;583.6483;Comment;11;5;103;38;44;43;42;41;40;39;11;117;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;153;-1766.979,-2705.481;Half;False;Constant;_NumberOfColors;NumberOfColors;19;0;Create;True;0;0;0;False;1;;False;0.015625,0;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VertexColorNode;10;-701.6516,-726.442;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;168;-1679.09,-2326.511;Inherit;False;Property;_UseCustomColor;Use Custom Color;13;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-692.308,-34.89026;Inherit;True;Property;_RGBAMaskA1;RGBA Mask A 1;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;40;-24.04526,306.9113;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-149.3056,399.3712;Inherit;False;Property;_Edges;Edges;4;0;Create;True;0;0;0;False;0;False;0;0.4027601;0.05;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;156;-1392.985,-2778.6;Half;False;Constant;_ColorsNumber;ColorsNumber;19;0;Create;True;0;0;0;False;1;;False;0,-0.1;0.125,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-1443.682,-2586.288;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-434.0754,-719.7806;Inherit;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-752.3472,617.7034;Inherit;False;1819.029;724.7414;Comment;12;102;21;16;15;68;17;18;20;19;106;108;125;Dirt;0.745283,0.130073,0.130073,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;-959.0925,-2726.501;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;-733.3472,845.5596;Inherit;True;Property;_RGBAMaskB;RGBA Mask B;6;0;Create;True;0;0;0;False;0;False;-1;94996953678af9343a0fec222ae81fac;94996953678af9343a0fec222ae81fac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;159;-968.4711,-2534.782;Inherit;True;Property;_MainTex;Color Theme;2;0;Create;False;0;0;0;False;0;False;400a9a0515468594997165b1aa51f32d;400a9a0515468594997165b1aa51f32d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;155;-1212.646,-2289.149;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;42;172.0317,270.7616;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;-1231.149,-2099.78;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-556.1436,722.4591;Inherit;False;124;VertexRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;157;-927.2604,-2294.301;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;162;-533.9819,-2726.396;Inherit;True;Property;_PrimaryColor;PrimaryColor;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-292.9341,1056.275;Inherit;False;Property;_DirtMultiplier;Dirt Multiplier;10;0;Create;True;0;0;0;False;0;False;0;0.682666;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-949.3947,-2130.989;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;43;469.55,267.0242;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-219.0431,766.0918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-516.5047,-2211.53;Inherit;True;Property;_ThirdColor;ThirdColor;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-146.5808,-2662.011;Inherit;False;PrimaryColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;15;14.84229,768.5192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;20.88001,1062.146;Inherit;False;Property;_DirtRange;Dirt Range;11;0;Create;True;0;0;0;False;0;False;0;0.7665054;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;160;-535.8334,-2495.294;Inherit;True;Property;_SecondColor;SecondColor;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;663.429,254.7555;Inherit;False;CutoutEdges;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;30.35411,1183.446;Inherit;False;Property;_DirtSmooth;Dirt Smooth;9;0;Create;True;0;0;0;False;0;False;0;0.4889936;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;170;68.22933,-644.4347;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;10.28309,935.6843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;171;-366.6442,-960.5884;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-517.2686,-1179.979;Inherit;False;146;PrimaryColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-351.8756,981.4565;Inherit;False;CarpetMaskBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-144.9138,-2471.735;Inherit;False;UndersideColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-319.7043,1155.393;Inherit;False;CarpetMaskAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-209.8864,-893.0706;Inherit;False;Property;_Brightness;Brightness;1;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-99.15252,-2211.43;Inherit;False;DirtColorUV3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;83;187.6151,-836.1008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;16;364.5703,829.0408;Inherit;False;Color Mask;-1;;41;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.17;False;5;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;-1451.449,-950.4766;Inherit;True;Property;_AlphaMask;AlphaMask;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;48;242.6628,-964.7576;Inherit;False;44;CutoutEdges;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-732.0571,-1756.42;Inherit;False;108;CarpetMaskAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-5.159808,-1072.568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;479.413,-913.5279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1039.295,-1476.477;Inherit;False;106;CarpetMaskBlue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-182.2426,-1186.453;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;120;-1154.501,-240.9464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;823.6824,823.7388;Inherit;False;DirtHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;169;594.5878,-650.0425;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-206.7021,-812.053;Inherit;False;Property;_Darkness;Darkness;3;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;287.7389,-1368.689;Inherit;False;145;UndersideColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-723.6509,-1636.492;Inherit;False;147;DirtColorUV3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-648.7392,-1478.227;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;1267.344,-1153.77;Inherit;False;Property;_DirtOpacity;Dirt Opacity;8;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-376.2786,-1611.228;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;617.8804,-1331.304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;1314.775,-1277.461;Inherit;False;17;DirtHeight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;696.8901,-899.5806;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;182.275,-1160.388;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-363.1255,-54.98087;Inherit;False;Property;_Threshold;Threshold;5;0;Create;True;0;0;0;False;0;False;0;0.8127356;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;122;-1038.399,-204.4574;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;956.4682,-1175.821;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-167.687,-1510.976;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;1572.745,-1272.069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2.701184,-97.5304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.78;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;121;118.0769,-198.9198;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;117;460.0205,31.84945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;1462.443,-1529.429;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClipNode;5;215.2098,-95.59806;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;546.5501,-103.8966;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;1883.93,-1555.846;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;756.3527,-75.40219;Inherit;False;OpactiyMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;2633.395,-795.1005;Inherit;False;99;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;173;2595.698,-1068.76;Inherit;False;Property;_Color;Color;15;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;2847.618,-815.098;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;2705.671,-507.4037;Inherit;False;103;OpactiyMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2985.349,-773.6865;Float;False;True;-1;4;;0;0;Standard;DBK/Carpet;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;12;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;118;0;116;0
WireConnection;119;0;118;0
WireConnection;168;1;128;0
WireConnection;168;0;167;0
WireConnection;39;0;119;0
WireConnection;40;0;39;3
WireConnection;154;0;153;0
WireConnection;154;1;168;0
WireConnection;124;0;10;1
WireConnection;158;0;156;0
WireConnection;158;1;154;0
WireConnection;155;0;154;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;161;0;154;0
WireConnection;157;0;156;0
WireConnection;157;1;155;0
WireConnection;162;0;159;0
WireConnection;162;1;158;0
WireConnection;163;0;156;0
WireConnection;163;1;161;0
WireConnection;43;0;42;0
WireConnection;68;0;125;0
WireConnection;68;1;102;1
WireConnection;166;0;159;0
WireConnection;166;1;163;0
WireConnection;146;0;162;0
WireConnection;15;0;68;0
WireConnection;160;0;159;0
WireConnection;160;1;157;0
WireConnection;44;0;43;0
WireConnection;170;0;10;3
WireConnection;21;0;102;2
WireConnection;21;1;20;0
WireConnection;171;0;10;2
WireConnection;106;0;102;3
WireConnection;145;0;160;0
WireConnection;108;0;102;4
WireConnection;147;0;166;0
WireConnection;83;0;170;0
WireConnection;16;1;15;0
WireConnection;16;3;21;0
WireConnection;16;4;18;0
WireConnection;16;5;19;0
WireConnection;115;0;116;0
WireConnection;79;0;171;0
WireConnection;79;1;78;0
WireConnection;82;0;83;0
WireConnection;82;1;48;0
WireConnection;98;0;149;0
WireConnection;98;1;115;1
WireConnection;120;0;115;4
WireConnection;17;0;16;0
WireConnection;169;0;10;3
WireConnection;33;0;107;0
WireConnection;33;1;115;4
WireConnection;111;0;109;0
WireConnection;111;1;151;0
WireConnection;90;0;150;0
WireConnection;90;1;115;4
WireConnection;89;0;82;0
WireConnection;89;1;169;0
WireConnection;75;0;98;0
WireConnection;75;1;79;0
WireConnection;75;2;96;0
WireConnection;122;0;120;0
WireConnection;47;0;75;0
WireConnection;47;1;90;0
WireConnection;47;2;89;0
WireConnection;28;0;111;0
WireConnection;28;1;10;2
WireConnection;28;2;33;0
WireConnection;29;0;30;0
WireConnection;29;1;27;0
WireConnection;11;0;10;2
WireConnection;11;1;7;0
WireConnection;121;0;122;0
WireConnection;117;0;39;3
WireConnection;31;0;47;0
WireConnection;31;1;28;0
WireConnection;31;2;29;0
WireConnection;5;1;121;0
WireConnection;5;2;11;0
WireConnection;38;0;5;0
WireConnection;38;1;117;0
WireConnection;99;0;31;0
WireConnection;103;0;38;0
WireConnection;172;0;100;0
WireConnection;172;1;173;0
WireConnection;0;0;172;0
WireConnection;0;10;104;0
ASEEND*/
//CHKSM=A22D1D9F2F2E9D4AB2167EE9AB57FE6D68FB89B0