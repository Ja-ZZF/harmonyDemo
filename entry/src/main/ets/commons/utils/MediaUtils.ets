import { MediaSimple } from "../../models/Media";

export function convertMediaUrls(
  medias: MediaSimple[],
  targetSize: 'thumb' | 'medium' | 'large' | 'original'
): MediaSimple[] {
  return medias.map(media => {
    const newUrl = media.url.replace('/original/', `/${targetSize}/`);
    const newMedia: MediaSimple = {
      media_id: media.media_id,
      url: newUrl
    };
    return newMedia;
  });
}
