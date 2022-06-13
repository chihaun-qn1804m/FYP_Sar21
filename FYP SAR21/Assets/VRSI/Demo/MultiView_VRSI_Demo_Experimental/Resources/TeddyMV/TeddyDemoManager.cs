using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeddyDemoManager : MonoBehaviour
{
    public GameObject prefabGO;
    public int teddyCount = 16;
    public Transform targetParent;
    public float turnSpeed = 3.0f;

    List<Transform> teddies = new List<Transform>();
    List<Transform> tedtargets = new List<Transform>();

    void Start()
    {
        for(int i=0;i<teddyCount;i++)
        {
            bool loop = true;
            Vector3 pos = Vector3.zero;
            while (loop)
            {
                pos = new Vector3(Random.Range(-1.0f, 1.0f), 0.0f, Random.Range(-1.0f, 1.0f)).normalized * Random.Range(3.0f, 9.0f) * (1 + i * 0.007f);

                bool found = false;
                for (int j = 0; j < teddies.Count; j++)
                {
                    if(Vector3.Distance(pos, teddies[j].position)< 1.4f)
                    {
                        found = true;
                        break;
                    }
                }
                if (!found) loop = false;
            }


            GameObject tmpgo = Instantiate(prefabGO, pos, Quaternion.identity, this.transform);
            GameObject target = new GameObject("tedTarget");
            //target.hideFlags = HideFlags.HideAndDontSave;
            target.transform.position = pos;
            target.transform.parent = targetParent;
            tedtargets.Add(target.transform);
            

            tmpgo.transform.position = pos;
            tmpgo.transform.localScale *= Random.Range(0.8f, 1.1f);
            tmpgo.hideFlags = HideFlags.HideAndDontSave;
            teddies.Add(tmpgo.transform);

        }
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < teddyCount; i++)
        {
            teddies[i].position = tedtargets[i].position;
        }

        targetParent.Rotate(Vector3.up, Time.deltaTime*turnSpeed);
    }
}
