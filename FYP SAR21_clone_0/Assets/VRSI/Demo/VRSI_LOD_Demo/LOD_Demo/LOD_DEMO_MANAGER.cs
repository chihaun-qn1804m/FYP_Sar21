using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LOD_DEMO_MANAGER : MonoBehaviour
{
    public GameObject treePrefab;
    public Transform camParent;

    public float size = 512;
    public float resolution = 8.0f;
    public float lateralOffset = 2.0f;
    public float minScale = 0.9f;
    public float maxScale = 1.2f;
    public float yPos = -3.77f;
    public float moveSpeed = 1.0f;

    List<GameObject> trees = new List<GameObject>();

    void Start()
    {
        Vector3 startPos = this.transform.position - new Vector3(size/2, 0, size/2);
        int count = (int)(size / resolution);
        int placedTreeCount = 0;
        for(int x=0; x<count; x++)
        {
            for (int y = 0; y < count; y++)
            {
                Vector3 pos = startPos + new Vector3(resolution * x + Random.Range(-lateralOffset, lateralOffset), 0, resolution * y + Random.Range(-lateralOffset, lateralOffset));
                pos = new Vector3(pos.x, yPos, pos.z);
                GameObject tmpgo = Instantiate(treePrefab, pos, Quaternion.identity, this.transform);
                tmpgo.hideFlags = HideFlags.HideAndDontSave;
                tmpgo.transform.localScale *= Random.Range(minScale, maxScale);
                trees.Add(tmpgo);
                placedTreeCount++;
            }
        }

        Debug.Log(placedTreeCount);

    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKey(KeyCode.UpArrow) || Input.GetKey(KeyCode.W))
        {
            camParent.position += Vector3.forward * Time.deltaTime * moveSpeed;
        }
        else if (Input.GetKey(KeyCode.DownArrow) || Input.GetKey(KeyCode.S))
        {
            camParent.position -= Vector3.forward * Time.deltaTime * moveSpeed;
        }

        if (Input.GetKey(KeyCode.RightArrow) || Input.GetKey(KeyCode.D))
        {
            camParent.position += Vector3.right * Time.deltaTime * moveSpeed;
        }
        else if (Input.GetKey(KeyCode.LeftArrow) || Input.GetKey(KeyCode.A))
        {
            camParent.position -= Vector3.right * Time.deltaTime * moveSpeed;
        }
    }
}
