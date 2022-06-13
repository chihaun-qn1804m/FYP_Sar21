﻿//===============================
//Copyright Livenda Labs 2021
//VRSI Creation Studio
//===============================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEditor;
using UnityEngine.XR;

[ExecuteInEditMode]
public class VRSI_RenderTool_MultiView : MonoBehaviour
{
    public enum VRSI_Resolution
    {   
        VeryLow_256,
        Low_512,
        Medium_1024,
        High_2048,
        VeryHigh_4096
    }

    public VRSI_Resolution vrsiResolution = VRSI_Resolution.High_2048;
    public int vrsiRenderSize = 1024;

    public VRSI_Resolution vrsiResolutionNormal = VRSI_Resolution.High_2048;
    public int vrsiRenderSizeNormal = 2048;

    private Material makeAlpha;

    private Camera renderCam;
    Camera mainCam;
    [Range(0.0f, 0.15f)]
    public float seperation = 0.033f;
    public AnimationCurve seperationCurve;
    [Range(0.0f,10.0f)]
    public float focalPointHeight = 2.43f;
    [Range(-10.0f, 10.0f)]
    public float focalPointZvalue = 0.0f;
    [Range(0.0f, 10.0f)]
    public float ObserverHeight = 1.67f;
    [Range(0.001f, 20.0f)]
    public float ObserverDistance = 4.42f;
    [Space(5)]
    [Range(0, 360.0f)]
    public float OrientationDegrees = 0.0f;

    public bool focalPlaneVisible = false;
    public bool renderNormals = true;
    public bool AlphaToCoverage = true;

    public int MultiViewPointCount = 8;

    RenderTexture rtL;
    RenderTexture rtR;
    public string folderName;
    public string vrsiName;
    private Transform focalpoint;
    private MeshRenderer refFloor;
    private MeshRenderer refPerson;
    private MeshRenderer refBillboardQuad;
    
    Texture2D stereoRT;
    Texture2D stereoRTnorm;
    RenderTexture rtLnorm;
    RenderTexture rtRnorm;
    
    public bool AllowPostProcess = false;
    GameObject camGO;
    bool inVRmode = false;

    public Transform refDebugFocalPlane;
    public GameObject ObjectsToRenderParent;


    public void Tick()
    {     
        
        if (mainCam != null && !inVRmode)
        {
           if(focalpoint !=null)  focalpoint.transform.localPosition = new Vector3(0, focalPointHeight, focalPointZvalue);

            mainCam.transform.localPosition = new Vector3(0, ObserverHeight, -ObserverDistance);
            mainCam.transform.LookAt(focalpoint);
            mainCam.transform.parent.eulerAngles = new Vector3(0, OrientationDegrees, 0);

            if(refDebugFocalPlane != null)
            refDebugFocalPlane.position = new Vector3(focalpoint.position.x, 0, focalpoint.position.z);
        }
        
    }

    private void Awake()
    {  
        mainCam = Camera.main;
        if (makeAlpha == null) makeAlpha = Resources.Load<Material>("Materials/makeAlpha"); 
        focalpoint = GameObject.Find("vrsiFocalPoint").transform;
        refFloor   = GameObject.Find("vrsiReferenceFloor").GetComponent<MeshRenderer>();
        refPerson  = GameObject.Find("vrsiReferencePerson").GetComponent<MeshRenderer>();
        refBillboardQuad = GameObject.Find("vrsiReferenceTestQuad").GetComponent<MeshRenderer>();
        refDebugFocalPlane = GameObject.Find("vrsiFocalPlaneDebug").transform; 
        refBillboardQuad.enabled = false;
        ObjectsToRenderParent = GameObject.Find("OBJECTS_TO_RENDER");

        AllowPostProcess = true;
    }


    private void OnEnable()
    {
        if (mainCam == null) mainCam = Camera.main;       

        if (camGO == null)
        {
            camGO = new GameObject("vrsiRenderCam");            
            renderCam = camGO.AddComponent<Camera>();
            renderCam.CopyFrom(mainCam);
            renderCam.depth = -2;
            camGO.hideFlags = HideFlags.HideAndDontSave;
        }

        AllowPostProcess = true;        

        if(makeAlpha == null) makeAlpha = Resources.Load<Material>("Materials/makeAlpha");

        focalpoint = GameObject.Find("vrsiFocalPoint").transform;
        refFloor = GameObject.Find("vrsiReferenceFloor").GetComponent<MeshRenderer>();
        refPerson = GameObject.Find("vrsiReferencePerson").GetComponent<MeshRenderer>();
        refBillboardQuad = GameObject.Find("vrsiReferenceTestQuad").GetComponent<MeshRenderer>();
        ObjectsToRenderParent = GameObject.Find("OBJECTS_TO_RENDER");

        if (refDebugFocalPlane ==null)
        refDebugFocalPlane = GameObject.Find("vrsiFocalPlaneDebug").transform;

        refBillboardQuad.enabled = false;

        //======================

        if (ObjectsToRenderParent != null)
        {
            Renderer[] renderChildren = ObjectsToRenderParent.GetComponentsInChildren<Renderer>();

            Bounds bounds = new Bounds();

            foreach (var r in renderChildren)
            {
                bounds.Encapsulate(r.bounds);
            }

            DrawBounds(bounds, 10);

            if (renderChildren.Length > 0)
            {
                //Resize The Reference Billboard
                refBillboardQuad.transform.localScale = new Vector3(bounds.max.y * 2.0f, bounds.max.y * 2.0f, bounds.max.y * 2.0f);
                refBillboardQuad.transform.localPosition = new Vector3(bounds.max.x * 2 * 1.1f, 0, focalPointZvalue);
            }
        }
        //======================
    }

    void DrawBounds(Bounds b, float delay = 0)
    {
        // bottom
        var p1 = new Vector3(b.min.x, b.min.y, b.min.z);
        var p2 = new Vector3(b.max.x, b.min.y, b.min.z);
        var p3 = new Vector3(b.max.x, b.min.y, b.max.z);
        var p4 = new Vector3(b.min.x, b.min.y, b.max.z);

        Debug.DrawLine(p1, p2, Color.blue, delay);
        Debug.DrawLine(p2, p3, Color.red, delay);
        Debug.DrawLine(p3, p4, Color.yellow, delay);
        Debug.DrawLine(p4, p1, Color.magenta, delay);

        // top
        var p5 = new Vector3(b.min.x, b.max.y, b.min.z);
        var p6 = new Vector3(b.max.x, b.max.y, b.min.z);
        var p7 = new Vector3(b.max.x, b.max.y, b.max.z);
        var p8 = new Vector3(b.min.x, b.max.y, b.max.z);

        Debug.DrawLine(p5, p6, Color.blue, delay);
        Debug.DrawLine(p6, p7, Color.red, delay);
        Debug.DrawLine(p7, p8, Color.yellow, delay);
        Debug.DrawLine(p8, p5, Color.magenta, delay);

        // sides
        Debug.DrawLine(p1, p5, Color.white, delay);
        Debug.DrawLine(p2, p6, Color.gray, delay);
        Debug.DrawLine(p3, p7, Color.green, delay);
        Debug.DrawLine(p4, p8, Color.cyan, delay);
    }


    private void OnDisable()
    {        
       if(camGO != null) DestroyImmediate(camGO);
    }

    private void OnDestroy()
    {       
        if (camGO != null) DestroyImmediate(camGO);
    }

    public void enableVRpreview()
    {
        StartCoroutine(startVRPreview());
    }

    IEnumerator startVRPreview()
    {
        inVRmode = true;
        refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = false;
        yield return new WaitForSeconds(0.5f);
        mainCam.transform.localEulerAngles = Vector3.zero;

        Transform camParent = mainCam.transform.parent;

        mainCam.transform.parent = null;
        camParent.transform.position = mainCam.transform.position;
        mainCam.transform.parent = camParent;
        mainCam.transform.localEulerAngles = Vector3.zero;
        //Center The Camera Between render objects and billboardQuad
        camParent.transform.position = new Vector3(refBillboardQuad.transform.position.x / 1.9f, camParent.transform.position.y, camParent.transform.position.z*1.4f);

        refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = false;
        refPerson.enabled = false;

        yield return new WaitForSeconds(0.5f);

        XRSettings.LoadDeviceByName(loadedvrDeviceName);
        yield return null;
        XRSettings.enabled = true;

        refBillboardQuad.enabled = true;
        //Debug.Log(XRSettings.loadedDeviceName);
    }

    public void stopVRpreview()
    {
        StartCoroutine(stopPreview());
    }

    IEnumerator stopPreview()
    {
        XRSettings.LoadDeviceByName("");
        yield return null;
        XRSettings.enabled = false;

        refBillboardQuad.enabled = false;
        yield return new WaitForSeconds(0.5f);

        Transform camParent = mainCam.transform.parent;
        mainCam.transform.parent = null;
        camParent.transform.position = Vector3.zero;
        camParent.transform.rotation = Quaternion.identity;
        mainCam.transform.parent = camParent;
        yield return new WaitForSeconds(0.5f);

        inVRmode = false;
        refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = focalPlaneVisible;
       
    }

    public bool getInVRMode()
    {
        return inVRmode;
    }

    string loadedvrDeviceName = "Oculus";

    void Start()
    {
        //XRSettings.LoadDeviceByName("");
        loadedvrDeviceName = XRSettings.loadedDeviceName;
        Debug.Log(loadedvrDeviceName);
        XRSettings.LoadDeviceByName("");
        XRSettings.enabled = false;
        AllowPostProcess = false;
        //Debug.Log("StartCalled");         
    }


    static RenderTexture GetTemporaryRT(RenderTexture texture)
    {
        var result = RenderTexture.GetTemporary(texture.width, texture.height);       

        return result;
    }

    RenderTexture rt_White;

    public void CreateVRSI()
    {
#if UNITY_EDITOR

        //Debug.Log("CreateVRSI");

        Renderer[] renderChildren = ObjectsToRenderParent.GetComponentsInChildren<Renderer>();

        Bounds bounds = new Bounds();

        foreach (var r in renderChildren)
        {
            bounds.Encapsulate(r.bounds);
        }
                
        DrawBounds(bounds, 5);

        if(renderChildren.Length < 1)
        {

            EditorUtility.DisplayDialog("OBJECTS_TO_RENDER Is Empty", "Add Objects To TurnTable As A Child Of OBJECTS_TO_RENDER in Hierarchy", "Ok");
            return;
        }
                
        //Resize The Reference Billboard
        refBillboardQuad.transform.localScale = new Vector3(bounds.max.y * 2.0f, bounds.max.y * 2.0f, bounds.max.y * 2.0f);
        refBillboardQuad.transform.localPosition = new Vector3(bounds.max.x * 2 * 1.1f, 0, focalPointZvalue);


        if (string.IsNullOrEmpty(vrsiName))
        {
            EditorUtility.DisplayDialog("VRSI Name Is Empty", "Please enter a name the generated VRSI", "Ok");
            return;
        }

        if(EditorUtility.DisplayDialog("Confirm VRSI Render", "About To Generate VRSI named "+vrsiName, "Ok", "Cancel"))
        {
            //Ok
        }
        else
        {
            return;
        }

        if (string.IsNullOrEmpty(folderName))
        {
            EditorUtility.DisplayDialog("Folder Name Is Empty", "Please enter a folder name for the generated VRSI", "Ok");
            return;
        }

        string directoryPath = Application.dataPath + "/VRSI/" + folderName + "/" + vrsiName;

        if (!Directory.Exists(directoryPath))
        {
            //if it doesn't, create it
            Directory.CreateDirectory(directoryPath);
        }

        refFloor.enabled = false;
        refPerson.enabled = false;
        focalpoint.GetChild(0).GetComponent<MeshRenderer>().enabled = false;
        refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = false;       


        int size = vrsiRenderSize;

        float numLevels = 1 + Mathf.Floor(Mathf.Log(Mathf.Max(size * 2, size), 2));
       // Debug.Log(numLevels);

        renderCam.CopyFrom(mainCam);

        Shader vrsiNormShader = Shader.Find("Hidden/vrsiNormals");

        Shader paddingShader = Shader.Find("Hidden/Edge Padding/Simple");

        Shader alphaTransferShader = Shader.Find("Hidden/VRSI/AlphaTransfer");

        Shader colldiffAlphaMakerShader = Shader.Find("Hidden/VRSI/colldiffAlphaMakerShader");

        var padMaterial = new Material(paddingShader);
        padMaterial.hideFlags = HideFlags.HideAndDontSave;

        var alphaTransferMaterial = new Material(alphaTransferShader);
        alphaTransferMaterial.hideFlags = HideFlags.HideAndDontSave;

        var coldiffAlphaMakerMat = new Material(colldiffAlphaMakerShader);
        coldiffAlphaMakerMat.hideFlags = HideFlags.HideAndDontSave;

        int ViewCount = MultiViewPointCount;
        float rotStep = 360.0f / ViewCount;

        int i = 0;
        //for (int i = 0; i < 1; i++)
        for(int j=0; j<ViewCount; j++)
        {

            ObjectsToRenderParent.transform.localEulerAngles = new Vector3(0, j * rotStep, 0);//.Rotate(Vector3.up, j * rotStep);

            int renderSize = size / ((int)Mathf.Pow(2, i));
            if (renderSize < 1) renderSize = 1;

            //Debug.Log("image" + i + " : " + renderSize);

            //Seperation Falloff
            float percent = Mathf.Clamp01((float)i / (float)(numLevels - 1));

            float sepDelta = Mathf.Clamp01(seperationCurve.Evaluate(percent));

            float camSeperation = Mathf.Lerp(seperation, 0.0f, sepDelta);

            rtL = new RenderTexture(renderSize, renderSize, 24, RenderTextureFormat.ARGB32);
            rtR = new RenderTexture(renderSize, renderSize, 24, RenderTextureFormat.ARGB32);

            if(i == 0)
                stereoRT = new Texture2D(renderSize * 2, renderSize, TextureFormat.ARGB32, true);
            else
                stereoRT = new Texture2D(renderSize * 2, renderSize, TextureFormat.ARGB32, false);

            

            if (renderNormals)
            {
                rtLnorm = new RenderTexture(renderSize, renderSize, 24, RenderTextureFormat.ARGB32);
                rtRnorm = new RenderTexture(renderSize, renderSize, 24, RenderTextureFormat.ARGB32);
                stereoRTnorm = new Texture2D(renderSize * 2, renderSize, TextureFormat.ARGB32, true);
            }
           
            //================================================================
            //METHOD 2: Slightly slower more reliable
            //================================================================
            rt_White = new RenderTexture(renderSize, renderSize, 24, RenderTextureFormat.ARGB32);
            RenderTexture rttemp = new RenderTexture(renderSize, renderSize, 24, RenderTextureFormat.ARGB32);

            //LEFT
            renderCam.clearFlags = CameraClearFlags.SolidColor;
            renderCam.backgroundColor = Color.black;

            renderCam.transform.position = mainCam.transform.position + mainCam.transform.right * camSeperation;
            renderCam.transform.LookAt(focalpoint);

            renderCam.targetTexture = rtL;
            renderCam.Render();

            renderCam.backgroundColor = Color.white;
            renderCam.targetTexture = rt_White;
            renderCam.Render();

            coldiffAlphaMakerMat.SetTexture("_WhiteBackTex", rt_White);
            Graphics.Blit(rtL, rttemp, coldiffAlphaMakerMat);
            Graphics.Blit(rttemp, rtL);

            renderCam.clearFlags = CameraClearFlags.Depth;
            // Simple: use a clear background
            renderCam.backgroundColor = Color.clear;

            Shader.SetGlobalTexture("_vrsiRTtempTex", rtL);

            if (renderNormals)
            {
                renderCam.targetTexture = rtLnorm;
                renderCam.RenderWithShader(vrsiNormShader, "");
            }

            //RIGHT
            renderCam.clearFlags = CameraClearFlags.SolidColor;
            renderCam.backgroundColor = Color.black;

            renderCam.transform.position = mainCam.transform.position - mainCam.transform.right * camSeperation;
            renderCam.transform.LookAt(focalpoint);

            renderCam.targetTexture = rtR;
            renderCam.Render();

            renderCam.backgroundColor = Color.white;
            renderCam.targetTexture = rt_White;
            renderCam.Render();

            coldiffAlphaMakerMat.SetTexture("_WhiteBackTex", rt_White);
            Graphics.Blit(rtR, rttemp, coldiffAlphaMakerMat);
            Graphics.Blit(rttemp, rtR);

            renderCam.clearFlags = CameraClearFlags.Depth;
            // Simple: use a clear background
            renderCam.backgroundColor = Color.clear;

            Shader.SetGlobalTexture("_vrsiRTtempTex", rtR);

            if (renderNormals)
            {
                renderCam.targetTexture = rtRnorm;
                renderCam.RenderWithShader(vrsiNormShader, "");
            }

                        
            //=========================================
            //Padding
            //=========================================

            padMaterial.shader = paddingShader;
            padMaterial.SetVector("_Delta", new Vector4(1f / rtL.width, 1f / rtL.height, 0, 0));

            var paddingInterations = Mathf.Min(Mathf.Max(rtL.width, rtL.height));
            

            //LEFT
            var tr1 = GetTemporaryRT(rtL);
            Graphics.Blit(rtL, tr1);
           
            for (var p = 0; p < paddingInterations; p++)
            {
                var tr2 = GetTemporaryRT(rtL);
                Graphics.Blit(tr1, tr2, padMaterial);
                RenderTexture.ReleaseTemporary(tr1);
                tr1 = tr2;                
            }

            var trL = GetTemporaryRT(rtL);
            alphaTransferMaterial.SetTexture("_AlphaTex", rtL);
            Graphics.Blit(tr1, trL, alphaTransferMaterial);
            RenderTexture.ReleaseTemporary(tr1);

            //RIGHT
            tr1 = GetTemporaryRT(rtR);
            Graphics.Blit(rtR, tr1);

            for (var p = 0; p < paddingInterations; p++)
            {
                var tr2 = GetTemporaryRT(rtR);
                Graphics.Blit(tr1, tr2, padMaterial);
                RenderTexture.ReleaseTemporary(tr1);
                tr1 = tr2;
            }

            var trR = GetTemporaryRT(rtR);
            alphaTransferMaterial.SetTexture("_AlphaTex", rtR);
            Graphics.Blit(tr1, trR, alphaTransferMaterial);
            RenderTexture.ReleaseTemporary(tr1);

            //=========================================           
            
            RenderTexture.active = trL;
            stereoRT.ReadPixels(new Rect(0, 0, renderSize, renderSize), 0, 0, false);
            stereoRT.Apply();           

            RenderTexture.active = trR;
            stereoRT.ReadPixels(new Rect(0, 0, renderSize, renderSize), renderSize, 0, false);
            stereoRT.Apply();
            RenderTexture.active = null;

            RenderTexture.ReleaseTemporary(trL);
            RenderTexture.ReleaseTemporary(trR);

            byte[] bytes = stereoRT.EncodeToPNG();            

            if (i == 0)
                File.WriteAllBytes(Application.dataPath + "/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName+j.ToString() + ".png", bytes);
            else
                File.WriteAllBytes(Application.dataPath + "/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + ".mip" + i.ToString() + ".png", bytes);


            if (renderNormals)
            {
                //PADDING              
                //LEFT
                tr1 = GetTemporaryRT(rtLnorm);
                Graphics.Blit(rtLnorm, tr1);

                for (var p = 0; p < paddingInterations; p++)
                {
                    var tr2 = GetTemporaryRT(rtLnorm);
                    Graphics.Blit(tr1, tr2, padMaterial);
                    RenderTexture.ReleaseTemporary(tr1);
                    tr1 = tr2;
                }

                trL = GetTemporaryRT(rtLnorm);
                alphaTransferMaterial.SetTexture("_AlphaTex", rtLnorm);
                Graphics.Blit(tr1, trL, alphaTransferMaterial);
                RenderTexture.ReleaseTemporary(tr1);

                //PADDING
                //RIGHT
                tr1 = GetTemporaryRT(rtRnorm);
                Graphics.Blit(rtRnorm, tr1);

                for (var p = 0; p < paddingInterations; p++)
                {
                    var tr2 = GetTemporaryRT(rtRnorm);
                    Graphics.Blit(tr1, tr2, padMaterial);
                    RenderTexture.ReleaseTemporary(tr1);
                    tr1 = tr2;
                }

                trR = GetTemporaryRT(rtRnorm);
                alphaTransferMaterial.SetTexture("_AlphaTex", rtRnorm);
                Graphics.Blit(tr1, trR, alphaTransferMaterial);
                RenderTexture.ReleaseTemporary(tr1);
                

                //==================
                //Normals
                //==================
                RenderTexture.active = trL;
                stereoRTnorm.ReadPixels(new Rect(0, 0, renderSize, renderSize), 0, 0, false);
                stereoRTnorm.Apply();
                RenderTexture.active = trR;
                stereoRTnorm.ReadPixels(new Rect(0, 0, renderSize, renderSize), renderSize, 0, false);
                stereoRTnorm.Apply();
                RenderTexture.active = null;                

                bytes = stereoRTnorm.EncodeToPNG();

                if (i == 0)
                    File.WriteAllBytes(Application.dataPath + "/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm" + j.ToString() + ".png", bytes);
                else
                    File.WriteAllBytes(Application.dataPath + "/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm.mip" + i.ToString() + ".png", bytes);

            }
        }

        ObjectsToRenderParent.transform.localEulerAngles = new Vector3(0, ViewCount * rotStep, 0);//.Rotate(Vector3.up, j * rotStep);

        AssetDatabase.Refresh();

        StartCoroutine(doStereoMipMaping());

        refFloor.enabled = true;
        refPerson.enabled = true;
        focalpoint.GetChild(0).GetComponent<MeshRenderer>().enabled = true;
        refDebugFocalPlane.GetComponent<MeshRenderer>().enabled = true;

#endif
    }




    IEnumerator doStereoMipMaping()
    {
        yield return  new WaitForSeconds(0.5f);

#if UNITY_EDITOR
        
        
        //EditorUtility.DisplayDialog(vrsiName, "VRSI "+vrsiName+" Done!", "Ok");

        yield return new WaitForSeconds(0.25f);
        
        string fpath = Application.dataPath + "/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + ".png";
        Texture2D tmptex = LoadPNG(fpath);

        refBillboardQuad.material.SetTexture("_MainTex", (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + ".png", typeof(Texture2D)));

        if (renderNormals)
        {
            refBillboardQuad.material.SetTexture("_WSNormals", (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm.png", typeof(Texture2D)));
        }


        //======================
        //Build Texture Array
        //======================
        int slices = MultiViewPointCount;
     
        // CHANGEME: TextureFormat.RGB24 is good for PNG files with no alpha channels. Use TextureFormat.RGB32 with alpha.
        // See Texture2DArray in unity scripting API.
        Texture2DArray textureArray = new Texture2DArray(vrsiRenderSize*2, vrsiRenderSize, slices, TextureFormat.ARGB32, true);
        Texture2DArray textureArrayNormals = new Texture2DArray(vrsiRenderSize * 2, vrsiRenderSize, slices, TextureFormat.ARGB32, true);

        // CHANGEME: If your files start at 001, use i = 1. Otherwise change to what you got.
        for (int i = 0; i < slices; i++)
        {            
            var tImporter = AssetImporter.GetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + i.ToString() + ".png") as TextureImporter;
            if (tImporter != null)
            {
                //tImporter.textureType = TextureImporterType.Default;
                tImporter.isReadable = true;                
                //tImporter.maxTextureSize = 4096;                
            }            
            AssetDatabase.ImportAsset("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + i.ToString() + ".png");

            //Normals
            tImporter = AssetImporter.GetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm" + i.ToString() + ".png") as TextureImporter;
            if (tImporter != null)
            {
                //tImporter.textureType = TextureImporterType.Default;
                tImporter.isReadable = true;
                //tImporter.maxTextureSize = 4096;                
            }
            AssetDatabase.ImportAsset("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm" + i.ToString() + ".png");
        }
        


        for (int i = 0; i < slices; i++)
        {
           
            Texture2D tex = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + i.ToString() + ".png", typeof(Texture2D));
            
            textureArray.SetPixels(tex.GetPixels(0), i, 0);

            //Normals
            Texture2D tex2 = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm" + i.ToString() + ".png", typeof(Texture2D));

            textureArrayNormals.SetPixels(tex2.GetPixels(0), i, 0);


        }
        textureArray.Apply();
        textureArrayNormals.Apply();




        // CHANGEME: Path where you want to save the texture array. It must end in .asset extension for Unity to recognise it.
        string path = "Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_MV.asset";
        AssetDatabase.CreateAsset(textureArray, path);
        
        //Normals
        string pathNorm = "Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName+"_norm" + "_MV.asset";
        AssetDatabase.CreateAsset(textureArrayNormals, pathNorm);

        Debug.Log("Saved MultiView Asset To " + path);

           

        for (int i = 0; i < slices; i++)
        {
            AssetDatabase.DeleteAsset("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm" + i.ToString() + ".png");
            AssetDatabase.DeleteAsset("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + i.ToString() + ".png");
        }

       // AssetDatabase.Refresh();//============================================

        //=====================
        //Export Prefab Asset
        //=====================

        Renderer[] renderChildren = ObjectsToRenderParent.GetComponentsInChildren<Renderer>();

        Bounds bounds = new Bounds();

        foreach (var r in renderChildren)
        {
            bounds.Encapsulate(r.bounds);
        }
        
        //================================
        //Y-LOCKED BILLBOARD VARIANT
        //================================
        GameObject tmpgo = new GameObject();
        tmpgo.name = "tmpgo";       

        Mesh m;
        m = Resources.Load<Mesh>("jayquad");

        MeshFilter meshfilter = tmpgo.AddComponent<MeshFilter>();
        meshfilter.mesh = m;
        MeshRenderer tmptmr =  tmpgo.AddComponent<MeshRenderer>() as MeshRenderer;

        yield return new WaitForSeconds(0.25f);

        MeshRenderer mr = tmpgo.GetComponent<MeshRenderer>();
        mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.TwoSided;

        Material tmpmat;

        if (AlphaToCoverage)
        {
            tmpmat = new Material(Shader.Find("VRSI/MultiView/vrsiMultiView_MSAA_DIRECTIONAL"));
        }
        else
        {
            tmpmat = new Material(Shader.Find("VRSI/MultiView/vrsiMultiView_CUTOUT_DIRECTIONAL"));
        }

        tmpmat.SetTexture("_MyArr", (Texture2DArray)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2DArray)));

        //yield return new WaitForSeconds(1.0f);


        tmpmat.SetTexture("_NormalsArr", (Texture2DArray)AssetDatabase.LoadAssetAtPath(pathNorm, typeof(Texture2DArray)));

        tmpmat.SetInt("_ViewPointCount", slices);

        Texture noiseTex = Resources.Load<Texture>("Textures/Noise");

        tmpmat.SetTexture("_NoiseTex", noiseTex);


        if (renderNormals)
        {
            tmpmat.SetTexture("_WSNormals", (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_norm.png", typeof(Texture2D)));
        }

        AssetDatabase.CreateAsset(tmpmat, "Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName+"_Ylock_mat" + ".mat");
        AssetDatabase.SaveAssets();
        //AssetDatabase.Refresh();

        mr.materials[0] = tmpmat;
        mr.material = tmpmat;        

        //Rescale Quad
        tmpgo.transform.localScale = new Vector3(bounds.max.y * 2.0f, bounds.max.y * 2.0f, bounds.max.y * 2.0f);
        tmpgo.transform.localPosition = Vector3.zero;        

        GameObject prefabVariant = PrefabUtility.SaveAsPrefabAsset(tmpgo, "Assets/VRSI/" + folderName + "/" + vrsiName + "/" + vrsiName + "_Ylock_prefab_MV" + ".prefab");        

        Destroy(tmpgo);

        yield return new WaitForSeconds(0.25f);        

        AssetDatabase.Refresh();
        EditorUtility.DisplayDialog("ALL DONE", "VRSI " + vrsiName + " MULTIVIEW ASSET READY", "Ok");
        //yield return new WaitForSeconds(1.5f);
        AllowPostProcess = true;

#endif

    }

    Texture2D duplicateTexture(Texture2D source)
    {
        RenderTexture renderTex = RenderTexture.GetTemporary(
                    source.width,
                    source.height,
                    0,
                    RenderTextureFormat.Default,
                    RenderTextureReadWrite.Linear);

        Graphics.Blit(source, renderTex);
        RenderTexture previous = RenderTexture.active;
        RenderTexture.active = renderTex;
        Texture2D readableText = new Texture2D(source.width, source.height);
        readableText.ReadPixels(new Rect(0, 0, renderTex.width, renderTex.height), 0, 0);
        readableText.Apply();
        RenderTexture.active = previous;
        RenderTexture.ReleaseTemporary(renderTex);
        return readableText;
    }

    public static Texture2D LoadPNG(string filePath)
    {
        Texture2D tex = null;
        byte[] fileData;

        if (File.Exists(filePath))
        {
            fileData = File.ReadAllBytes(filePath);
            tex = new Texture2D(2, 2);
            tex.LoadImage(fileData); //..this will auto-resize the texture dimensions.
        }
        return tex;
    }
}
