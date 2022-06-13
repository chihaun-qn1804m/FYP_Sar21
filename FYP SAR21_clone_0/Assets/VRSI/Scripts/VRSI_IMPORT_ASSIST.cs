using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class VRSI_IMPORT_ASSIST : MonoBehaviour
{
#if UNITY_EDITOR
    public VRSI_RenderTool creator;

    public List<Texture> VRSI = new List<Texture>();
    public List<Texture> VRSI_Normal = new List<Texture>();

    void Start()
    {       

        if (EditorUtility.DisplayDialog("VRSI Re-Import Assist", "Please Make A Backup Of Your Project Before You Continue, Click Continue To Start Re-Import. This may take a little while", "Continue", "Cancel"))
        {
            StartCoroutine(doReimport());
        }
    }

    IEnumerator doReimport()
    {
        for(int i=0; i<VRSI.Count; i++)
        {
            string name = AssetDatabase.GetAssetPath(VRSI[i]);
            Debug.Log("Importing:"+name);

            creator.AllowPostProcess = true;
            AssetDatabase.ImportAsset(name);
            creator.AllowPostProcess = false;
            yield return new WaitForSeconds(0.25f);
        }

        EditorUtility.DisplayDialog("Complete!", "VRSI Import Finished, You Can Now Try The VRSI Demo in Assets/VRSI/Demo Folder", "Ok");

        yield return null;
    }

#endif

}
