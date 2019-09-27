
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Face Client
## version: 1.0
## termsOfService: (not provided)
## license: (not provided)
## 
## An API for face detection, verification, and identification.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-Face"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FaceDetectWithUrl_593661 = ref object of OpenApiRestCall_593439
proc url_FaceDetectWithUrl_593663(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceDetectWithUrl_593662(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Detect human faces in an image, return face rectangles, and optionally with faceIds, landmarks, and attributes.<br />
  ## * No image will be stored. Only the extracted face feature will be stored on server. The faceId is an identifier of the face feature and will be used in [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). The stored face feature(s) will expire and be deleted 24 hours after the original detection call.
  ## * Optional parameters include faceId, landmarks, and attributes. Attributes include age, gender, headPose, smile, facialHair, glasses, emotion, hair, makeup, occlusion, accessories, blur, exposure and noise. Some of the results returned for specific attributes may not be highly accurate.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * Up to 100 faces can be returned for an image. Faces are ranked by face rectangle size from large to small.
  ## * For optimal results when querying [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) ('returnFaceId' is true), please use faces that are: frontal, clear, and with a minimum size of 200x200 pixels (100 pixels between eyes).
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## * Different 'recognitionModel' values are provided. If follow-up operations like Verify, Identify, Find Similar are needed, please specify the recognition model with 'recognitionModel' parameter. The default value for 'recognitionModel' is 'recognition_01', if latest model needed, please explicitly specify the model you need in this parameter. Once specified, the detected faceIds will be associated with the specified recognition model. More details, please refer to [How to specify a recognition model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-recognition-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'recognition_01': | The default recognition model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). All those faceIds created before 2019 March are bonded with this recognition model. |
  ##   | 'recognition_02': | Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'. |
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnFaceAttributes: JArray
  ##                       : Analyze and return the one or more specified face attributes in the comma-separated string like "returnFaceAttributes=age,gender". Supported face attributes include age, gender, headPose, smile, facialHair, glasses and emotion. Note that each face attribute analysis has additional computational and time cost.
  ##   returnFaceId: JBool
  ##               : A value indicating whether the operation should return faceIds of detected faces.
  ##   returnFaceLandmarks: JBool
  ##                      : A value indicating whether the operation should return landmarks of the detected faces.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   recognitionModel: JString
  ##                   : Name of recognition model. Recognition model is used when the face features are extracted and associated with detected faceIds, (Large)FaceList or (Large)PersonGroup. A recognition model name can be provided when performing Face - Detect or (Large)FaceList - Create or (Large)PersonGroup - Create. The default value is 'recognition_01', if latest model needed, please explicitly specify the model you need.
  section = newJObject()
  var valid_593822 = query.getOrDefault("returnFaceAttributes")
  valid_593822 = validateParameter(valid_593822, JArray, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "returnFaceAttributes", valid_593822
  var valid_593836 = query.getOrDefault("returnFaceId")
  valid_593836 = validateParameter(valid_593836, JBool, required = false,
                                 default = newJBool(true))
  if valid_593836 != nil:
    section.add "returnFaceId", valid_593836
  var valid_593837 = query.getOrDefault("returnFaceLandmarks")
  valid_593837 = validateParameter(valid_593837, JBool, required = false,
                                 default = newJBool(false))
  if valid_593837 != nil:
    section.add "returnFaceLandmarks", valid_593837
  var valid_593838 = query.getOrDefault("detectionModel")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_593838 != nil:
    section.add "detectionModel", valid_593838
  var valid_593839 = query.getOrDefault("returnRecognitionModel")
  valid_593839 = validateParameter(valid_593839, JBool, required = false,
                                 default = newJBool(false))
  if valid_593839 != nil:
    section.add "returnRecognitionModel", valid_593839
  var valid_593840 = query.getOrDefault("recognitionModel")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = newJString("recognition_01"))
  if valid_593840 != nil:
    section.add "recognitionModel", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593864: Call_FaceDetectWithUrl_593661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detect human faces in an image, return face rectangles, and optionally with faceIds, landmarks, and attributes.<br />
  ## * No image will be stored. Only the extracted face feature will be stored on server. The faceId is an identifier of the face feature and will be used in [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). The stored face feature(s) will expire and be deleted 24 hours after the original detection call.
  ## * Optional parameters include faceId, landmarks, and attributes. Attributes include age, gender, headPose, smile, facialHair, glasses, emotion, hair, makeup, occlusion, accessories, blur, exposure and noise. Some of the results returned for specific attributes may not be highly accurate.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * Up to 100 faces can be returned for an image. Faces are ranked by face rectangle size from large to small.
  ## * For optimal results when querying [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) ('returnFaceId' is true), please use faces that are: frontal, clear, and with a minimum size of 200x200 pixels (100 pixels between eyes).
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## * Different 'recognitionModel' values are provided. If follow-up operations like Verify, Identify, Find Similar are needed, please specify the recognition model with 'recognitionModel' parameter. The default value for 'recognitionModel' is 'recognition_01', if latest model needed, please explicitly specify the model you need in this parameter. Once specified, the detected faceIds will be associated with the specified recognition model. More details, please refer to [How to specify a recognition model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-recognition-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'recognition_01': | The default recognition model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). All those faceIds created before 2019 March are bonded with this recognition model. |
  ##   | 'recognition_02': | Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'. |
  ## 
  let valid = call_593864.validator(path, query, header, formData, body)
  let scheme = call_593864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593864.url(scheme.get, call_593864.host, call_593864.base,
                         call_593864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593864, url, valid)

proc call*(call_593935: Call_FaceDetectWithUrl_593661; ImageUrl: JsonNode;
          returnFaceAttributes: JsonNode = nil; returnFaceId: bool = true;
          returnFaceLandmarks: bool = false;
          detectionModel: string = "detection_01";
          returnRecognitionModel: bool = false;
          recognitionModel: string = "recognition_01"): Recallable =
  ## faceDetectWithUrl
  ## Detect human faces in an image, return face rectangles, and optionally with faceIds, landmarks, and attributes.<br />
  ## * No image will be stored. Only the extracted face feature will be stored on server. The faceId is an identifier of the face feature and will be used in [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). The stored face feature(s) will expire and be deleted 24 hours after the original detection call.
  ## * Optional parameters include faceId, landmarks, and attributes. Attributes include age, gender, headPose, smile, facialHair, glasses, emotion, hair, makeup, occlusion, accessories, blur, exposure and noise. Some of the results returned for specific attributes may not be highly accurate.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * Up to 100 faces can be returned for an image. Faces are ranked by face rectangle size from large to small.
  ## * For optimal results when querying [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239), [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a), and [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) ('returnFaceId' is true), please use faces that are: frontal, clear, and with a minimum size of 200x200 pixels (100 pixels between eyes).
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## * Different 'recognitionModel' values are provided. If follow-up operations like Verify, Identify, Find Similar are needed, please specify the recognition model with 'recognitionModel' parameter. The default value for 'recognitionModel' is 'recognition_01', if latest model needed, please explicitly specify the model you need in this parameter. Once specified, the detected faceIds will be associated with the specified recognition model. More details, please refer to [How to specify a recognition model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-recognition-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'recognition_01': | The default recognition model for [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236). All those faceIds created before 2019 March are bonded with this recognition model. |
  ##   | 'recognition_02': | Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'. |
  ##   returnFaceAttributes: JArray
  ##                       : Analyze and return the one or more specified face attributes in the comma-separated string like "returnFaceAttributes=age,gender". Supported face attributes include age, gender, headPose, smile, facialHair, glasses and emotion. Note that each face attribute analysis has additional computational and time cost.
  ##   returnFaceId: bool
  ##               : A value indicating whether the operation should return faceIds of detected faces.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   returnFaceLandmarks: bool
  ##                      : A value indicating whether the operation should return landmarks of the detected faces.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   recognitionModel: string
  ##                   : Name of recognition model. Recognition model is used when the face features are extracted and associated with detected faceIds, (Large)FaceList or (Large)PersonGroup. A recognition model name can be provided when performing Face - Detect or (Large)FaceList - Create or (Large)PersonGroup - Create. The default value is 'recognition_01', if latest model needed, please explicitly specify the model you need.
  var query_593936 = newJObject()
  var body_593938 = newJObject()
  if returnFaceAttributes != nil:
    query_593936.add "returnFaceAttributes", returnFaceAttributes
  add(query_593936, "returnFaceId", newJBool(returnFaceId))
  if ImageUrl != nil:
    body_593938 = ImageUrl
  add(query_593936, "returnFaceLandmarks", newJBool(returnFaceLandmarks))
  add(query_593936, "detectionModel", newJString(detectionModel))
  add(query_593936, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_593936, "recognitionModel", newJString(recognitionModel))
  result = call_593935.call(nil, query_593936, nil, nil, body_593938)

var faceDetectWithUrl* = Call_FaceDetectWithUrl_593661(name: "faceDetectWithUrl",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/detect",
    validator: validate_FaceDetectWithUrl_593662, base: "",
    url: url_FaceDetectWithUrl_593663, schemes: {Scheme.Https})
type
  Call_FaceListList_593977 = ref object of OpenApiRestCall_593439
proc url_FaceListList_593979(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceListList_593978(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_593980 = query.getOrDefault("returnRecognitionModel")
  valid_593980 = validateParameter(valid_593980, JBool, required = false,
                                 default = newJBool(false))
  if valid_593980 != nil:
    section.add "returnRecognitionModel", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_FaceListList_593977; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_FaceListList_593977;
          returnRecognitionModel: bool = false): Recallable =
  ## faceListList
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var query_593983 = newJObject()
  add(query_593983, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_593982.call(nil, query_593983, nil, nil, nil)

var faceListList* = Call_FaceListList_593977(name: "faceListList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/facelists",
    validator: validate_FaceListList_593978, base: "", url: url_FaceListList_593979,
    schemes: {Scheme.Https})
type
  Call_FaceListCreate_594007 = ref object of OpenApiRestCall_593439
proc url_FaceListCreate_594009(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListCreate_594008(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_594010 = path.getOrDefault("faceListId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "faceListId", valid_594010
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating a face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_FaceListCreate_594007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_FaceListCreate_594007; faceListId: string;
          body: JsonNode): Recallable =
  ## faceListCreate
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   body: JObject (required)
  ##       : Request body for creating a face list.
  var path_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594014, "faceListId", newJString(faceListId))
  if body != nil:
    body_594015 = body
  result = call_594013.call(path_594014, nil, nil, nil, body_594015)

var faceListCreate* = Call_FaceListCreate_594007(name: "faceListCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/facelists/{faceListId}",
    validator: validate_FaceListCreate_594008, base: "", url: url_FaceListCreate_594009,
    schemes: {Scheme.Https})
type
  Call_FaceListGet_593984 = ref object of OpenApiRestCall_593439
proc url_FaceListGet_593986(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListGet_593985(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_594001 = path.getOrDefault("faceListId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "faceListId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_594002 = query.getOrDefault("returnRecognitionModel")
  valid_594002 = validateParameter(valid_594002, JBool, required = false,
                                 default = newJBool(false))
  if valid_594002 != nil:
    section.add "returnRecognitionModel", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_FaceListGet_593984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_FaceListGet_593984; faceListId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## faceListGet
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(path_594005, "faceListId", newJString(faceListId))
  add(query_594006, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var faceListGet* = Call_FaceListGet_593984(name: "faceListGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/facelists/{faceListId}",
                                        validator: validate_FaceListGet_593985,
                                        base: "", url: url_FaceListGet_593986,
                                        schemes: {Scheme.Https})
type
  Call_FaceListUpdate_594023 = ref object of OpenApiRestCall_593439
proc url_FaceListUpdate_594025(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListUpdate_594024(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update information of a face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_594026 = path.getOrDefault("faceListId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "faceListId", valid_594026
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating a face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_FaceListUpdate_594023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update information of a face list.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_FaceListUpdate_594023; faceListId: string;
          body: JsonNode): Recallable =
  ## faceListUpdate
  ## Update information of a face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   body: JObject (required)
  ##       : Request body for updating a face list.
  var path_594030 = newJObject()
  var body_594031 = newJObject()
  add(path_594030, "faceListId", newJString(faceListId))
  if body != nil:
    body_594031 = body
  result = call_594029.call(path_594030, nil, nil, nil, body_594031)

var faceListUpdate* = Call_FaceListUpdate_594023(name: "faceListUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/facelists/{faceListId}", validator: validate_FaceListUpdate_594024,
    base: "", url: url_FaceListUpdate_594025, schemes: {Scheme.Https})
type
  Call_FaceListDelete_594016 = ref object of OpenApiRestCall_593439
proc url_FaceListDelete_594018(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListDelete_594017(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a specified face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_594019 = path.getOrDefault("faceListId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "faceListId", valid_594019
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_FaceListDelete_594016; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specified face list.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_FaceListDelete_594016; faceListId: string): Recallable =
  ## faceListDelete
  ## Delete a specified face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_594022 = newJObject()
  add(path_594022, "faceListId", newJString(faceListId))
  result = call_594021.call(path_594022, nil, nil, nil, nil)

var faceListDelete* = Call_FaceListDelete_594016(name: "faceListDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/facelists/{faceListId}", validator: validate_FaceListDelete_594017,
    base: "", url: url_FaceListDelete_594018, schemes: {Scheme.Https})
type
  Call_FaceListAddFaceFromUrl_594032 = ref object of OpenApiRestCall_593439
proc url_FaceListAddFaceFromUrl_594034(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListAddFaceFromUrl_594033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a specified face list, up to 1,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [FaceList - Delete Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395251) or [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better detection and recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_594035 = path.getOrDefault("faceListId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "faceListId", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_594036 = query.getOrDefault("userData")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "userData", valid_594036
  var valid_594037 = query.getOrDefault("detectionModel")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_594037 != nil:
    section.add "detectionModel", valid_594037
  var valid_594038 = query.getOrDefault("targetFace")
  valid_594038 = validateParameter(valid_594038, JArray, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "targetFace", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_FaceListAddFaceFromUrl_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a face to a specified face list, up to 1,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [FaceList - Delete Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395251) or [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better detection and recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_FaceListAddFaceFromUrl_594032; faceListId: string;
          ImageUrl: JsonNode; userData: string = "";
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil): Recallable =
  ## faceListAddFaceFromUrl
  ## Add a face to a specified face list, up to 1,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [FaceList - Delete Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395251) or [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better detection and recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(path_594042, "faceListId", newJString(faceListId))
  add(query_594043, "userData", newJString(userData))
  if ImageUrl != nil:
    body_594044 = ImageUrl
  add(query_594043, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_594043.add "targetFace", targetFace
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var faceListAddFaceFromUrl* = Call_FaceListAddFaceFromUrl_594032(
    name: "faceListAddFaceFromUrl", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/facelists/{faceListId}/persistedfaces",
    validator: validate_FaceListAddFaceFromUrl_594033, base: "",
    url: url_FaceListAddFaceFromUrl_594034, schemes: {Scheme.Https})
type
  Call_FaceListDeleteFace_594045 = ref object of OpenApiRestCall_593439
proc url_FaceListDeleteFace_594047(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "faceListId" in path, "`faceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/facelists/"),
               (kind: VariableSegment, value: "faceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FaceListDeleteFace_594046(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `faceListId` field"
  var valid_594048 = path.getOrDefault("faceListId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "faceListId", valid_594048
  var valid_594049 = path.getOrDefault("persistedFaceId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "persistedFaceId", valid_594049
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_FaceListDeleteFace_594045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_FaceListDeleteFace_594045; faceListId: string;
          persistedFaceId: string): Recallable =
  ## faceListDeleteFace
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_594052 = newJObject()
  add(path_594052, "faceListId", newJString(faceListId))
  add(path_594052, "persistedFaceId", newJString(persistedFaceId))
  result = call_594051.call(path_594052, nil, nil, nil, nil)

var faceListDeleteFace* = Call_FaceListDeleteFace_594045(
    name: "faceListDeleteFace", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/facelists/{faceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_FaceListDeleteFace_594046, base: "",
    url: url_FaceListDeleteFace_594047, schemes: {Scheme.Https})
type
  Call_FaceFindSimilar_594053 = ref object of OpenApiRestCall_593439
proc url_FaceFindSimilar_594055(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceFindSimilar_594054(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for Find Similar.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_FaceFindSimilar_594053; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_FaceFindSimilar_594053; body: JsonNode): Recallable =
  ## faceFindSimilar
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ##   body: JObject (required)
  ##       : Request body for Find Similar.
  var body_594059 = newJObject()
  if body != nil:
    body_594059 = body
  result = call_594058.call(nil, nil, nil, nil, body_594059)

var faceFindSimilar* = Call_FaceFindSimilar_594053(name: "faceFindSimilar",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/findsimilars",
    validator: validate_FaceFindSimilar_594054, base: "", url: url_FaceFindSimilar_594055,
    schemes: {Scheme.Https})
type
  Call_FaceGroup_594060 = ref object of OpenApiRestCall_593439
proc url_FaceGroup_594062(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceGroup_594061(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for grouping.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_FaceGroup_594060; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_FaceGroup_594060; body: JsonNode): Recallable =
  ## faceGroup
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ##   body: JObject (required)
  ##       : Request body for grouping.
  var body_594066 = newJObject()
  if body != nil:
    body_594066 = body
  result = call_594065.call(nil, nil, nil, nil, body_594066)

var faceGroup* = Call_FaceGroup_594060(name: "faceGroup", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/group",
                                    validator: validate_FaceGroup_594061,
                                    base: "", url: url_FaceGroup_594062,
                                    schemes: {Scheme.Https})
type
  Call_FaceIdentify_594067 = ref object of OpenApiRestCall_593439
proc url_FaceIdentify_594069(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceIdentify_594068(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## 1-to-many identification to find the closest matches of the specific query person face from a person group or large person group.
  ## <br/> For each face in the faceIds array, Face Identify will compute similarities between the query face and all the faces in the person group (given by personGroupId) or large person group (given by largePersonGroupId), and return candidate person(s) for that face ranked by similarity confidence. The person group/large person group should be trained to make it ready for identification. See more in [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) and [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4).
  ## <br/>
  ##  
  ## Remarks:<br />
  ## * The algorithm allows more than one face to be identified independently at the same request, but no more than 10 faces.
  ## * Each person in the person group/large person group could have more than one face, but no more than 248 faces.
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Number of candidates returned is restricted by maxNumOfCandidatesReturned and confidenceThreshold. If no person is identified, the returned candidates will be an empty array.
  ## * Try [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) when you need to find similar faces from a face list/large face list instead of a person group/large person group.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target person group or large person group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for identify operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_FaceIdentify_594067; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## 1-to-many identification to find the closest matches of the specific query person face from a person group or large person group.
  ## <br/> For each face in the faceIds array, Face Identify will compute similarities between the query face and all the faces in the person group (given by personGroupId) or large person group (given by largePersonGroupId), and return candidate person(s) for that face ranked by similarity confidence. The person group/large person group should be trained to make it ready for identification. See more in [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) and [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4).
  ## <br/>
  ##  
  ## Remarks:<br />
  ## * The algorithm allows more than one face to be identified independently at the same request, but no more than 10 faces.
  ## * Each person in the person group/large person group could have more than one face, but no more than 248 faces.
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Number of candidates returned is restricted by maxNumOfCandidatesReturned and confidenceThreshold. If no person is identified, the returned candidates will be an empty array.
  ## * Try [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) when you need to find similar faces from a face list/large face list instead of a person group/large person group.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target person group or large person group.
  ## 
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_FaceIdentify_594067; body: JsonNode): Recallable =
  ## faceIdentify
  ## 1-to-many identification to find the closest matches of the specific query person face from a person group or large person group.
  ## <br/> For each face in the faceIds array, Face Identify will compute similarities between the query face and all the faces in the person group (given by personGroupId) or large person group (given by largePersonGroupId), and return candidate person(s) for that face ranked by similarity confidence. The person group/large person group should be trained to make it ready for identification. See more in [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) and [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4).
  ## <br/>
  ##  
  ## Remarks:<br />
  ## * The algorithm allows more than one face to be identified independently at the same request, but no more than 10 faces.
  ## * Each person in the person group/large person group could have more than one face, but no more than 248 faces.
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Number of candidates returned is restricted by maxNumOfCandidatesReturned and confidenceThreshold. If no person is identified, the returned candidates will be an empty array.
  ## * Try [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237) when you need to find similar faces from a face list/large face list instead of a person group/large person group.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target person group or large person group.
  ## 
  ##   body: JObject (required)
  ##       : Request body for identify operation.
  var body_594073 = newJObject()
  if body != nil:
    body_594073 = body
  result = call_594072.call(nil, nil, nil, nil, body_594073)

var faceIdentify* = Call_FaceIdentify_594067(name: "faceIdentify",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/identify",
    validator: validate_FaceIdentify_594068, base: "", url: url_FaceIdentify_594069,
    schemes: {Scheme.Https})
type
  Call_LargeFaceListList_594074 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListList_594076(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LargeFaceListList_594075(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List large face lists’ information of largeFaceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside largeFaceList use [LargeFaceList Face - Get](/docs/services/563879b61984550e40cbbe8d/operations/5a158cf2d2de3616c086f2d5)<br />
  ## * Large face lists are stored in alphabetical order of largeFaceListId.
  ## * "start" parameter (string, optional) is a user-provided largeFaceListId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person lists: "list1", ..., "list5".
  ## <br /> "start=&top=" will return all 5 lists.
  ## <br /> "start=&top=2" will return "list1", "list2".
  ## <br /> "start=list2&top=3" will return "list3", "list4", "list5".
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_594077 = query.getOrDefault("returnRecognitionModel")
  valid_594077 = validateParameter(valid_594077, JBool, required = false,
                                 default = newJBool(false))
  if valid_594077 != nil:
    section.add "returnRecognitionModel", valid_594077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_LargeFaceListList_594074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List large face lists’ information of largeFaceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside largeFaceList use [LargeFaceList Face - Get](/docs/services/563879b61984550e40cbbe8d/operations/5a158cf2d2de3616c086f2d5)<br />
  ## * Large face lists are stored in alphabetical order of largeFaceListId.
  ## * "start" parameter (string, optional) is a user-provided largeFaceListId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person lists: "list1", ..., "list5".
  ## <br /> "start=&top=" will return all 5 lists.
  ## <br /> "start=&top=2" will return "list1", "list2".
  ## <br /> "start=list2&top=3" will return "list3", "list4", "list5".
  ## 
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_LargeFaceListList_594074;
          returnRecognitionModel: bool = false): Recallable =
  ## largeFaceListList
  ## List large face lists’ information of largeFaceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside largeFaceList use [LargeFaceList Face - Get](/docs/services/563879b61984550e40cbbe8d/operations/5a158cf2d2de3616c086f2d5)<br />
  ## * Large face lists are stored in alphabetical order of largeFaceListId.
  ## * "start" parameter (string, optional) is a user-provided largeFaceListId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person lists: "list1", ..., "list5".
  ## <br /> "start=&top=" will return all 5 lists.
  ## <br /> "start=&top=2" will return "list1", "list2".
  ## <br /> "start=list2&top=3" will return "list3", "list4", "list5".
  ## 
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var query_594080 = newJObject()
  add(query_594080, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_594079.call(nil, query_594080, nil, nil, nil)

var largeFaceListList* = Call_LargeFaceListList_594074(name: "largeFaceListList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/largefacelists",
    validator: validate_LargeFaceListList_594075, base: "",
    url: url_LargeFaceListList_594076, schemes: {Scheme.Https})
type
  Call_LargeFaceListCreate_594090 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListCreate_594092(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListCreate_594091(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create an empty large face list with user-specified largeFaceListId, name, an optional userData and recognitionModel.
  ## <br /> Large face list is a list of faces, up to 1,000,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [LargeFaceList Face - Add](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3) to import the faces and [LargeFaceList - Train](/docs/services/563879b61984550e40cbbe8d/operations/5a158422d2de3616c086f2d1) to make it ready for [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). No image will be stored. Only the extracted face features are stored on server until [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br/>'recognitionModel' should be specified to associate with this large face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large face list will use the recognition model that's already associated with the collection. Existing face features in a large face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargeFaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc). All those large face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large face list quota:
  ## * Free-tier subscription quota: 64 large face lists.
  ## * S0-tier subscription quota: 1,000,000 large face lists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594093 = path.getOrDefault("largeFaceListId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "largeFaceListId", valid_594093
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating a large face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_LargeFaceListCreate_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an empty large face list with user-specified largeFaceListId, name, an optional userData and recognitionModel.
  ## <br /> Large face list is a list of faces, up to 1,000,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [LargeFaceList Face - Add](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3) to import the faces and [LargeFaceList - Train](/docs/services/563879b61984550e40cbbe8d/operations/5a158422d2de3616c086f2d1) to make it ready for [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). No image will be stored. Only the extracted face features are stored on server until [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br/>'recognitionModel' should be specified to associate with this large face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large face list will use the recognition model that's already associated with the collection. Existing face features in a large face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargeFaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc). All those large face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large face list quota:
  ## * Free-tier subscription quota: 64 large face lists.
  ## * S0-tier subscription quota: 1,000,000 large face lists.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_LargeFaceListCreate_594090; largeFaceListId: string;
          body: JsonNode): Recallable =
  ## largeFaceListCreate
  ## Create an empty large face list with user-specified largeFaceListId, name, an optional userData and recognitionModel.
  ## <br /> Large face list is a list of faces, up to 1,000,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [LargeFaceList Face - Add](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3) to import the faces and [LargeFaceList - Train](/docs/services/563879b61984550e40cbbe8d/operations/5a158422d2de3616c086f2d1) to make it ready for [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237). No image will be stored. Only the extracted face features are stored on server until [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br/>'recognitionModel' should be specified to associate with this large face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large face list will use the recognition model that's already associated with the collection. Existing face features in a large face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargeFaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc). All those large face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large face list quota:
  ## * Free-tier subscription quota: 64 large face lists.
  ## * S0-tier subscription quota: 1,000,000 large face lists.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   body: JObject (required)
  ##       : Request body for creating a large face list.
  var path_594097 = newJObject()
  var body_594098 = newJObject()
  add(path_594097, "largeFaceListId", newJString(largeFaceListId))
  if body != nil:
    body_594098 = body
  result = call_594096.call(path_594097, nil, nil, nil, body_594098)

var largeFaceListCreate* = Call_LargeFaceListCreate_594090(
    name: "largeFaceListCreate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListCreate_594091, base: "",
    url: url_LargeFaceListCreate_594092, schemes: {Scheme.Https})
type
  Call_LargeFaceListGet_594081 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListGet_594083(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListGet_594082(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594084 = path.getOrDefault("largeFaceListId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "largeFaceListId", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_594085 = query.getOrDefault("returnRecognitionModel")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(false))
  if valid_594085 != nil:
    section.add "returnRecognitionModel", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_LargeFaceListGet_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_LargeFaceListGet_594081; largeFaceListId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## largeFaceListGet
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "largeFaceListId", newJString(largeFaceListId))
  add(query_594089, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var largeFaceListGet* = Call_LargeFaceListGet_594081(name: "largeFaceListGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListGet_594082, base: "",
    url: url_LargeFaceListGet_594083, schemes: {Scheme.Https})
type
  Call_LargeFaceListUpdate_594106 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListUpdate_594108(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListUpdate_594107(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update information of a large face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594109 = path.getOrDefault("largeFaceListId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "largeFaceListId", valid_594109
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating a large face list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_LargeFaceListUpdate_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update information of a large face list.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_LargeFaceListUpdate_594106; largeFaceListId: string;
          body: JsonNode): Recallable =
  ## largeFaceListUpdate
  ## Update information of a large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   body: JObject (required)
  ##       : Request body for updating a large face list.
  var path_594113 = newJObject()
  var body_594114 = newJObject()
  add(path_594113, "largeFaceListId", newJString(largeFaceListId))
  if body != nil:
    body_594114 = body
  result = call_594112.call(path_594113, nil, nil, nil, body_594114)

var largeFaceListUpdate* = Call_LargeFaceListUpdate_594106(
    name: "largeFaceListUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListUpdate_594107, base: "",
    url: url_LargeFaceListUpdate_594108, schemes: {Scheme.Https})
type
  Call_LargeFaceListDelete_594099 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListDelete_594101(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListDelete_594100(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete a specified large face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594102 = path.getOrDefault("largeFaceListId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "largeFaceListId", valid_594102
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_LargeFaceListDelete_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specified large face list.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_LargeFaceListDelete_594099; largeFaceListId: string): Recallable =
  ## largeFaceListDelete
  ## Delete a specified large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_594105 = newJObject()
  add(path_594105, "largeFaceListId", newJString(largeFaceListId))
  result = call_594104.call(path_594105, nil, nil, nil, nil)

var largeFaceListDelete* = Call_LargeFaceListDelete_594099(
    name: "largeFaceListDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListDelete_594100, base: "",
    url: url_LargeFaceListDelete_594101, schemes: {Scheme.Https})
type
  Call_LargeFaceListAddFaceFromUrl_594125 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListAddFaceFromUrl_594127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListAddFaceFromUrl_594126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a specified large face list, up to 1,000,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargeFaceList Face - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a158c8ad2de3616c086f2d4) or [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargeFaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## Quota:
  ## * Free-tier subscription quota: 1,000 faces per large face list.
  ## * S0-tier subscription quota: 1,000,000 faces per large face list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594128 = path.getOrDefault("largeFaceListId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "largeFaceListId", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_594129 = query.getOrDefault("userData")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "userData", valid_594129
  var valid_594130 = query.getOrDefault("detectionModel")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_594130 != nil:
    section.add "detectionModel", valid_594130
  var valid_594131 = query.getOrDefault("targetFace")
  valid_594131 = validateParameter(valid_594131, JArray, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "targetFace", valid_594131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_LargeFaceListAddFaceFromUrl_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a face to a specified large face list, up to 1,000,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargeFaceList Face - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a158c8ad2de3616c086f2d4) or [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargeFaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## Quota:
  ## * Free-tier subscription quota: 1,000 faces per large face list.
  ## * S0-tier subscription quota: 1,000,000 faces per large face list.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_LargeFaceListAddFaceFromUrl_594125;
          largeFaceListId: string; ImageUrl: JsonNode; userData: string = "";
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil): Recallable =
  ## largeFaceListAddFaceFromUrl
  ## Add a face to a specified large face list, up to 1,000,000 faces.
  ## <br /> To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargeFaceList Face - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a158c8ad2de3616c086f2d4) or [LargeFaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/5a1580d5d2de3616c086f2cd) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargeFaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/5a158c10d2de3616c086f2d3). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  ## Quota:
  ## * Free-tier subscription quota: 1,000 faces per large face list.
  ## * S0-tier subscription quota: 1,000,000 faces per large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(path_594135, "largeFaceListId", newJString(largeFaceListId))
  add(query_594136, "userData", newJString(userData))
  if ImageUrl != nil:
    body_594137 = ImageUrl
  add(query_594136, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_594136.add "targetFace", targetFace
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var largeFaceListAddFaceFromUrl* = Call_LargeFaceListAddFaceFromUrl_594125(
    name: "largeFaceListAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/persistedfaces",
    validator: validate_LargeFaceListAddFaceFromUrl_594126, base: "",
    url: url_LargeFaceListAddFaceFromUrl_594127, schemes: {Scheme.Https})
type
  Call_LargeFaceListListFaces_594115 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListListFaces_594117(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListListFaces_594116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594118 = path.getOrDefault("largeFaceListId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "largeFaceListId", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : Number of faces to return starting with the face id indicated by the 'start' parameter.
  ##   start: JString
  ##        : Starting face id to return (used to list a range of faces).
  section = newJObject()
  var valid_594119 = query.getOrDefault("top")
  valid_594119 = validateParameter(valid_594119, JInt, required = false, default = nil)
  if valid_594119 != nil:
    section.add "top", valid_594119
  var valid_594120 = query.getOrDefault("start")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "start", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_LargeFaceListListFaces_594115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_LargeFaceListListFaces_594115;
          largeFaceListId: string; top: int = 0; start: string = ""): Recallable =
  ## largeFaceListListFaces
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   top: int
  ##      : Number of faces to return starting with the face id indicated by the 'start' parameter.
  ##   start: string
  ##        : Starting face id to return (used to list a range of faces).
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  add(path_594123, "largeFaceListId", newJString(largeFaceListId))
  add(query_594124, "top", newJInt(top))
  add(query_594124, "start", newJString(start))
  result = call_594122.call(path_594123, query_594124, nil, nil, nil)

var largeFaceListListFaces* = Call_LargeFaceListListFaces_594115(
    name: "largeFaceListListFaces", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/persistedfaces",
    validator: validate_LargeFaceListListFaces_594116, base: "",
    url: url_LargeFaceListListFaces_594117, schemes: {Scheme.Https})
type
  Call_LargeFaceListGetFace_594138 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListGetFace_594140(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListGetFace_594139(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594141 = path.getOrDefault("largeFaceListId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "largeFaceListId", valid_594141
  var valid_594142 = path.getOrDefault("persistedFaceId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "persistedFaceId", valid_594142
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_LargeFaceListGetFace_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_LargeFaceListGetFace_594138; largeFaceListId: string;
          persistedFaceId: string): Recallable =
  ## largeFaceListGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_594145 = newJObject()
  add(path_594145, "largeFaceListId", newJString(largeFaceListId))
  add(path_594145, "persistedFaceId", newJString(persistedFaceId))
  result = call_594144.call(path_594145, nil, nil, nil, nil)

var largeFaceListGetFace* = Call_LargeFaceListGetFace_594138(
    name: "largeFaceListGetFace", meth: HttpMethod.HttpGet, host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListGetFace_594139, base: "",
    url: url_LargeFaceListGetFace_594140, schemes: {Scheme.Https})
type
  Call_LargeFaceListUpdateFace_594154 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListUpdateFace_594156(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListUpdateFace_594155(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a persisted face's userData field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594157 = path.getOrDefault("largeFaceListId")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "largeFaceListId", valid_594157
  var valid_594158 = path.getOrDefault("persistedFaceId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "persistedFaceId", valid_594158
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_LargeFaceListUpdateFace_594154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a persisted face's userData field.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_LargeFaceListUpdateFace_594154;
          largeFaceListId: string; persistedFaceId: string; body: JsonNode): Recallable =
  ## largeFaceListUpdateFace
  ## Update a persisted face's userData field.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_594162 = newJObject()
  var body_594163 = newJObject()
  add(path_594162, "largeFaceListId", newJString(largeFaceListId))
  add(path_594162, "persistedFaceId", newJString(persistedFaceId))
  if body != nil:
    body_594163 = body
  result = call_594161.call(path_594162, nil, nil, nil, body_594163)

var largeFaceListUpdateFace* = Call_LargeFaceListUpdateFace_594154(
    name: "largeFaceListUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListUpdateFace_594155, base: "",
    url: url_LargeFaceListUpdateFace_594156, schemes: {Scheme.Https})
type
  Call_LargeFaceListDeleteFace_594146 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListDeleteFace_594148(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListDeleteFace_594147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594149 = path.getOrDefault("largeFaceListId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "largeFaceListId", valid_594149
  var valid_594150 = path.getOrDefault("persistedFaceId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "persistedFaceId", valid_594150
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_LargeFaceListDeleteFace_594146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_LargeFaceListDeleteFace_594146;
          largeFaceListId: string; persistedFaceId: string): Recallable =
  ## largeFaceListDeleteFace
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_594153 = newJObject()
  add(path_594153, "largeFaceListId", newJString(largeFaceListId))
  add(path_594153, "persistedFaceId", newJString(persistedFaceId))
  result = call_594152.call(path_594153, nil, nil, nil, nil)

var largeFaceListDeleteFace* = Call_LargeFaceListDeleteFace_594146(
    name: "largeFaceListDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListDeleteFace_594147, base: "",
    url: url_LargeFaceListDeleteFace_594148, schemes: {Scheme.Https})
type
  Call_LargeFaceListTrain_594164 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListTrain_594166(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListTrain_594165(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Queue a large face list training task, the training task may not be started immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594167 = path.getOrDefault("largeFaceListId")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "largeFaceListId", valid_594167
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_LargeFaceListTrain_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a large face list training task, the training task may not be started immediately.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_LargeFaceListTrain_594164; largeFaceListId: string): Recallable =
  ## largeFaceListTrain
  ## Queue a large face list training task, the training task may not be started immediately.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_594170 = newJObject()
  add(path_594170, "largeFaceListId", newJString(largeFaceListId))
  result = call_594169.call(path_594170, nil, nil, nil, nil)

var largeFaceListTrain* = Call_LargeFaceListTrain_594164(
    name: "largeFaceListTrain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/train",
    validator: validate_LargeFaceListTrain_594165, base: "",
    url: url_LargeFaceListTrain_594166, schemes: {Scheme.Https})
type
  Call_LargeFaceListGetTrainingStatus_594171 = ref object of OpenApiRestCall_593439
proc url_LargeFaceListGetTrainingStatus_594173(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largeFaceListId" in path, "`largeFaceListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largefacelists/"),
               (kind: VariableSegment, value: "largeFaceListId"),
               (kind: ConstantSegment, value: "/training")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargeFaceListGetTrainingStatus_594172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the training status of a large face list (completed or ongoing).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largeFaceListId: JString (required)
  ##                  : Id referencing a particular large face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largeFaceListId` field"
  var valid_594174 = path.getOrDefault("largeFaceListId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "largeFaceListId", valid_594174
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594175: Call_LargeFaceListGetTrainingStatus_594171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the training status of a large face list (completed or ongoing).
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_LargeFaceListGetTrainingStatus_594171;
          largeFaceListId: string): Recallable =
  ## largeFaceListGetTrainingStatus
  ## Retrieve the training status of a large face list (completed or ongoing).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_594177 = newJObject()
  add(path_594177, "largeFaceListId", newJString(largeFaceListId))
  result = call_594176.call(path_594177, nil, nil, nil, nil)

var largeFaceListGetTrainingStatus* = Call_LargeFaceListGetTrainingStatus_594171(
    name: "largeFaceListGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/training",
    validator: validate_LargeFaceListGetTrainingStatus_594172, base: "",
    url: url_LargeFaceListGetTrainingStatus_594173, schemes: {Scheme.Https})
type
  Call_LargePersonGroupList_594178 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupList_594180(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LargePersonGroupList_594179(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all existing large person groups’ largePersonGroupId, name, userData and recognitionModel.<br />
  ## * Large person groups are stored in alphabetical order of largePersonGroupId.
  ## * "start" parameter (string, optional) is a user-provided largePersonGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : The number of large person groups to list.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: JString
  ##        : List large person groups from the least largePersonGroupId greater than the "start".
  section = newJObject()
  var valid_594182 = query.getOrDefault("top")
  valid_594182 = validateParameter(valid_594182, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594182 != nil:
    section.add "top", valid_594182
  var valid_594183 = query.getOrDefault("returnRecognitionModel")
  valid_594183 = validateParameter(valid_594183, JBool, required = false,
                                 default = newJBool(false))
  if valid_594183 != nil:
    section.add "returnRecognitionModel", valid_594183
  var valid_594184 = query.getOrDefault("start")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "start", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_LargePersonGroupList_594178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing large person groups’ largePersonGroupId, name, userData and recognitionModel.<br />
  ## * Large person groups are stored in alphabetical order of largePersonGroupId.
  ## * "start" parameter (string, optional) is a user-provided largePersonGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_LargePersonGroupList_594178; top: int = 1000;
          returnRecognitionModel: bool = false; start: string = ""): Recallable =
  ## largePersonGroupList
  ## List all existing large person groups’ largePersonGroupId, name, userData and recognitionModel.<br />
  ## * Large person groups are stored in alphabetical order of largePersonGroupId.
  ## * "start" parameter (string, optional) is a user-provided largePersonGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 large person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ##   top: int
  ##      : The number of large person groups to list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: string
  ##        : List large person groups from the least largePersonGroupId greater than the "start".
  var query_594187 = newJObject()
  add(query_594187, "top", newJInt(top))
  add(query_594187, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_594187, "start", newJString(start))
  result = call_594186.call(nil, query_594187, nil, nil, nil)

var largePersonGroupList* = Call_LargePersonGroupList_594178(
    name: "largePersonGroupList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largepersongroups", validator: validate_LargePersonGroupList_594179,
    base: "", url: url_LargePersonGroupList_594180, schemes: {Scheme.Https})
type
  Call_LargePersonGroupCreate_594197 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupCreate_594199(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupCreate_594198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new large person group with user-specified largePersonGroupId, name, an optional userData and recognitionModel.
  ## <br /> A large person group is the container of the uploaded person data, including face recognition feature, and up to 1,000,000
  ## people.
  ## <br /> After creation, use [LargePersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/599adcba3a7b9412a4d53f40) to add person into the group, and call [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br/>'recognitionModel' should be specified to associate with this large person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large person group will use the recognition model that's already associated with the collection. Existing face features in a large person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargePersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d). All those large person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large person group quota:
  ## * Free-tier subscription quota: 1,000 large person groups.
  ## * S0-tier subscription quota: 1,000,000 large person groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594200 = path.getOrDefault("largePersonGroupId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "largePersonGroupId", valid_594200
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new large person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_LargePersonGroupCreate_594197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new large person group with user-specified largePersonGroupId, name, an optional userData and recognitionModel.
  ## <br /> A large person group is the container of the uploaded person data, including face recognition feature, and up to 1,000,000
  ## people.
  ## <br /> After creation, use [LargePersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/599adcba3a7b9412a4d53f40) to add person into the group, and call [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br/>'recognitionModel' should be specified to associate with this large person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large person group will use the recognition model that's already associated with the collection. Existing face features in a large person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargePersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d). All those large person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large person group quota:
  ## * Free-tier subscription quota: 1,000 large person groups.
  ## * S0-tier subscription quota: 1,000,000 large person groups.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_LargePersonGroupCreate_594197;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupCreate
  ## Create a new large person group with user-specified largePersonGroupId, name, an optional userData and recognitionModel.
  ## <br /> A large person group is the container of the uploaded person data, including face recognition feature, and up to 1,000,000
  ## people.
  ## <br /> After creation, use [LargePersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/599adcba3a7b9412a4d53f40) to add person into the group, and call [LargePersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/599ae2d16ac60f11b48b5aa4) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br/>'recognitionModel' should be specified to associate with this large person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing large person group will use the recognition model that's already associated with the collection. Existing face features in a large person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [LargePersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d). All those large person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Large person group quota:
  ## * Free-tier subscription quota: 1,000 large person groups.
  ## * S0-tier subscription quota: 1,000,000 large person groups.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for creating new large person group.
  var path_594204 = newJObject()
  var body_594205 = newJObject()
  add(path_594204, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_594205 = body
  result = call_594203.call(path_594204, nil, nil, nil, body_594205)

var largePersonGroupCreate* = Call_LargePersonGroupCreate_594197(
    name: "largePersonGroupCreate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupCreate_594198, base: "",
    url: url_LargePersonGroupCreate_594199, schemes: {Scheme.Https})
type
  Call_LargePersonGroupGet_594188 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupGet_594190(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupGet_594189(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594191 = path.getOrDefault("largePersonGroupId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "largePersonGroupId", valid_594191
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_594192 = query.getOrDefault("returnRecognitionModel")
  valid_594192 = validateParameter(valid_594192, JBool, required = false,
                                 default = newJBool(false))
  if valid_594192 != nil:
    section.add "returnRecognitionModel", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_LargePersonGroupGet_594188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_LargePersonGroupGet_594188;
          largePersonGroupId: string; returnRecognitionModel: bool = false): Recallable =
  ## largePersonGroupGet
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(path_594195, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_594196, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var largePersonGroupGet* = Call_LargePersonGroupGet_594188(
    name: "largePersonGroupGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupGet_594189, base: "",
    url: url_LargePersonGroupGet_594190, schemes: {Scheme.Https})
type
  Call_LargePersonGroupUpdate_594213 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupUpdate_594215(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupUpdate_594214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594216 = path.getOrDefault("largePersonGroupId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "largePersonGroupId", valid_594216
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating large person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_LargePersonGroupUpdate_594213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_LargePersonGroupUpdate_594213;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupUpdate
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for updating large person group.
  var path_594220 = newJObject()
  var body_594221 = newJObject()
  add(path_594220, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_594221 = body
  result = call_594219.call(path_594220, nil, nil, nil, body_594221)

var largePersonGroupUpdate* = Call_LargePersonGroupUpdate_594213(
    name: "largePersonGroupUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupUpdate_594214, base: "",
    url: url_LargePersonGroupUpdate_594215, schemes: {Scheme.Https})
type
  Call_LargePersonGroupDelete_594206 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupDelete_594208(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupDelete_594207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594209 = path.getOrDefault("largePersonGroupId")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "largePersonGroupId", valid_594209
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_LargePersonGroupDelete_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_LargePersonGroupDelete_594206;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupDelete
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594212 = newJObject()
  add(path_594212, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594211.call(path_594212, nil, nil, nil, nil)

var largePersonGroupDelete* = Call_LargePersonGroupDelete_594206(
    name: "largePersonGroupDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupDelete_594207, base: "",
    url: url_LargePersonGroupDelete_594208, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonCreate_594232 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonCreate_594234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonCreate_594233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new person in a specified large person group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594235 = path.getOrDefault("largePersonGroupId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "largePersonGroupId", valid_594235
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594237: Call_LargePersonGroupPersonCreate_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person in a specified large person group.
  ## 
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_LargePersonGroupPersonCreate_594232;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupPersonCreate
  ## Create a new person in a specified large person group.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  var path_594239 = newJObject()
  var body_594240 = newJObject()
  add(path_594239, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_594240 = body
  result = call_594238.call(path_594239, nil, nil, nil, body_594240)

var largePersonGroupPersonCreate* = Call_LargePersonGroupPersonCreate_594232(
    name: "largePersonGroupPersonCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons",
    validator: validate_LargePersonGroupPersonCreate_594233, base: "",
    url: url_LargePersonGroupPersonCreate_594234, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonList_594222 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonList_594224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonList_594223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594225 = path.getOrDefault("largePersonGroupId")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "largePersonGroupId", valid_594225
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   start: JString
  ##        : Starting person id to return (used to list a range of persons).
  section = newJObject()
  var valid_594226 = query.getOrDefault("top")
  valid_594226 = validateParameter(valid_594226, JInt, required = false, default = nil)
  if valid_594226 != nil:
    section.add "top", valid_594226
  var valid_594227 = query.getOrDefault("start")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "start", valid_594227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_LargePersonGroupPersonList_594222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_LargePersonGroupPersonList_594222;
          largePersonGroupId: string; top: int = 0; start: string = ""): Recallable =
  ## largePersonGroupPersonList
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ##   top: int
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   start: string
  ##        : Starting person id to return (used to list a range of persons).
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(query_594231, "top", newJInt(top))
  add(path_594230, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_594231, "start", newJString(start))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var largePersonGroupPersonList* = Call_LargePersonGroupPersonList_594222(
    name: "largePersonGroupPersonList", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons",
    validator: validate_LargePersonGroupPersonList_594223, base: "",
    url: url_LargePersonGroupPersonList_594224, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonGet_594241 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonGet_594243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonGet_594242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_594244 = path.getOrDefault("personId")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "personId", valid_594244
  var valid_594245 = path.getOrDefault("largePersonGroupId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "largePersonGroupId", valid_594245
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_LargePersonGroupPersonGet_594241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_LargePersonGroupPersonGet_594241; personId: string;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonGet
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594248 = newJObject()
  add(path_594248, "personId", newJString(personId))
  add(path_594248, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594247.call(path_594248, nil, nil, nil, nil)

var largePersonGroupPersonGet* = Call_LargePersonGroupPersonGet_594241(
    name: "largePersonGroupPersonGet", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonGet_594242, base: "",
    url: url_LargePersonGroupPersonGet_594243, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonUpdate_594257 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonUpdate_594259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonUpdate_594258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update name or userData of a person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_594260 = path.getOrDefault("personId")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "personId", valid_594260
  var valid_594261 = path.getOrDefault("largePersonGroupId")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "largePersonGroupId", valid_594261
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_LargePersonGroupPersonUpdate_594257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update name or userData of a person.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_LargePersonGroupPersonUpdate_594257; personId: string;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupPersonUpdate
  ## Update name or userData of a person.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  var path_594265 = newJObject()
  var body_594266 = newJObject()
  add(path_594265, "personId", newJString(personId))
  add(path_594265, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_594266 = body
  result = call_594264.call(path_594265, nil, nil, nil, body_594266)

var largePersonGroupPersonUpdate* = Call_LargePersonGroupPersonUpdate_594257(
    name: "largePersonGroupPersonUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonUpdate_594258, base: "",
    url: url_LargePersonGroupPersonUpdate_594259, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonDelete_594249 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonDelete_594251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonDelete_594250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_594252 = path.getOrDefault("personId")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "personId", valid_594252
  var valid_594253 = path.getOrDefault("largePersonGroupId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "largePersonGroupId", valid_594253
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_LargePersonGroupPersonDelete_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_LargePersonGroupPersonDelete_594249; personId: string;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonDelete
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594256 = newJObject()
  add(path_594256, "personId", newJString(personId))
  add(path_594256, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594255.call(path_594256, nil, nil, nil, nil)

var largePersonGroupPersonDelete* = Call_LargePersonGroupPersonDelete_594249(
    name: "largePersonGroupPersonDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonDelete_594250, base: "",
    url: url_LargePersonGroupPersonDelete_594251, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonAddFaceFromUrl_594267 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonAddFaceFromUrl_594269(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonAddFaceFromUrl_594268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a person into a large person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargePersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ae2966ac60f11b48b5aa3), [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargePersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/599adf2a3a7b9412a4d53f42). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_594270 = path.getOrDefault("personId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "personId", valid_594270
  var valid_594271 = path.getOrDefault("largePersonGroupId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "largePersonGroupId", valid_594271
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_594272 = query.getOrDefault("userData")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "userData", valid_594272
  var valid_594273 = query.getOrDefault("detectionModel")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_594273 != nil:
    section.add "detectionModel", valid_594273
  var valid_594274 = query.getOrDefault("targetFace")
  valid_594274 = validateParameter(valid_594274, JArray, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "targetFace", valid_594274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594276: Call_LargePersonGroupPersonAddFaceFromUrl_594267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a face to a person into a large person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargePersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ae2966ac60f11b48b5aa3), [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargePersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/599adf2a3a7b9412a4d53f42). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  let valid = call_594276.validator(path, query, header, formData, body)
  let scheme = call_594276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594276.url(scheme.get, call_594276.host, call_594276.base,
                         call_594276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594276, url, valid)

proc call*(call_594277: Call_LargePersonGroupPersonAddFaceFromUrl_594267;
          personId: string; ImageUrl: JsonNode; largePersonGroupId: string;
          userData: string = ""; detectionModel: string = "detection_01";
          targetFace: JsonNode = nil): Recallable =
  ## largePersonGroupPersonAddFaceFromUrl
  ## Add a face to a person into a large person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [LargePersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ae2966ac60f11b48b5aa3), [LargePersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599ade5c6ac60f11b48b5aa2) or [LargePersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/599adc216ac60f11b48b5a9f) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [LargePersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/599adf2a3a7b9412a4d53f42). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_594278 = newJObject()
  var query_594279 = newJObject()
  var body_594280 = newJObject()
  add(path_594278, "personId", newJString(personId))
  add(query_594279, "userData", newJString(userData))
  if ImageUrl != nil:
    body_594280 = ImageUrl
  add(query_594279, "detectionModel", newJString(detectionModel))
  add(path_594278, "largePersonGroupId", newJString(largePersonGroupId))
  if targetFace != nil:
    query_594279.add "targetFace", targetFace
  result = call_594277.call(path_594278, query_594279, nil, nil, body_594280)

var largePersonGroupPersonAddFaceFromUrl* = Call_LargePersonGroupPersonAddFaceFromUrl_594267(
    name: "largePersonGroupPersonAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces",
    validator: validate_LargePersonGroupPersonAddFaceFromUrl_594268, base: "",
    url: url_LargePersonGroupPersonAddFaceFromUrl_594269, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonGetFace_594281 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonGetFace_594283(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonGetFace_594282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_594284 = path.getOrDefault("persistedFaceId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "persistedFaceId", valid_594284
  var valid_594285 = path.getOrDefault("personId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "personId", valid_594285
  var valid_594286 = path.getOrDefault("largePersonGroupId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "largePersonGroupId", valid_594286
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594287: Call_LargePersonGroupPersonGetFace_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ## 
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_LargePersonGroupPersonGetFace_594281;
          persistedFaceId: string; personId: string; largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594289 = newJObject()
  add(path_594289, "persistedFaceId", newJString(persistedFaceId))
  add(path_594289, "personId", newJString(personId))
  add(path_594289, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594288.call(path_594289, nil, nil, nil, nil)

var largePersonGroupPersonGetFace* = Call_LargePersonGroupPersonGetFace_594281(
    name: "largePersonGroupPersonGetFace", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonGetFace_594282, base: "",
    url: url_LargePersonGroupPersonGetFace_594283, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonUpdateFace_594299 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonUpdateFace_594301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonUpdateFace_594300(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a person persisted face's userData field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_594302 = path.getOrDefault("persistedFaceId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "persistedFaceId", valid_594302
  var valid_594303 = path.getOrDefault("personId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "personId", valid_594303
  var valid_594304 = path.getOrDefault("largePersonGroupId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "largePersonGroupId", valid_594304
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594306: Call_LargePersonGroupPersonUpdateFace_594299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a person persisted face's userData field.
  ## 
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_LargePersonGroupPersonUpdateFace_594299;
          persistedFaceId: string; personId: string; largePersonGroupId: string;
          body: JsonNode): Recallable =
  ## largePersonGroupPersonUpdateFace
  ## Update a person persisted face's userData field.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_594308 = newJObject()
  var body_594309 = newJObject()
  add(path_594308, "persistedFaceId", newJString(persistedFaceId))
  add(path_594308, "personId", newJString(personId))
  add(path_594308, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_594309 = body
  result = call_594307.call(path_594308, nil, nil, nil, body_594309)

var largePersonGroupPersonUpdateFace* = Call_LargePersonGroupPersonUpdateFace_594299(
    name: "largePersonGroupPersonUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonUpdateFace_594300, base: "",
    url: url_LargePersonGroupPersonUpdateFace_594301, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonDeleteFace_594290 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupPersonDeleteFace_594292(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupPersonDeleteFace_594291(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_594293 = path.getOrDefault("persistedFaceId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "persistedFaceId", valid_594293
  var valid_594294 = path.getOrDefault("personId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "personId", valid_594294
  var valid_594295 = path.getOrDefault("largePersonGroupId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "largePersonGroupId", valid_594295
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_LargePersonGroupPersonDeleteFace_594290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_LargePersonGroupPersonDeleteFace_594290;
          persistedFaceId: string; personId: string; largePersonGroupId: string): Recallable =
  ## largePersonGroupPersonDeleteFace
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594298 = newJObject()
  add(path_594298, "persistedFaceId", newJString(persistedFaceId))
  add(path_594298, "personId", newJString(personId))
  add(path_594298, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594297.call(path_594298, nil, nil, nil, nil)

var largePersonGroupPersonDeleteFace* = Call_LargePersonGroupPersonDeleteFace_594290(
    name: "largePersonGroupPersonDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonDeleteFace_594291, base: "",
    url: url_LargePersonGroupPersonDeleteFace_594292, schemes: {Scheme.Https})
type
  Call_LargePersonGroupTrain_594310 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupTrain_594312(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupTrain_594311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queue a large person group training task, the training task may not be started immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594313 = path.getOrDefault("largePersonGroupId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "largePersonGroupId", valid_594313
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594314: Call_LargePersonGroupTrain_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a large person group training task, the training task may not be started immediately.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_LargePersonGroupTrain_594310;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupTrain
  ## Queue a large person group training task, the training task may not be started immediately.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594316 = newJObject()
  add(path_594316, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594315.call(path_594316, nil, nil, nil, nil)

var largePersonGroupTrain* = Call_LargePersonGroupTrain_594310(
    name: "largePersonGroupTrain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/train",
    validator: validate_LargePersonGroupTrain_594311, base: "",
    url: url_LargePersonGroupTrain_594312, schemes: {Scheme.Https})
type
  Call_LargePersonGroupGetTrainingStatus_594317 = ref object of OpenApiRestCall_593439
proc url_LargePersonGroupGetTrainingStatus_594319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "largePersonGroupId" in path,
        "`largePersonGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/largepersongroups/"),
               (kind: VariableSegment, value: "largePersonGroupId"),
               (kind: ConstantSegment, value: "/training")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LargePersonGroupGetTrainingStatus_594318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the training status of a large person group (completed or ongoing).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_594320 = path.getOrDefault("largePersonGroupId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "largePersonGroupId", valid_594320
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_LargePersonGroupGetTrainingStatus_594317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the training status of a large person group (completed or ongoing).
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_LargePersonGroupGetTrainingStatus_594317;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupGetTrainingStatus
  ## Retrieve the training status of a large person group (completed or ongoing).
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_594323 = newJObject()
  add(path_594323, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_594322.call(path_594323, nil, nil, nil, nil)

var largePersonGroupGetTrainingStatus* = Call_LargePersonGroupGetTrainingStatus_594317(
    name: "largePersonGroupGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/training",
    validator: validate_LargePersonGroupGetTrainingStatus_594318, base: "",
    url: url_LargePersonGroupGetTrainingStatus_594319, schemes: {Scheme.Https})
type
  Call_SnapshotGetOperationStatus_594324 = ref object of OpenApiRestCall_593439
proc url_SnapshotGetOperationStatus_594326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotGetOperationStatus_594325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the status of a take/apply snapshot operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Id referencing a particular take/apply snapshot operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_594327 = path.getOrDefault("operationId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "operationId", valid_594327
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594328: Call_SnapshotGetOperationStatus_594324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the status of a take/apply snapshot operation.
  ## 
  let valid = call_594328.validator(path, query, header, formData, body)
  let scheme = call_594328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594328.url(scheme.get, call_594328.host, call_594328.base,
                         call_594328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594328, url, valid)

proc call*(call_594329: Call_SnapshotGetOperationStatus_594324; operationId: string): Recallable =
  ## snapshotGetOperationStatus
  ## Retrieve the status of a take/apply snapshot operation.
  ##   operationId: string (required)
  ##              : Id referencing a particular take/apply snapshot operation.
  var path_594330 = newJObject()
  add(path_594330, "operationId", newJString(operationId))
  result = call_594329.call(path_594330, nil, nil, nil, nil)

var snapshotGetOperationStatus* = Call_SnapshotGetOperationStatus_594324(
    name: "snapshotGetOperationStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/operations/{operationId}",
    validator: validate_SnapshotGetOperationStatus_594325, base: "",
    url: url_SnapshotGetOperationStatus_594326, schemes: {Scheme.Https})
type
  Call_PersonGroupList_594331 = ref object of OpenApiRestCall_593439
proc url_PersonGroupList_594333(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PersonGroupList_594332(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List person groups’ personGroupId, name, userData and recognitionModel.<br />
  ## * Person groups are stored in alphabetical order of personGroupId.
  ## * "start" parameter (string, optional) is a user-provided personGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : The number of person groups to list.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: JString
  ##        : List person groups from the least personGroupId greater than the "start".
  section = newJObject()
  var valid_594334 = query.getOrDefault("top")
  valid_594334 = validateParameter(valid_594334, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594334 != nil:
    section.add "top", valid_594334
  var valid_594335 = query.getOrDefault("returnRecognitionModel")
  valid_594335 = validateParameter(valid_594335, JBool, required = false,
                                 default = newJBool(false))
  if valid_594335 != nil:
    section.add "returnRecognitionModel", valid_594335
  var valid_594336 = query.getOrDefault("start")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "start", valid_594336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594337: Call_PersonGroupList_594331; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List person groups’ personGroupId, name, userData and recognitionModel.<br />
  ## * Person groups are stored in alphabetical order of personGroupId.
  ## * "start" parameter (string, optional) is a user-provided personGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ## 
  let valid = call_594337.validator(path, query, header, formData, body)
  let scheme = call_594337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594337.url(scheme.get, call_594337.host, call_594337.base,
                         call_594337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594337, url, valid)

proc call*(call_594338: Call_PersonGroupList_594331; top: int = 1000;
          returnRecognitionModel: bool = false; start: string = ""): Recallable =
  ## personGroupList
  ## List person groups’ personGroupId, name, userData and recognitionModel.<br />
  ## * Person groups are stored in alphabetical order of personGroupId.
  ## * "start" parameter (string, optional) is a user-provided personGroupId value that returned entries have larger ids by string comparison. "start" set to empty to indicate return from the first item.
  ## * "top" parameter (int, optional) specifies the number of entries to return. A maximal of 1000 entries can be returned in one call. To fetch more, you can specify "start" with the last returned entry’s Id of the current call.
  ## <br />
  ## For example, total 5 person groups: "group1", ..., "group5".
  ## <br /> "start=&top=" will return all 5 groups.
  ## <br /> "start=&top=2" will return "group1", "group2".
  ## <br /> "start=group2&top=3" will return "group3", "group4", "group5".
  ## 
  ##   top: int
  ##      : The number of person groups to list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: string
  ##        : List person groups from the least personGroupId greater than the "start".
  var query_594339 = newJObject()
  add(query_594339, "top", newJInt(top))
  add(query_594339, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_594339, "start", newJString(start))
  result = call_594338.call(nil, query_594339, nil, nil, nil)

var personGroupList* = Call_PersonGroupList_594331(name: "personGroupList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/persongroups",
    validator: validate_PersonGroupList_594332, base: "", url: url_PersonGroupList_594333,
    schemes: {Scheme.Https})
type
  Call_PersonGroupCreate_594349 = ref object of OpenApiRestCall_593439
proc url_PersonGroupCreate_594351(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupCreate_594350(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new person group with specified personGroupId, name, user-provided userData and recognitionModel.
  ## <br /> A person group is the container of the uploaded person data, including face recognition features.
  ## <br /> After creation, use [PersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c) to add persons into the group, and then call [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br/>'recognitionModel' should be specified to associate with this person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing person group will use the recognition model that's already associated with the collection. Existing face features in a person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [PersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244). All those person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Person group quota:
  ## * Free-tier subscription quota: 1,000 person groups. Each holds up to 1,000 persons.
  ## * S0-tier subscription quota: 1,000,000 person groups. Each holds up to 10,000 persons.
  ## * to handle larger scale face identification problem, please consider using [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594352 = path.getOrDefault("personGroupId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "personGroupId", valid_594352
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_PersonGroupCreate_594349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person group with specified personGroupId, name, user-provided userData and recognitionModel.
  ## <br /> A person group is the container of the uploaded person data, including face recognition features.
  ## <br /> After creation, use [PersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c) to add persons into the group, and then call [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br/>'recognitionModel' should be specified to associate with this person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing person group will use the recognition model that's already associated with the collection. Existing face features in a person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [PersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244). All those person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Person group quota:
  ## * Free-tier subscription quota: 1,000 person groups. Each holds up to 1,000 persons.
  ## * S0-tier subscription quota: 1,000,000 person groups. Each holds up to 10,000 persons.
  ## * to handle larger scale face identification problem, please consider using [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d).
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_PersonGroupCreate_594349; personGroupId: string;
          body: JsonNode): Recallable =
  ## personGroupCreate
  ## Create a new person group with specified personGroupId, name, user-provided userData and recognitionModel.
  ## <br /> A person group is the container of the uploaded person data, including face recognition features.
  ## <br /> After creation, use [PersonGroup Person - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523c) to add persons into the group, and then call [PersonGroup - Train](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395249) to get this group ready for [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> No image will be stored. Only the person's extracted face features and userData will be stored on server until [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br/>'recognitionModel' should be specified to associate with this person group. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing person group will use the recognition model that's already associated with the collection. Existing face features in a person group can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [PersonGroup - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244). All those person groups created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ## 
  ## Person group quota:
  ## * Free-tier subscription quota: 1,000 person groups. Each holds up to 1,000 persons.
  ## * S0-tier subscription quota: 1,000,000 person groups. Each holds up to 10,000 persons.
  ## * to handle larger scale face identification problem, please consider using [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person group.
  var path_594356 = newJObject()
  var body_594357 = newJObject()
  add(path_594356, "personGroupId", newJString(personGroupId))
  if body != nil:
    body_594357 = body
  result = call_594355.call(path_594356, nil, nil, nil, body_594357)

var personGroupCreate* = Call_PersonGroupCreate_594349(name: "personGroupCreate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupCreate_594350,
    base: "", url: url_PersonGroupCreate_594351, schemes: {Scheme.Https})
type
  Call_PersonGroupGet_594340 = ref object of OpenApiRestCall_593439
proc url_PersonGroupGet_594342(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupGet_594341(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594343 = path.getOrDefault("personGroupId")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "personGroupId", valid_594343
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_594344 = query.getOrDefault("returnRecognitionModel")
  valid_594344 = validateParameter(valid_594344, JBool, required = false,
                                 default = newJBool(false))
  if valid_594344 != nil:
    section.add "returnRecognitionModel", valid_594344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594345: Call_PersonGroupGet_594340; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ## 
  let valid = call_594345.validator(path, query, header, formData, body)
  let scheme = call_594345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594345.url(scheme.get, call_594345.host, call_594345.base,
                         call_594345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594345, url, valid)

proc call*(call_594346: Call_PersonGroupGet_594340; personGroupId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## personGroupGet
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_594347 = newJObject()
  var query_594348 = newJObject()
  add(path_594347, "personGroupId", newJString(personGroupId))
  add(query_594348, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_594346.call(path_594347, query_594348, nil, nil, nil)

var personGroupGet* = Call_PersonGroupGet_594340(name: "personGroupGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupGet_594341,
    base: "", url: url_PersonGroupGet_594342, schemes: {Scheme.Https})
type
  Call_PersonGroupUpdate_594365 = ref object of OpenApiRestCall_593439
proc url_PersonGroupUpdate_594367(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupUpdate_594366(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594368 = path.getOrDefault("personGroupId")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "personGroupId", valid_594368
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating person group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594370: Call_PersonGroupUpdate_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_PersonGroupUpdate_594365; personGroupId: string;
          body: JsonNode): Recallable =
  ## personGroupUpdate
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   body: JObject (required)
  ##       : Request body for updating person group.
  var path_594372 = newJObject()
  var body_594373 = newJObject()
  add(path_594372, "personGroupId", newJString(personGroupId))
  if body != nil:
    body_594373 = body
  result = call_594371.call(path_594372, nil, nil, nil, body_594373)

var personGroupUpdate* = Call_PersonGroupUpdate_594365(name: "personGroupUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupUpdate_594366,
    base: "", url: url_PersonGroupUpdate_594367, schemes: {Scheme.Https})
type
  Call_PersonGroupDelete_594358 = ref object of OpenApiRestCall_593439
proc url_PersonGroupDelete_594360(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupDelete_594359(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594361 = path.getOrDefault("personGroupId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "personGroupId", valid_594361
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594362: Call_PersonGroupDelete_594358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ## 
  let valid = call_594362.validator(path, query, header, formData, body)
  let scheme = call_594362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594362.url(scheme.get, call_594362.host, call_594362.base,
                         call_594362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594362, url, valid)

proc call*(call_594363: Call_PersonGroupDelete_594358; personGroupId: string): Recallable =
  ## personGroupDelete
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_594364 = newJObject()
  add(path_594364, "personGroupId", newJString(personGroupId))
  result = call_594363.call(path_594364, nil, nil, nil, nil)

var personGroupDelete* = Call_PersonGroupDelete_594358(name: "personGroupDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupDelete_594359,
    base: "", url: url_PersonGroupDelete_594360, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonCreate_594384 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonCreate_594386(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonCreate_594385(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new person in a specified person group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594387 = path.getOrDefault("personGroupId")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "personGroupId", valid_594387
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594389: Call_PersonGroupPersonCreate_594384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person in a specified person group.
  ## 
  let valid = call_594389.validator(path, query, header, formData, body)
  let scheme = call_594389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594389.url(scheme.get, call_594389.host, call_594389.base,
                         call_594389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594389, url, valid)

proc call*(call_594390: Call_PersonGroupPersonCreate_594384; personGroupId: string;
          body: JsonNode): Recallable =
  ## personGroupPersonCreate
  ## Create a new person in a specified person group.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  var path_594391 = newJObject()
  var body_594392 = newJObject()
  add(path_594391, "personGroupId", newJString(personGroupId))
  if body != nil:
    body_594392 = body
  result = call_594390.call(path_594391, nil, nil, nil, body_594392)

var personGroupPersonCreate* = Call_PersonGroupPersonCreate_594384(
    name: "personGroupPersonCreate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons",
    validator: validate_PersonGroupPersonCreate_594385, base: "",
    url: url_PersonGroupPersonCreate_594386, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonList_594374 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonList_594376(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonList_594375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594377 = path.getOrDefault("personGroupId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "personGroupId", valid_594377
  result.add "path", section
  ## parameters in `query` object:
  ##   top: JInt
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   start: JString
  ##        : Starting person id to return (used to list a range of persons).
  section = newJObject()
  var valid_594378 = query.getOrDefault("top")
  valid_594378 = validateParameter(valid_594378, JInt, required = false, default = nil)
  if valid_594378 != nil:
    section.add "top", valid_594378
  var valid_594379 = query.getOrDefault("start")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "start", valid_594379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594380: Call_PersonGroupPersonList_594374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  let valid = call_594380.validator(path, query, header, formData, body)
  let scheme = call_594380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594380.url(scheme.get, call_594380.host, call_594380.base,
                         call_594380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594380, url, valid)

proc call*(call_594381: Call_PersonGroupPersonList_594374; personGroupId: string;
          top: int = 0; start: string = ""): Recallable =
  ## personGroupPersonList
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   top: int
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   start: string
  ##        : Starting person id to return (used to list a range of persons).
  var path_594382 = newJObject()
  var query_594383 = newJObject()
  add(path_594382, "personGroupId", newJString(personGroupId))
  add(query_594383, "top", newJInt(top))
  add(query_594383, "start", newJString(start))
  result = call_594381.call(path_594382, query_594383, nil, nil, nil)

var personGroupPersonList* = Call_PersonGroupPersonList_594374(
    name: "personGroupPersonList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons",
    validator: validate_PersonGroupPersonList_594375, base: "",
    url: url_PersonGroupPersonList_594376, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonGet_594393 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonGet_594395(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonGet_594394(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594396 = path.getOrDefault("personGroupId")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "personGroupId", valid_594396
  var valid_594397 = path.getOrDefault("personId")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "personId", valid_594397
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594398: Call_PersonGroupPersonGet_594393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ## 
  let valid = call_594398.validator(path, query, header, formData, body)
  let scheme = call_594398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594398.url(scheme.get, call_594398.host, call_594398.base,
                         call_594398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594398, url, valid)

proc call*(call_594399: Call_PersonGroupPersonGet_594393; personGroupId: string;
          personId: string): Recallable =
  ## personGroupPersonGet
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_594400 = newJObject()
  add(path_594400, "personGroupId", newJString(personGroupId))
  add(path_594400, "personId", newJString(personId))
  result = call_594399.call(path_594400, nil, nil, nil, nil)

var personGroupPersonGet* = Call_PersonGroupPersonGet_594393(
    name: "personGroupPersonGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonGet_594394, base: "",
    url: url_PersonGroupPersonGet_594395, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonUpdate_594409 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonUpdate_594411(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonUpdate_594410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update name or userData of a person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594412 = path.getOrDefault("personGroupId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "personGroupId", valid_594412
  var valid_594413 = path.getOrDefault("personId")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "personId", valid_594413
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594415: Call_PersonGroupPersonUpdate_594409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update name or userData of a person.
  ## 
  let valid = call_594415.validator(path, query, header, formData, body)
  let scheme = call_594415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594415.url(scheme.get, call_594415.host, call_594415.base,
                         call_594415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594415, url, valid)

proc call*(call_594416: Call_PersonGroupPersonUpdate_594409; personGroupId: string;
          personId: string; body: JsonNode): Recallable =
  ## personGroupPersonUpdate
  ## Update name or userData of a person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  var path_594417 = newJObject()
  var body_594418 = newJObject()
  add(path_594417, "personGroupId", newJString(personGroupId))
  add(path_594417, "personId", newJString(personId))
  if body != nil:
    body_594418 = body
  result = call_594416.call(path_594417, nil, nil, nil, body_594418)

var personGroupPersonUpdate* = Call_PersonGroupPersonUpdate_594409(
    name: "personGroupPersonUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonUpdate_594410, base: "",
    url: url_PersonGroupPersonUpdate_594411, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonDelete_594401 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonDelete_594403(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonDelete_594402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594404 = path.getOrDefault("personGroupId")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "personGroupId", valid_594404
  var valid_594405 = path.getOrDefault("personId")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "personId", valid_594405
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594406: Call_PersonGroupPersonDelete_594401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  let valid = call_594406.validator(path, query, header, formData, body)
  let scheme = call_594406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594406.url(scheme.get, call_594406.host, call_594406.base,
                         call_594406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594406, url, valid)

proc call*(call_594407: Call_PersonGroupPersonDelete_594401; personGroupId: string;
          personId: string): Recallable =
  ## personGroupPersonDelete
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_594408 = newJObject()
  add(path_594408, "personGroupId", newJString(personGroupId))
  add(path_594408, "personId", newJString(personId))
  result = call_594407.call(path_594408, nil, nil, nil, nil)

var personGroupPersonDelete* = Call_PersonGroupPersonDelete_594401(
    name: "personGroupPersonDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonDelete_594402, base: "",
    url: url_PersonGroupPersonDelete_594403, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonAddFaceFromUrl_594419 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonAddFaceFromUrl_594421(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonAddFaceFromUrl_594420(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## *   Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## *   Each person entry can hold up to 248 faces.
  ## *   JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## *   "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## *   Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## *   Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [PersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523b). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594422 = path.getOrDefault("personGroupId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "personGroupId", valid_594422
  var valid_594423 = path.getOrDefault("personId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "personId", valid_594423
  result.add "path", section
  ## parameters in `query` object:
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  section = newJObject()
  var valid_594424 = query.getOrDefault("userData")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "userData", valid_594424
  var valid_594425 = query.getOrDefault("detectionModel")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_594425 != nil:
    section.add "detectionModel", valid_594425
  var valid_594426 = query.getOrDefault("targetFace")
  valid_594426 = validateParameter(valid_594426, JArray, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "targetFace", valid_594426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594428: Call_PersonGroupPersonAddFaceFromUrl_594419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## *   Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## *   Each person entry can hold up to 248 faces.
  ## *   JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## *   "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## *   Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## *   Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [PersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523b). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ## 
  let valid = call_594428.validator(path, query, header, formData, body)
  let scheme = call_594428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594428.url(scheme.get, call_594428.host, call_594428.base,
                         call_594428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594428, url, valid)

proc call*(call_594429: Call_PersonGroupPersonAddFaceFromUrl_594419;
          personGroupId: string; personId: string; ImageUrl: JsonNode;
          userData: string = ""; detectionModel: string = "detection_01";
          targetFace: JsonNode = nil): Recallable =
  ## personGroupPersonAddFaceFromUrl
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## *   Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## *   Each person entry can hold up to 248 faces.
  ## *   JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## *   "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## *   Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## *   Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## * The minimum detectable face size is 36x36 pixels in an image no larger than 1920x1080 pixels. Images with dimensions higher than 1920x1080 pixels will need a proportionally larger minimum face size.
  ## * Different 'detectionModel' values can be provided. To use and compare different detection models, please refer to [How to specify a detection model](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-api-how-to-topics/specify-detection-model)
  ##   | Model | Recommended use-case(s) |
  ##   | ---------- | -------- |
  ##   | 'detection_01': | The default detection model for [PersonGroup Person - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523b). Recommend for near frontal face detection. For scenarios with exceptionally large angle (head-pose) faces, occluded faces or wrong image orientation, the faces in such cases may not be detected. |
  ##   | 'detection_02': | Detection model released in 2019 May with improved accuracy especially on small, side and blurry faces. |
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  var path_594430 = newJObject()
  var query_594431 = newJObject()
  var body_594432 = newJObject()
  add(path_594430, "personGroupId", newJString(personGroupId))
  add(path_594430, "personId", newJString(personId))
  add(query_594431, "userData", newJString(userData))
  if ImageUrl != nil:
    body_594432 = ImageUrl
  add(query_594431, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_594431.add "targetFace", targetFace
  result = call_594429.call(path_594430, query_594431, nil, nil, body_594432)

var personGroupPersonAddFaceFromUrl* = Call_PersonGroupPersonAddFaceFromUrl_594419(
    name: "personGroupPersonAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces",
    validator: validate_PersonGroupPersonAddFaceFromUrl_594420, base: "",
    url: url_PersonGroupPersonAddFaceFromUrl_594421, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonGetFace_594433 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonGetFace_594435(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonGetFace_594434(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594436 = path.getOrDefault("personGroupId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "personGroupId", valid_594436
  var valid_594437 = path.getOrDefault("persistedFaceId")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "persistedFaceId", valid_594437
  var valid_594438 = path.getOrDefault("personId")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "personId", valid_594438
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594439: Call_PersonGroupPersonGetFace_594433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ## 
  let valid = call_594439.validator(path, query, header, formData, body)
  let scheme = call_594439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594439.url(scheme.get, call_594439.host, call_594439.base,
                         call_594439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594439, url, valid)

proc call*(call_594440: Call_PersonGroupPersonGetFace_594433;
          personGroupId: string; persistedFaceId: string; personId: string): Recallable =
  ## personGroupPersonGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_594441 = newJObject()
  add(path_594441, "personGroupId", newJString(personGroupId))
  add(path_594441, "persistedFaceId", newJString(persistedFaceId))
  add(path_594441, "personId", newJString(personId))
  result = call_594440.call(path_594441, nil, nil, nil, nil)

var personGroupPersonGetFace* = Call_PersonGroupPersonGetFace_594433(
    name: "personGroupPersonGetFace", meth: HttpMethod.HttpGet, host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonGetFace_594434, base: "",
    url: url_PersonGroupPersonGetFace_594435, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonUpdateFace_594451 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonUpdateFace_594453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonUpdateFace_594452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594454 = path.getOrDefault("personGroupId")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "personGroupId", valid_594454
  var valid_594455 = path.getOrDefault("persistedFaceId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "persistedFaceId", valid_594455
  var valid_594456 = path.getOrDefault("personId")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "personId", valid_594456
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594458: Call_PersonGroupPersonUpdateFace_594451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_594458.validator(path, query, header, formData, body)
  let scheme = call_594458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594458.url(scheme.get, call_594458.host, call_594458.base,
                         call_594458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594458, url, valid)

proc call*(call_594459: Call_PersonGroupPersonUpdateFace_594451;
          personGroupId: string; persistedFaceId: string; personId: string;
          body: JsonNode): Recallable =
  ## personGroupPersonUpdateFace
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_594460 = newJObject()
  var body_594461 = newJObject()
  add(path_594460, "personGroupId", newJString(personGroupId))
  add(path_594460, "persistedFaceId", newJString(persistedFaceId))
  add(path_594460, "personId", newJString(personId))
  if body != nil:
    body_594461 = body
  result = call_594459.call(path_594460, nil, nil, nil, body_594461)

var personGroupPersonUpdateFace* = Call_PersonGroupPersonUpdateFace_594451(
    name: "personGroupPersonUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonUpdateFace_594452, base: "",
    url: url_PersonGroupPersonUpdateFace_594453, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonDeleteFace_594442 = ref object of OpenApiRestCall_593439
proc url_PersonGroupPersonDeleteFace_594444(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  assert "personId" in path, "`personId` is a required path parameter"
  assert "persistedFaceId" in path, "`persistedFaceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/persons/"),
               (kind: VariableSegment, value: "personId"),
               (kind: ConstantSegment, value: "/persistedfaces/"),
               (kind: VariableSegment, value: "persistedFaceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupPersonDeleteFace_594443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594445 = path.getOrDefault("personGroupId")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "personGroupId", valid_594445
  var valid_594446 = path.getOrDefault("persistedFaceId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "persistedFaceId", valid_594446
  var valid_594447 = path.getOrDefault("personId")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "personId", valid_594447
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594448: Call_PersonGroupPersonDeleteFace_594442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_594448.validator(path, query, header, formData, body)
  let scheme = call_594448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594448.url(scheme.get, call_594448.host, call_594448.base,
                         call_594448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594448, url, valid)

proc call*(call_594449: Call_PersonGroupPersonDeleteFace_594442;
          personGroupId: string; persistedFaceId: string; personId: string): Recallable =
  ## personGroupPersonDeleteFace
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_594450 = newJObject()
  add(path_594450, "personGroupId", newJString(personGroupId))
  add(path_594450, "persistedFaceId", newJString(persistedFaceId))
  add(path_594450, "personId", newJString(personId))
  result = call_594449.call(path_594450, nil, nil, nil, nil)

var personGroupPersonDeleteFace* = Call_PersonGroupPersonDeleteFace_594442(
    name: "personGroupPersonDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonDeleteFace_594443, base: "",
    url: url_PersonGroupPersonDeleteFace_594444, schemes: {Scheme.Https})
type
  Call_PersonGroupTrain_594462 = ref object of OpenApiRestCall_593439
proc url_PersonGroupTrain_594464(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupTrain_594463(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Queue a person group training task, the training task may not be started immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594465 = path.getOrDefault("personGroupId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "personGroupId", valid_594465
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594466: Call_PersonGroupTrain_594462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a person group training task, the training task may not be started immediately.
  ## 
  let valid = call_594466.validator(path, query, header, formData, body)
  let scheme = call_594466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594466.url(scheme.get, call_594466.host, call_594466.base,
                         call_594466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594466, url, valid)

proc call*(call_594467: Call_PersonGroupTrain_594462; personGroupId: string): Recallable =
  ## personGroupTrain
  ## Queue a person group training task, the training task may not be started immediately.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_594468 = newJObject()
  add(path_594468, "personGroupId", newJString(personGroupId))
  result = call_594467.call(path_594468, nil, nil, nil, nil)

var personGroupTrain* = Call_PersonGroupTrain_594462(name: "personGroupTrain",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/persongroups/{personGroupId}/train",
    validator: validate_PersonGroupTrain_594463, base: "",
    url: url_PersonGroupTrain_594464, schemes: {Scheme.Https})
type
  Call_PersonGroupGetTrainingStatus_594469 = ref object of OpenApiRestCall_593439
proc url_PersonGroupGetTrainingStatus_594471(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "personGroupId" in path, "`personGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/persongroups/"),
               (kind: VariableSegment, value: "personGroupId"),
               (kind: ConstantSegment, value: "/training")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PersonGroupGetTrainingStatus_594470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the training status of a person group (completed or ongoing).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `personGroupId` field"
  var valid_594472 = path.getOrDefault("personGroupId")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "personGroupId", valid_594472
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_PersonGroupGetTrainingStatus_594469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the training status of a person group (completed or ongoing).
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_PersonGroupGetTrainingStatus_594469;
          personGroupId: string): Recallable =
  ## personGroupGetTrainingStatus
  ## Retrieve the training status of a person group (completed or ongoing).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_594475 = newJObject()
  add(path_594475, "personGroupId", newJString(personGroupId))
  result = call_594474.call(path_594475, nil, nil, nil, nil)

var personGroupGetTrainingStatus* = Call_PersonGroupGetTrainingStatus_594469(
    name: "personGroupGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/persongroups/{personGroupId}/training",
    validator: validate_PersonGroupGetTrainingStatus_594470, base: "",
    url: url_PersonGroupGetTrainingStatus_594471, schemes: {Scheme.Https})
type
  Call_SnapshotTake_594484 = ref object of OpenApiRestCall_593439
proc url_SnapshotTake_594486(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SnapshotTake_594485(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit an operation to take a snapshot of face list, large face list, person group or large person group, with user-specified snapshot type, source object id, apply scope and an optional user data.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Taking snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of creating the snapshot. The snapshot id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot taking time depends on the number of person and face entries in the source object. It could be in seconds, or up to several hours for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. User can delete the snapshot using Snapshot - Delete by themselves any time before expiration.<br />
  ## Taking snapshot for a certain object will not block any other operations against the object. All read-only operations (Get/List and Identify/FindSimilar/Verify) can be conducted as usual. For all writable operations, including Add/Update/Delete the source object or its persons/faces and Train, they are not blocked but not recommended because writable updates may not be reflected on the snapshot during its taking. After snapshot taking is completed, all readable and writable operations can work as normal. Snapshot will also include the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## * Free-tier subscription quota: 100 take operations per month.
  ## * S0-tier subscription quota: 100 take operations per day.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for taking a snapshot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594488: Call_SnapshotTake_594484; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit an operation to take a snapshot of face list, large face list, person group or large person group, with user-specified snapshot type, source object id, apply scope and an optional user data.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Taking snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of creating the snapshot. The snapshot id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot taking time depends on the number of person and face entries in the source object. It could be in seconds, or up to several hours for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. User can delete the snapshot using Snapshot - Delete by themselves any time before expiration.<br />
  ## Taking snapshot for a certain object will not block any other operations against the object. All read-only operations (Get/List and Identify/FindSimilar/Verify) can be conducted as usual. For all writable operations, including Add/Update/Delete the source object or its persons/faces and Train, they are not blocked but not recommended because writable updates may not be reflected on the snapshot during its taking. After snapshot taking is completed, all readable and writable operations can work as normal. Snapshot will also include the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## * Free-tier subscription quota: 100 take operations per month.
  ## * S0-tier subscription quota: 100 take operations per day.
  ## 
  let valid = call_594488.validator(path, query, header, formData, body)
  let scheme = call_594488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594488.url(scheme.get, call_594488.host, call_594488.base,
                         call_594488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594488, url, valid)

proc call*(call_594489: Call_SnapshotTake_594484; body: JsonNode): Recallable =
  ## snapshotTake
  ## Submit an operation to take a snapshot of face list, large face list, person group or large person group, with user-specified snapshot type, source object id, apply scope and an optional user data.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Taking snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of creating the snapshot. The snapshot id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot taking time depends on the number of person and face entries in the source object. It could be in seconds, or up to several hours for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. User can delete the snapshot using Snapshot - Delete by themselves any time before expiration.<br />
  ## Taking snapshot for a certain object will not block any other operations against the object. All read-only operations (Get/List and Identify/FindSimilar/Verify) can be conducted as usual. For all writable operations, including Add/Update/Delete the source object or its persons/faces and Train, they are not blocked but not recommended because writable updates may not be reflected on the snapshot during its taking. After snapshot taking is completed, all readable and writable operations can work as normal. Snapshot will also include the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## * Free-tier subscription quota: 100 take operations per month.
  ## * S0-tier subscription quota: 100 take operations per day.
  ##   body: JObject (required)
  ##       : Request body for taking a snapshot.
  var body_594490 = newJObject()
  if body != nil:
    body_594490 = body
  result = call_594489.call(nil, nil, nil, nil, body_594490)

var snapshotTake* = Call_SnapshotTake_594484(name: "snapshotTake",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/snapshots",
    validator: validate_SnapshotTake_594485, base: "", url: url_SnapshotTake_594486,
    schemes: {Scheme.Https})
type
  Call_SnapshotList_594476 = ref object of OpenApiRestCall_593439
proc url_SnapshotList_594478(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SnapshotList_594477(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   applyScope: JArray
  ##             : User specified snapshot apply scopes as a search filter. ApplyScope is an array of the target Azure subscription ids for the snapshot, specified by the user who created the snapshot by Snapshot - Take.
  ##   type: JString
  ##       : User specified object type as a search filter.
  section = newJObject()
  var valid_594479 = query.getOrDefault("applyScope")
  valid_594479 = validateParameter(valid_594479, JArray, required = false,
                                 default = nil)
  if valid_594479 != nil:
    section.add "applyScope", valid_594479
  var valid_594480 = query.getOrDefault("type")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = newJString("FaceList"))
  if valid_594480 != nil:
    section.add "type", valid_594480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594481: Call_SnapshotList_594476; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ## 
  let valid = call_594481.validator(path, query, header, formData, body)
  let scheme = call_594481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594481.url(scheme.get, call_594481.host, call_594481.base,
                         call_594481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594481, url, valid)

proc call*(call_594482: Call_SnapshotList_594476; applyScope: JsonNode = nil;
          `type`: string = "FaceList"): Recallable =
  ## snapshotList
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ##   applyScope: JArray
  ##             : User specified snapshot apply scopes as a search filter. ApplyScope is an array of the target Azure subscription ids for the snapshot, specified by the user who created the snapshot by Snapshot - Take.
  ##   type: string
  ##       : User specified object type as a search filter.
  var query_594483 = newJObject()
  if applyScope != nil:
    query_594483.add "applyScope", applyScope
  add(query_594483, "type", newJString(`type`))
  result = call_594482.call(nil, query_594483, nil, nil, nil)

var snapshotList* = Call_SnapshotList_594476(name: "snapshotList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/snapshots",
    validator: validate_SnapshotList_594477, base: "", url: url_SnapshotList_594478,
    schemes: {Scheme.Https})
type
  Call_SnapshotGet_594491 = ref object of OpenApiRestCall_593439
proc url_SnapshotGet_594493(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotGet_594492(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_594494 = path.getOrDefault("snapshotId")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "snapshotId", valid_594494
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594495: Call_SnapshotGet_594491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ## 
  let valid = call_594495.validator(path, query, header, formData, body)
  let scheme = call_594495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594495.url(scheme.get, call_594495.host, call_594495.base,
                         call_594495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594495, url, valid)

proc call*(call_594496: Call_SnapshotGet_594491; snapshotId: string): Recallable =
  ## snapshotGet
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  var path_594497 = newJObject()
  add(path_594497, "snapshotId", newJString(snapshotId))
  result = call_594496.call(path_594497, nil, nil, nil, nil)

var snapshotGet* = Call_SnapshotGet_594491(name: "snapshotGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/snapshots/{snapshotId}",
                                        validator: validate_SnapshotGet_594492,
                                        base: "", url: url_SnapshotGet_594493,
                                        schemes: {Scheme.Https})
type
  Call_SnapshotUpdate_594505 = ref object of OpenApiRestCall_593439
proc url_SnapshotUpdate_594507(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotUpdate_594506(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_594508 = path.getOrDefault("snapshotId")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "snapshotId", valid_594508
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for updating a snapshot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594510: Call_SnapshotUpdate_594505; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ## 
  let valid = call_594510.validator(path, query, header, formData, body)
  let scheme = call_594510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594510.url(scheme.get, call_594510.host, call_594510.base,
                         call_594510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594510, url, valid)

proc call*(call_594511: Call_SnapshotUpdate_594505; snapshotId: string;
          body: JsonNode): Recallable =
  ## snapshotUpdate
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  ##   body: JObject (required)
  ##       : Request body for updating a snapshot.
  var path_594512 = newJObject()
  var body_594513 = newJObject()
  add(path_594512, "snapshotId", newJString(snapshotId))
  if body != nil:
    body_594513 = body
  result = call_594511.call(path_594512, nil, nil, nil, body_594513)

var snapshotUpdate* = Call_SnapshotUpdate_594505(name: "snapshotUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/snapshots/{snapshotId}", validator: validate_SnapshotUpdate_594506,
    base: "", url: url_SnapshotUpdate_594507, schemes: {Scheme.Https})
type
  Call_SnapshotDelete_594498 = ref object of OpenApiRestCall_593439
proc url_SnapshotDelete_594500(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotDelete_594499(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_594501 = path.getOrDefault("snapshotId")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "snapshotId", valid_594501
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594502: Call_SnapshotDelete_594498; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ## 
  let valid = call_594502.validator(path, query, header, formData, body)
  let scheme = call_594502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594502.url(scheme.get, call_594502.host, call_594502.base,
                         call_594502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594502, url, valid)

proc call*(call_594503: Call_SnapshotDelete_594498; snapshotId: string): Recallable =
  ## snapshotDelete
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  var path_594504 = newJObject()
  add(path_594504, "snapshotId", newJString(snapshotId))
  result = call_594503.call(path_594504, nil, nil, nil, nil)

var snapshotDelete* = Call_SnapshotDelete_594498(name: "snapshotDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/snapshots/{snapshotId}", validator: validate_SnapshotDelete_594499,
    base: "", url: url_SnapshotDelete_594500, schemes: {Scheme.Https})
type
  Call_SnapshotApply_594514 = ref object of OpenApiRestCall_593439
proc url_SnapshotApply_594516(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId"),
               (kind: ConstantSegment, value: "/apply")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SnapshotApply_594515(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit an operation to apply a snapshot to current subscription. For each snapshot, only subscriptions included in the applyScope of Snapshot - Take can apply it.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Applying snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of applying the snapshot. The target object id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot applying time depends on the number of person and face entries in the snapshot object. It could be in seconds, or up to 1 hour for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. So the target subscription is required to apply the snapshot in 48 hours since its creation.<br />
  ## Applying a snapshot will not block any other operations against the target object, however it is not recommended because the correctness cannot be guaranteed during snapshot applying. After snapshot applying is completed, all operations towards the target object can work as normal. Snapshot also includes the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## One snapshot can be applied multiple times in parallel, while currently only CreateNew apply mode is supported, which means the apply operation will fail if target subscription already contains an object of same type and using the same objectId. Users can specify the "objectId" in request body to avoid such conflicts.<br />
  ## * Free-tier subscription quota: 100 apply operations per month.
  ## * S0-tier subscription quota: 100 apply operations per day.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : Id referencing a particular snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_594517 = path.getOrDefault("snapshotId")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "snapshotId", valid_594517
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for applying a snapshot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594519: Call_SnapshotApply_594514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit an operation to apply a snapshot to current subscription. For each snapshot, only subscriptions included in the applyScope of Snapshot - Take can apply it.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Applying snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of applying the snapshot. The target object id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot applying time depends on the number of person and face entries in the snapshot object. It could be in seconds, or up to 1 hour for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. So the target subscription is required to apply the snapshot in 48 hours since its creation.<br />
  ## Applying a snapshot will not block any other operations against the target object, however it is not recommended because the correctness cannot be guaranteed during snapshot applying. After snapshot applying is completed, all operations towards the target object can work as normal. Snapshot also includes the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## One snapshot can be applied multiple times in parallel, while currently only CreateNew apply mode is supported, which means the apply operation will fail if target subscription already contains an object of same type and using the same objectId. Users can specify the "objectId" in request body to avoid such conflicts.<br />
  ## * Free-tier subscription quota: 100 apply operations per month.
  ## * S0-tier subscription quota: 100 apply operations per day.
  ## 
  let valid = call_594519.validator(path, query, header, formData, body)
  let scheme = call_594519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594519.url(scheme.get, call_594519.host, call_594519.base,
                         call_594519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594519, url, valid)

proc call*(call_594520: Call_SnapshotApply_594514; snapshotId: string; body: JsonNode): Recallable =
  ## snapshotApply
  ## Submit an operation to apply a snapshot to current subscription. For each snapshot, only subscriptions included in the applyScope of Snapshot - Take can apply it.<br />
  ## The snapshot interfaces are for users to backup and restore their face data from one face subscription to another, inside same region or across regions. The workflow contains two phases, user first calls Snapshot - Take to create a copy of the source object and store it as a snapshot, then calls Snapshot - Apply to paste the snapshot to target subscription. The snapshots are stored in a centralized location (per Azure instance), so that they can be applied cross accounts and regions.<br />
  ## Applying snapshot is an asynchronous operation. An operation id can be obtained from the "Operation-Location" field in response header, to be used in OperationStatus - Get for tracking the progress of applying the snapshot. The target object id will be included in the "resourceLocation" field in OperationStatus - Get response when the operation status is "succeeded".<br />
  ## Snapshot applying time depends on the number of person and face entries in the snapshot object. It could be in seconds, or up to 1 hour for 1,000,000 persons with multiple faces.<br />
  ## Snapshots will be automatically expired and cleaned in 48 hours after it is created by Snapshot - Take. So the target subscription is required to apply the snapshot in 48 hours since its creation.<br />
  ## Applying a snapshot will not block any other operations against the target object, however it is not recommended because the correctness cannot be guaranteed during snapshot applying. After snapshot applying is completed, all operations towards the target object can work as normal. Snapshot also includes the training results of the source object, which means target subscription the snapshot applied to does not need re-train the target object before calling Identify/FindSimilar.<br />
  ## One snapshot can be applied multiple times in parallel, while currently only CreateNew apply mode is supported, which means the apply operation will fail if target subscription already contains an object of same type and using the same objectId. Users can specify the "objectId" in request body to avoid such conflicts.<br />
  ## * Free-tier subscription quota: 100 apply operations per month.
  ## * S0-tier subscription quota: 100 apply operations per day.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  ##   body: JObject (required)
  ##       : Request body for applying a snapshot.
  var path_594521 = newJObject()
  var body_594522 = newJObject()
  add(path_594521, "snapshotId", newJString(snapshotId))
  if body != nil:
    body_594522 = body
  result = call_594520.call(path_594521, nil, nil, nil, body_594522)

var snapshotApply* = Call_SnapshotApply_594514(name: "snapshotApply",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/snapshots/{snapshotId}/apply", validator: validate_SnapshotApply_594515,
    base: "", url: url_SnapshotApply_594516, schemes: {Scheme.Https})
type
  Call_FaceVerifyFaceToFace_594523 = ref object of OpenApiRestCall_593439
proc url_FaceVerifyFaceToFace_594525(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceVerifyFaceToFace_594524(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request body for face to face verification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594527: Call_FaceVerifyFaceToFace_594523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ## 
  let valid = call_594527.validator(path, query, header, formData, body)
  let scheme = call_594527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594527.url(scheme.get, call_594527.host, call_594527.base,
                         call_594527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594527, url, valid)

proc call*(call_594528: Call_FaceVerifyFaceToFace_594523; body: JsonNode): Recallable =
  ## faceVerifyFaceToFace
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ##   body: JObject (required)
  ##       : Request body for face to face verification.
  var body_594529 = newJObject()
  if body != nil:
    body_594529 = body
  result = call_594528.call(nil, nil, nil, nil, body_594529)

var faceVerifyFaceToFace* = Call_FaceVerifyFaceToFace_594523(
    name: "faceVerifyFaceToFace", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/verify", validator: validate_FaceVerifyFaceToFace_594524, base: "",
    url: url_FaceVerifyFaceToFace_594525, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
