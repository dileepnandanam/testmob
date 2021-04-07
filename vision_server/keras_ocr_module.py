import keras_ocr

pipeline = keras_ocr.pipeline.Pipeline()

def match_text(img,text): 

    co_x = None
    co_y = None
    images = [img]

    text = text.lower()
    prediction_groups = pipeline.recognize(images)
    
    for i in range(len(prediction_groups[0])):
        if prediction_groups[0][i][0] == text:
            a = prediction_groups[0][i][1]
            co_x = int(a[0][0] + ((abs(a[1][0] - a[0][0]))/2))
            co_y = int(a[0][1] + ((abs(a[3][1] - a[0][1]))/2) - abs(a[3][1] - a[0][1]))
            break

    return [co_x,co_y]
