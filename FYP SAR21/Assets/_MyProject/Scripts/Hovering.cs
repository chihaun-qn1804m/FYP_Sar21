using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class Hovering : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    public GameObject canvasimg;
    public Sprite Onlineimg;
    public Sprite Offlineimg;
    public Sprite Settingimg;
    //Detect if the Cursor starts to pass over the GameObject

   
    public void OnPointerEnter(PointerEventData pointerEventData)
    {
        if (name == "Online") {
            Debug.Log("Cursor Entering test");
            canvasimg.GetComponent<Image>().sprite = Onlineimg;
        }
        if (name == "OFFLINE") {
            canvasimg.GetComponent<Image>().sprite = Offlineimg;
        }
        if (name == "SETTINGS") {
            canvasimg.GetComponent<Image>().sprite = Settingimg;
        }
        //Output to console the GameObject's name and the following message
        Debug.Log("Cursor Entering " + name + " GameObject");
    }

    //Detect when Cursor leaves the GameObject
    public void OnPointerExit(PointerEventData pointerEventData)
    {
        //Output the following message with the GameObject's name
        Debug.Log("Cursor Exiting " + name + " GameObject");
    }
}