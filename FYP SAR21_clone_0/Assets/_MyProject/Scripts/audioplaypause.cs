using UnityEngine;

// The Audio Source component has an AudioClip option.  The audio
// played in this example comes from AudioClip and is called audioData.
public class audioplaypause : MonoBehaviour
{
 public void TogglePlay()
 {
      if(GetComponent<AudioSource>().isPlaying)
      {
         GetComponent<AudioSource>().Stop();
      }
      else
      {
         GetComponent<AudioSource>().Play();
      }
 }
}