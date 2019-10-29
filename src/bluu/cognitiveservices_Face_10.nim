
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-Face"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FaceDetectWithUrl_563788 = ref object of OpenApiRestCall_563566
proc url_FaceDetectWithUrl_563790(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceDetectWithUrl_563789(path: JsonNode; query: JsonNode;
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
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   recognitionModel: JString
  ##                   : Name of recognition model. Recognition model is used when the face features are extracted and associated with detected faceIds, (Large)FaceList or (Large)PersonGroup. A recognition model name can be provided when performing Face - Detect or (Large)FaceList - Create or (Large)PersonGroup - Create. The default value is 'recognition_01', if latest model needed, please explicitly specify the model you need.
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   returnFaceId: JBool
  ##               : A value indicating whether the operation should return faceIds of detected faces.
  ##   returnFaceLandmarks: JBool
  ##                      : A value indicating whether the operation should return landmarks of the detected faces.
  ##   returnFaceAttributes: JArray
  ##                       : Analyze and return the one or more specified face attributes in the comma-separated string like "returnFaceAttributes=age,gender". Supported face attributes include age, gender, headPose, smile, facialHair, glasses and emotion. Note that each face attribute analysis has additional computational and time cost.
  section = newJObject()
  var valid_563964 = query.getOrDefault("detectionModel")
  valid_563964 = validateParameter(valid_563964, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_563964 != nil:
    section.add "detectionModel", valid_563964
  var valid_563965 = query.getOrDefault("recognitionModel")
  valid_563965 = validateParameter(valid_563965, JString, required = false,
                                 default = newJString("recognition_01"))
  if valid_563965 != nil:
    section.add "recognitionModel", valid_563965
  var valid_563966 = query.getOrDefault("returnRecognitionModel")
  valid_563966 = validateParameter(valid_563966, JBool, required = false,
                                 default = newJBool(false))
  if valid_563966 != nil:
    section.add "returnRecognitionModel", valid_563966
  var valid_563967 = query.getOrDefault("returnFaceId")
  valid_563967 = validateParameter(valid_563967, JBool, required = false,
                                 default = newJBool(true))
  if valid_563967 != nil:
    section.add "returnFaceId", valid_563967
  var valid_563968 = query.getOrDefault("returnFaceLandmarks")
  valid_563968 = validateParameter(valid_563968, JBool, required = false,
                                 default = newJBool(false))
  if valid_563968 != nil:
    section.add "returnFaceLandmarks", valid_563968
  var valid_563969 = query.getOrDefault("returnFaceAttributes")
  valid_563969 = validateParameter(valid_563969, JArray, required = false,
                                 default = nil)
  if valid_563969 != nil:
    section.add "returnFaceAttributes", valid_563969
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

proc call*(call_563993: Call_FaceDetectWithUrl_563788; path: JsonNode;
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
  let valid = call_563993.validator(path, query, header, formData, body)
  let scheme = call_563993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563993.url(scheme.get, call_563993.host, call_563993.base,
                         call_563993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563993, url, valid)

proc call*(call_564064: Call_FaceDetectWithUrl_563788; ImageUrl: JsonNode;
          detectionModel: string = "detection_01";
          recognitionModel: string = "recognition_01";
          returnRecognitionModel: bool = false; returnFaceId: bool = true;
          returnFaceLandmarks: bool = false; returnFaceAttributes: JsonNode = nil): Recallable =
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
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   recognitionModel: string
  ##                   : Name of recognition model. Recognition model is used when the face features are extracted and associated with detected faceIds, (Large)FaceList or (Large)PersonGroup. A recognition model name can be provided when performing Face - Detect or (Large)FaceList - Create or (Large)PersonGroup - Create. The default value is 'recognition_01', if latest model needed, please explicitly specify the model you need.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   returnFaceId: bool
  ##               : A value indicating whether the operation should return faceIds of detected faces.
  ##   returnFaceLandmarks: bool
  ##                      : A value indicating whether the operation should return landmarks of the detected faces.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   returnFaceAttributes: JArray
  ##                       : Analyze and return the one or more specified face attributes in the comma-separated string like "returnFaceAttributes=age,gender". Supported face attributes include age, gender, headPose, smile, facialHair, glasses and emotion. Note that each face attribute analysis has additional computational and time cost.
  var query_564065 = newJObject()
  var body_564067 = newJObject()
  add(query_564065, "detectionModel", newJString(detectionModel))
  add(query_564065, "recognitionModel", newJString(recognitionModel))
  add(query_564065, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_564065, "returnFaceId", newJBool(returnFaceId))
  add(query_564065, "returnFaceLandmarks", newJBool(returnFaceLandmarks))
  if ImageUrl != nil:
    body_564067 = ImageUrl
  if returnFaceAttributes != nil:
    query_564065.add "returnFaceAttributes", returnFaceAttributes
  result = call_564064.call(nil, query_564065, nil, nil, body_564067)

var faceDetectWithUrl* = Call_FaceDetectWithUrl_563788(name: "faceDetectWithUrl",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/detect",
    validator: validate_FaceDetectWithUrl_563789, base: "",
    url: url_FaceDetectWithUrl_563790, schemes: {Scheme.Https})
type
  Call_FaceListList_564106 = ref object of OpenApiRestCall_563566
proc url_FaceListList_564108(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceListList_564107(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564109 = query.getOrDefault("returnRecognitionModel")
  valid_564109 = validateParameter(valid_564109, JBool, required = false,
                                 default = newJBool(false))
  if valid_564109 != nil:
    section.add "returnRecognitionModel", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_FaceListList_564106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_FaceListList_564106;
          returnRecognitionModel: bool = false): Recallable =
  ## faceListList
  ## List face lists’ faceListId, name, userData and recognitionModel. <br /> 
  ## To get face information inside faceList use [FaceList - Get](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524c)
  ## 
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var query_564112 = newJObject()
  add(query_564112, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_564111.call(nil, query_564112, nil, nil, nil)

var faceListList* = Call_FaceListList_564106(name: "faceListList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/facelists",
    validator: validate_FaceListList_564107, base: "", url: url_FaceListList_564108,
    schemes: {Scheme.Https})
type
  Call_FaceListCreate_564136 = ref object of OpenApiRestCall_563566
proc url_FaceListCreate_564138(protocol: Scheme; host: string; base: string;
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

proc validate_FaceListCreate_564137(path: JsonNode; query: JsonNode;
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
  var valid_564139 = path.getOrDefault("faceListId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "faceListId", valid_564139
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

proc call*(call_564141: Call_FaceListCreate_564136; path: JsonNode; query: JsonNode;
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
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_FaceListCreate_564136; body: JsonNode;
          faceListId: string): Recallable =
  ## faceListCreate
  ## Create an empty face list with user-specified faceListId, name, an optional userData and recognitionModel. Up to 64 face lists are allowed in one subscription.
  ## <br /> Face list is a list of faces, up to 1,000 faces, and used by [Face - Find Similar](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395237).
  ## <br /> After creation, user should use [FaceList - Add Face](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395250) to import the faces. No image will be stored. Only the extracted face features are stored on server until [FaceList - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524f) is called.
  ## <br /> Find Similar is used for scenario like finding celebrity-like faces, similar face filtering, or as a light way face identification. But if the actual use is to identify person, please use [PersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395244) / [LargePersonGroup](/docs/services/563879b61984550e40cbbe8d/operations/599acdee6ac60f11b48b5a9d) and [Face - Identify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395239).
  ## <br /> Please consider [LargeFaceList](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) when the face number is large. It can support up to 1,000,000 faces.
  ## <br />'recognitionModel' should be specified to associate with this face list. The default value for 'recognitionModel' is 'recognition_01', if the latest model needed, please explicitly specify the model you need in this parameter. New faces that are added to an existing face list will use the recognition model that's already associated with the collection. Existing face features in a face list can't be updated to features extracted by another version of recognition model.
  ## * 'recognition_01': The default recognition model for [FaceList- Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b). All those face lists created before 2019 March are bonded with this recognition model.
  ## * 'recognition_02': Recognition model released in 2019 March. 'recognition_02' is recommended since its overall accuracy is improved compared with 'recognition_01'.
  ##   body: JObject (required)
  ##       : Request body for creating a face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_564143 = newJObject()
  var body_564144 = newJObject()
  if body != nil:
    body_564144 = body
  add(path_564143, "faceListId", newJString(faceListId))
  result = call_564142.call(path_564143, nil, nil, nil, body_564144)

var faceListCreate* = Call_FaceListCreate_564136(name: "faceListCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/facelists/{faceListId}",
    validator: validate_FaceListCreate_564137, base: "", url: url_FaceListCreate_564138,
    schemes: {Scheme.Https})
type
  Call_FaceListGet_564113 = ref object of OpenApiRestCall_563566
proc url_FaceListGet_564115(protocol: Scheme; host: string; base: string;
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

proc validate_FaceListGet_564114(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564130 = path.getOrDefault("faceListId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "faceListId", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_564131 = query.getOrDefault("returnRecognitionModel")
  valid_564131 = validateParameter(valid_564131, JBool, required = false,
                                 default = newJBool(false))
  if valid_564131 != nil:
    section.add "returnRecognitionModel", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_FaceListGet_564113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_FaceListGet_564113; faceListId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## faceListGet
  ## Retrieve a face list’s faceListId, name, userData, recognitionModel and faces in the face list.
  ## 
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(query_564135, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(path_564134, "faceListId", newJString(faceListId))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var faceListGet* = Call_FaceListGet_564113(name: "faceListGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/facelists/{faceListId}",
                                        validator: validate_FaceListGet_564114,
                                        base: "", url: url_FaceListGet_564115,
                                        schemes: {Scheme.Https})
type
  Call_FaceListUpdate_564152 = ref object of OpenApiRestCall_563566
proc url_FaceListUpdate_564154(protocol: Scheme; host: string; base: string;
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

proc validate_FaceListUpdate_564153(path: JsonNode; query: JsonNode;
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
  var valid_564155 = path.getOrDefault("faceListId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "faceListId", valid_564155
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

proc call*(call_564157: Call_FaceListUpdate_564152; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update information of a face list.
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_FaceListUpdate_564152; body: JsonNode;
          faceListId: string): Recallable =
  ## faceListUpdate
  ## Update information of a face list.
  ##   body: JObject (required)
  ##       : Request body for updating a face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_564159 = newJObject()
  var body_564160 = newJObject()
  if body != nil:
    body_564160 = body
  add(path_564159, "faceListId", newJString(faceListId))
  result = call_564158.call(path_564159, nil, nil, nil, body_564160)

var faceListUpdate* = Call_FaceListUpdate_564152(name: "faceListUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/facelists/{faceListId}", validator: validate_FaceListUpdate_564153,
    base: "", url: url_FaceListUpdate_564154, schemes: {Scheme.Https})
type
  Call_FaceListDelete_564145 = ref object of OpenApiRestCall_563566
proc url_FaceListDelete_564147(protocol: Scheme; host: string; base: string;
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

proc validate_FaceListDelete_564146(path: JsonNode; query: JsonNode;
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
  var valid_564148 = path.getOrDefault("faceListId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "faceListId", valid_564148
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_FaceListDelete_564145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specified face list.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_FaceListDelete_564145; faceListId: string): Recallable =
  ## faceListDelete
  ## Delete a specified face list.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_564151 = newJObject()
  add(path_564151, "faceListId", newJString(faceListId))
  result = call_564150.call(path_564151, nil, nil, nil, nil)

var faceListDelete* = Call_FaceListDelete_564145(name: "faceListDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/facelists/{faceListId}", validator: validate_FaceListDelete_564146,
    base: "", url: url_FaceListDelete_564147, schemes: {Scheme.Https})
type
  Call_FaceListAddFaceFromUrl_564161 = ref object of OpenApiRestCall_563566
proc url_FaceListAddFaceFromUrl_564163(protocol: Scheme; host: string; base: string;
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

proc validate_FaceListAddFaceFromUrl_564162(path: JsonNode; query: JsonNode;
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
  var valid_564164 = path.getOrDefault("faceListId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "faceListId", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  section = newJObject()
  var valid_564165 = query.getOrDefault("detectionModel")
  valid_564165 = validateParameter(valid_564165, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_564165 != nil:
    section.add "detectionModel", valid_564165
  var valid_564166 = query.getOrDefault("targetFace")
  valid_564166 = validateParameter(valid_564166, JArray, required = false,
                                 default = nil)
  if valid_564166 != nil:
    section.add "targetFace", valid_564166
  var valid_564167 = query.getOrDefault("userData")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = nil)
  if valid_564167 != nil:
    section.add "userData", valid_564167
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

proc call*(call_564169: Call_FaceListAddFaceFromUrl_564161; path: JsonNode;
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
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_FaceListAddFaceFromUrl_564161; faceListId: string;
          ImageUrl: JsonNode; detectionModel: string = "detection_01";
          targetFace: JsonNode = nil; userData: string = ""): Recallable =
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
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  var body_564173 = newJObject()
  add(query_564172, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_564172.add "targetFace", targetFace
  add(query_564172, "userData", newJString(userData))
  add(path_564171, "faceListId", newJString(faceListId))
  if ImageUrl != nil:
    body_564173 = ImageUrl
  result = call_564170.call(path_564171, query_564172, nil, nil, body_564173)

var faceListAddFaceFromUrl* = Call_FaceListAddFaceFromUrl_564161(
    name: "faceListAddFaceFromUrl", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/facelists/{faceListId}/persistedfaces",
    validator: validate_FaceListAddFaceFromUrl_564162, base: "",
    url: url_FaceListAddFaceFromUrl_564163, schemes: {Scheme.Https})
type
  Call_FaceListDeleteFace_564174 = ref object of OpenApiRestCall_563566
proc url_FaceListDeleteFace_564176(protocol: Scheme; host: string; base: string;
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

proc validate_FaceListDeleteFace_564175(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   faceListId: JString (required)
  ##             : Id referencing a particular face list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564177 = path.getOrDefault("persistedFaceId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "persistedFaceId", valid_564177
  var valid_564178 = path.getOrDefault("faceListId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "faceListId", valid_564178
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_FaceListDeleteFace_564174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_FaceListDeleteFace_564174; persistedFaceId: string;
          faceListId: string): Recallable =
  ## faceListDeleteFace
  ## Delete a face from a face list by specified faceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same face list are processed sequentially and to/from different face lists are in parallel.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   faceListId: string (required)
  ##             : Id referencing a particular face list.
  var path_564181 = newJObject()
  add(path_564181, "persistedFaceId", newJString(persistedFaceId))
  add(path_564181, "faceListId", newJString(faceListId))
  result = call_564180.call(path_564181, nil, nil, nil, nil)

var faceListDeleteFace* = Call_FaceListDeleteFace_564174(
    name: "faceListDeleteFace", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/facelists/{faceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_FaceListDeleteFace_564175, base: "",
    url: url_FaceListDeleteFace_564176, schemes: {Scheme.Https})
type
  Call_FaceFindSimilar_564182 = ref object of OpenApiRestCall_563566
proc url_FaceFindSimilar_564184(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceFindSimilar_564183(path: JsonNode; query: JsonNode;
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

proc call*(call_564186: Call_FaceFindSimilar_564182; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_FaceFindSimilar_564182; body: JsonNode): Recallable =
  ## faceFindSimilar
  ## Given query face's faceId, to search the similar-looking faces from a faceId array, a face list or a large face list. faceId array contains the faces created by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), which will expire 24 hours after creation. A "faceListId" is created by [FaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039524b) containing persistedFaceIds that will not expire. And a "largeFaceListId" is created by [LargeFaceList - Create](/docs/services/563879b61984550e40cbbe8d/operations/5a157b68d2de3616c086f2cc) containing persistedFaceIds that will also not expire. Depending on the input the returned similar faces list contains faceIds or persistedFaceIds ranked by similarity.
  ## <br/>Find similar has two working modes, "matchPerson" and "matchFace". "matchPerson" is the default mode that it tries to find faces of the same person as possible by using internal same-person thresholds. It is useful to find a known person's other photos. Note that an empty list will be returned if no faces pass the internal thresholds. "matchFace" mode ignores same-person thresholds and returns ranked similar faces anyway, even the similarity is low. It can be used in the cases like searching celebrity-looking faces.
  ## <br/>The 'recognitionModel' associated with the query face's faceId should be the same as the 'recognitionModel' used by the target faceId array, face list or large face list.
  ## 
  ##   body: JObject (required)
  ##       : Request body for Find Similar.
  var body_564188 = newJObject()
  if body != nil:
    body_564188 = body
  result = call_564187.call(nil, nil, nil, nil, body_564188)

var faceFindSimilar* = Call_FaceFindSimilar_564182(name: "faceFindSimilar",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/findsimilars",
    validator: validate_FaceFindSimilar_564183, base: "", url: url_FaceFindSimilar_564184,
    schemes: {Scheme.Https})
type
  Call_FaceGroup_564189 = ref object of OpenApiRestCall_563566
proc url_FaceGroup_564191(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceGroup_564190(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_564193: Call_FaceGroup_564189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_FaceGroup_564189; body: JsonNode): Recallable =
  ## faceGroup
  ## Divide candidate faces into groups based on face similarity.<br />
  ## * The output is one or more disjointed face groups and a messyGroup. A face group contains faces that have similar looking, often of the same person. Face groups are ranked by group size, i.e. number of faces. Notice that faces belonging to a same person might be split into several groups in the result.
  ## * MessyGroup is a special face group containing faces that cannot find any similar counterpart face from original faces. The messyGroup will not appear in the result if all faces found their counterparts.
  ## * Group API needs at least 2 candidate faces and 1000 at most. We suggest to try [Face - Verify](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523a) when you only have 2 candidate faces.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same.
  ## 
  ##   body: JObject (required)
  ##       : Request body for grouping.
  var body_564195 = newJObject()
  if body != nil:
    body_564195 = body
  result = call_564194.call(nil, nil, nil, nil, body_564195)

var faceGroup* = Call_FaceGroup_564189(name: "faceGroup", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/group",
                                    validator: validate_FaceGroup_564190,
                                    base: "", url: url_FaceGroup_564191,
                                    schemes: {Scheme.Https})
type
  Call_FaceIdentify_564196 = ref object of OpenApiRestCall_563566
proc url_FaceIdentify_564198(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceIdentify_564197(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_564200: Call_FaceIdentify_564196; path: JsonNode; query: JsonNode;
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
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_FaceIdentify_564196; body: JsonNode): Recallable =
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
  var body_564202 = newJObject()
  if body != nil:
    body_564202 = body
  result = call_564201.call(nil, nil, nil, nil, body_564202)

var faceIdentify* = Call_FaceIdentify_564196(name: "faceIdentify",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/identify",
    validator: validate_FaceIdentify_564197, base: "", url: url_FaceIdentify_564198,
    schemes: {Scheme.Https})
type
  Call_LargeFaceListList_564203 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListList_564205(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LargeFaceListList_564204(path: JsonNode; query: JsonNode;
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
  var valid_564206 = query.getOrDefault("returnRecognitionModel")
  valid_564206 = validateParameter(valid_564206, JBool, required = false,
                                 default = newJBool(false))
  if valid_564206 != nil:
    section.add "returnRecognitionModel", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564207: Call_LargeFaceListList_564203; path: JsonNode;
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
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_LargeFaceListList_564203;
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
  var query_564209 = newJObject()
  add(query_564209, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_564208.call(nil, query_564209, nil, nil, nil)

var largeFaceListList* = Call_LargeFaceListList_564203(name: "largeFaceListList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/largefacelists",
    validator: validate_LargeFaceListList_564204, base: "",
    url: url_LargeFaceListList_564205, schemes: {Scheme.Https})
type
  Call_LargeFaceListCreate_564219 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListCreate_564221(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListCreate_564220(path: JsonNode; query: JsonNode;
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
  var valid_564222 = path.getOrDefault("largeFaceListId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "largeFaceListId", valid_564222
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

proc call*(call_564224: Call_LargeFaceListCreate_564219; path: JsonNode;
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
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_LargeFaceListCreate_564219; largeFaceListId: string;
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
  var path_564226 = newJObject()
  var body_564227 = newJObject()
  add(path_564226, "largeFaceListId", newJString(largeFaceListId))
  if body != nil:
    body_564227 = body
  result = call_564225.call(path_564226, nil, nil, nil, body_564227)

var largeFaceListCreate* = Call_LargeFaceListCreate_564219(
    name: "largeFaceListCreate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListCreate_564220, base: "",
    url: url_LargeFaceListCreate_564221, schemes: {Scheme.Https})
type
  Call_LargeFaceListGet_564210 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListGet_564212(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListGet_564211(path: JsonNode; query: JsonNode;
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
  var valid_564213 = path.getOrDefault("largeFaceListId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "largeFaceListId", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_564214 = query.getOrDefault("returnRecognitionModel")
  valid_564214 = validateParameter(valid_564214, JBool, required = false,
                                 default = newJBool(false))
  if valid_564214 != nil:
    section.add "returnRecognitionModel", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_LargeFaceListGet_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_LargeFaceListGet_564210; largeFaceListId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## largeFaceListGet
  ## Retrieve a large face list’s largeFaceListId, name, userData and recognitionModel.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  add(path_564217, "largeFaceListId", newJString(largeFaceListId))
  add(query_564218, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_564216.call(path_564217, query_564218, nil, nil, nil)

var largeFaceListGet* = Call_LargeFaceListGet_564210(name: "largeFaceListGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListGet_564211, base: "",
    url: url_LargeFaceListGet_564212, schemes: {Scheme.Https})
type
  Call_LargeFaceListUpdate_564235 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListUpdate_564237(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListUpdate_564236(path: JsonNode; query: JsonNode;
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
  var valid_564238 = path.getOrDefault("largeFaceListId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "largeFaceListId", valid_564238
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

proc call*(call_564240: Call_LargeFaceListUpdate_564235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update information of a large face list.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_LargeFaceListUpdate_564235; largeFaceListId: string;
          body: JsonNode): Recallable =
  ## largeFaceListUpdate
  ## Update information of a large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   body: JObject (required)
  ##       : Request body for updating a large face list.
  var path_564242 = newJObject()
  var body_564243 = newJObject()
  add(path_564242, "largeFaceListId", newJString(largeFaceListId))
  if body != nil:
    body_564243 = body
  result = call_564241.call(path_564242, nil, nil, nil, body_564243)

var largeFaceListUpdate* = Call_LargeFaceListUpdate_564235(
    name: "largeFaceListUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListUpdate_564236, base: "",
    url: url_LargeFaceListUpdate_564237, schemes: {Scheme.Https})
type
  Call_LargeFaceListDelete_564228 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListDelete_564230(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListDelete_564229(path: JsonNode; query: JsonNode;
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
  var valid_564231 = path.getOrDefault("largeFaceListId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "largeFaceListId", valid_564231
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_LargeFaceListDelete_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specified large face list.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_LargeFaceListDelete_564228; largeFaceListId: string): Recallable =
  ## largeFaceListDelete
  ## Delete a specified large face list.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_564234 = newJObject()
  add(path_564234, "largeFaceListId", newJString(largeFaceListId))
  result = call_564233.call(path_564234, nil, nil, nil, nil)

var largeFaceListDelete* = Call_LargeFaceListDelete_564228(
    name: "largeFaceListDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}",
    validator: validate_LargeFaceListDelete_564229, base: "",
    url: url_LargeFaceListDelete_564230, schemes: {Scheme.Https})
type
  Call_LargeFaceListAddFaceFromUrl_564254 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListAddFaceFromUrl_564256(protocol: Scheme; host: string;
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

proc validate_LargeFaceListAddFaceFromUrl_564255(path: JsonNode; query: JsonNode;
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
  var valid_564257 = path.getOrDefault("largeFaceListId")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "largeFaceListId", valid_564257
  result.add "path", section
  ## parameters in `query` object:
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  section = newJObject()
  var valid_564258 = query.getOrDefault("detectionModel")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_564258 != nil:
    section.add "detectionModel", valid_564258
  var valid_564259 = query.getOrDefault("targetFace")
  valid_564259 = validateParameter(valid_564259, JArray, required = false,
                                 default = nil)
  if valid_564259 != nil:
    section.add "targetFace", valid_564259
  var valid_564260 = query.getOrDefault("userData")
  valid_564260 = validateParameter(valid_564260, JString, required = false,
                                 default = nil)
  if valid_564260 != nil:
    section.add "userData", valid_564260
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

proc call*(call_564262: Call_LargeFaceListAddFaceFromUrl_564254; path: JsonNode;
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
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_LargeFaceListAddFaceFromUrl_564254;
          largeFaceListId: string; ImageUrl: JsonNode;
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil;
          userData: string = ""): Recallable =
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
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  var body_564266 = newJObject()
  add(path_564264, "largeFaceListId", newJString(largeFaceListId))
  add(query_564265, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_564265.add "targetFace", targetFace
  add(query_564265, "userData", newJString(userData))
  if ImageUrl != nil:
    body_564266 = ImageUrl
  result = call_564263.call(path_564264, query_564265, nil, nil, body_564266)

var largeFaceListAddFaceFromUrl* = Call_LargeFaceListAddFaceFromUrl_564254(
    name: "largeFaceListAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/persistedfaces",
    validator: validate_LargeFaceListAddFaceFromUrl_564255, base: "",
    url: url_LargeFaceListAddFaceFromUrl_564256, schemes: {Scheme.Https})
type
  Call_LargeFaceListListFaces_564244 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListListFaces_564246(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListListFaces_564245(path: JsonNode; query: JsonNode;
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
  var valid_564247 = path.getOrDefault("largeFaceListId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "largeFaceListId", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   start: JString
  ##        : Starting face id to return (used to list a range of faces).
  ##   top: JInt
  ##      : Number of faces to return starting with the face id indicated by the 'start' parameter.
  section = newJObject()
  var valid_564248 = query.getOrDefault("start")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "start", valid_564248
  var valid_564249 = query.getOrDefault("top")
  valid_564249 = validateParameter(valid_564249, JInt, required = false, default = nil)
  if valid_564249 != nil:
    section.add "top", valid_564249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_LargeFaceListListFaces_564244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_LargeFaceListListFaces_564244;
          largeFaceListId: string; start: string = ""; top: int = 0): Recallable =
  ## largeFaceListListFaces
  ## List all faces in a large face list, and retrieve face information (including userData and persistedFaceIds of registered faces of the face).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   start: string
  ##        : Starting face id to return (used to list a range of faces).
  ##   top: int
  ##      : Number of faces to return starting with the face id indicated by the 'start' parameter.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  add(path_564252, "largeFaceListId", newJString(largeFaceListId))
  add(query_564253, "start", newJString(start))
  add(query_564253, "top", newJInt(top))
  result = call_564251.call(path_564252, query_564253, nil, nil, nil)

var largeFaceListListFaces* = Call_LargeFaceListListFaces_564244(
    name: "largeFaceListListFaces", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/persistedfaces",
    validator: validate_LargeFaceListListFaces_564245, base: "",
    url: url_LargeFaceListListFaces_564246, schemes: {Scheme.Https})
type
  Call_LargeFaceListGetFace_564267 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListGetFace_564269(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListGetFace_564268(path: JsonNode; query: JsonNode;
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
  var valid_564270 = path.getOrDefault("largeFaceListId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "largeFaceListId", valid_564270
  var valid_564271 = path.getOrDefault("persistedFaceId")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "persistedFaceId", valid_564271
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_LargeFaceListGetFace_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_LargeFaceListGetFace_564267; largeFaceListId: string;
          persistedFaceId: string): Recallable =
  ## largeFaceListGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId and its belonging largeFaceListId).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_564274 = newJObject()
  add(path_564274, "largeFaceListId", newJString(largeFaceListId))
  add(path_564274, "persistedFaceId", newJString(persistedFaceId))
  result = call_564273.call(path_564274, nil, nil, nil, nil)

var largeFaceListGetFace* = Call_LargeFaceListGetFace_564267(
    name: "largeFaceListGetFace", meth: HttpMethod.HttpGet, host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListGetFace_564268, base: "",
    url: url_LargeFaceListGetFace_564269, schemes: {Scheme.Https})
type
  Call_LargeFaceListUpdateFace_564283 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListUpdateFace_564285(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListUpdateFace_564284(path: JsonNode; query: JsonNode;
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
  var valid_564286 = path.getOrDefault("largeFaceListId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "largeFaceListId", valid_564286
  var valid_564287 = path.getOrDefault("persistedFaceId")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "persistedFaceId", valid_564287
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

proc call*(call_564289: Call_LargeFaceListUpdateFace_564283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a persisted face's userData field.
  ## 
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_LargeFaceListUpdateFace_564283;
          largeFaceListId: string; persistedFaceId: string; body: JsonNode): Recallable =
  ## largeFaceListUpdateFace
  ## Update a persisted face's userData field.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  var path_564291 = newJObject()
  var body_564292 = newJObject()
  add(path_564291, "largeFaceListId", newJString(largeFaceListId))
  add(path_564291, "persistedFaceId", newJString(persistedFaceId))
  if body != nil:
    body_564292 = body
  result = call_564290.call(path_564291, nil, nil, nil, body_564292)

var largeFaceListUpdateFace* = Call_LargeFaceListUpdateFace_564283(
    name: "largeFaceListUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListUpdateFace_564284, base: "",
    url: url_LargeFaceListUpdateFace_564285, schemes: {Scheme.Https})
type
  Call_LargeFaceListDeleteFace_564275 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListDeleteFace_564277(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListDeleteFace_564276(path: JsonNode; query: JsonNode;
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
  var valid_564278 = path.getOrDefault("largeFaceListId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "largeFaceListId", valid_564278
  var valid_564279 = path.getOrDefault("persistedFaceId")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "persistedFaceId", valid_564279
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_LargeFaceListDeleteFace_564275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_LargeFaceListDeleteFace_564275;
          largeFaceListId: string; persistedFaceId: string): Recallable =
  ## largeFaceListDeleteFace
  ## Delete a face from a large face list by specified largeFaceListId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same large face list are processed sequentially and to/from different large face lists are in parallel.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  var path_564282 = newJObject()
  add(path_564282, "largeFaceListId", newJString(largeFaceListId))
  add(path_564282, "persistedFaceId", newJString(persistedFaceId))
  result = call_564281.call(path_564282, nil, nil, nil, nil)

var largeFaceListDeleteFace* = Call_LargeFaceListDeleteFace_564275(
    name: "largeFaceListDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargeFaceListDeleteFace_564276, base: "",
    url: url_LargeFaceListDeleteFace_564277, schemes: {Scheme.Https})
type
  Call_LargeFaceListTrain_564293 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListTrain_564295(protocol: Scheme; host: string; base: string;
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

proc validate_LargeFaceListTrain_564294(path: JsonNode; query: JsonNode;
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
  var valid_564296 = path.getOrDefault("largeFaceListId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "largeFaceListId", valid_564296
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564297: Call_LargeFaceListTrain_564293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a large face list training task, the training task may not be started immediately.
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_LargeFaceListTrain_564293; largeFaceListId: string): Recallable =
  ## largeFaceListTrain
  ## Queue a large face list training task, the training task may not be started immediately.
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_564299 = newJObject()
  add(path_564299, "largeFaceListId", newJString(largeFaceListId))
  result = call_564298.call(path_564299, nil, nil, nil, nil)

var largeFaceListTrain* = Call_LargeFaceListTrain_564293(
    name: "largeFaceListTrain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/largefacelists/{largeFaceListId}/train",
    validator: validate_LargeFaceListTrain_564294, base: "",
    url: url_LargeFaceListTrain_564295, schemes: {Scheme.Https})
type
  Call_LargeFaceListGetTrainingStatus_564300 = ref object of OpenApiRestCall_563566
proc url_LargeFaceListGetTrainingStatus_564302(protocol: Scheme; host: string;
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

proc validate_LargeFaceListGetTrainingStatus_564301(path: JsonNode;
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
  var valid_564303 = path.getOrDefault("largeFaceListId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "largeFaceListId", valid_564303
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_LargeFaceListGetTrainingStatus_564300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the training status of a large face list (completed or ongoing).
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_LargeFaceListGetTrainingStatus_564300;
          largeFaceListId: string): Recallable =
  ## largeFaceListGetTrainingStatus
  ## Retrieve the training status of a large face list (completed or ongoing).
  ##   largeFaceListId: string (required)
  ##                  : Id referencing a particular large face list.
  var path_564306 = newJObject()
  add(path_564306, "largeFaceListId", newJString(largeFaceListId))
  result = call_564305.call(path_564306, nil, nil, nil, nil)

var largeFaceListGetTrainingStatus* = Call_LargeFaceListGetTrainingStatus_564300(
    name: "largeFaceListGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largefacelists/{largeFaceListId}/training",
    validator: validate_LargeFaceListGetTrainingStatus_564301, base: "",
    url: url_LargeFaceListGetTrainingStatus_564302, schemes: {Scheme.Https})
type
  Call_LargePersonGroupList_564307 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupList_564309(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LargePersonGroupList_564308(path: JsonNode; query: JsonNode;
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
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: JString
  ##        : List large person groups from the least largePersonGroupId greater than the "start".
  ##   top: JInt
  ##      : The number of large person groups to list.
  section = newJObject()
  var valid_564310 = query.getOrDefault("returnRecognitionModel")
  valid_564310 = validateParameter(valid_564310, JBool, required = false,
                                 default = newJBool(false))
  if valid_564310 != nil:
    section.add "returnRecognitionModel", valid_564310
  var valid_564311 = query.getOrDefault("start")
  valid_564311 = validateParameter(valid_564311, JString, required = false,
                                 default = nil)
  if valid_564311 != nil:
    section.add "start", valid_564311
  var valid_564313 = query.getOrDefault("top")
  valid_564313 = validateParameter(valid_564313, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564313 != nil:
    section.add "top", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_LargePersonGroupList_564307; path: JsonNode;
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
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_LargePersonGroupList_564307;
          returnRecognitionModel: bool = false; start: string = ""; top: int = 1000): Recallable =
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
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: string
  ##        : List large person groups from the least largePersonGroupId greater than the "start".
  ##   top: int
  ##      : The number of large person groups to list.
  var query_564316 = newJObject()
  add(query_564316, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_564316, "start", newJString(start))
  add(query_564316, "top", newJInt(top))
  result = call_564315.call(nil, query_564316, nil, nil, nil)

var largePersonGroupList* = Call_LargePersonGroupList_564307(
    name: "largePersonGroupList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largepersongroups", validator: validate_LargePersonGroupList_564308,
    base: "", url: url_LargePersonGroupList_564309, schemes: {Scheme.Https})
type
  Call_LargePersonGroupCreate_564326 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupCreate_564328(protocol: Scheme; host: string; base: string;
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

proc validate_LargePersonGroupCreate_564327(path: JsonNode; query: JsonNode;
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
  var valid_564329 = path.getOrDefault("largePersonGroupId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "largePersonGroupId", valid_564329
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

proc call*(call_564331: Call_LargePersonGroupCreate_564326; path: JsonNode;
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
  let valid = call_564331.validator(path, query, header, formData, body)
  let scheme = call_564331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564331.url(scheme.get, call_564331.host, call_564331.base,
                         call_564331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564331, url, valid)

proc call*(call_564332: Call_LargePersonGroupCreate_564326;
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
  var path_564333 = newJObject()
  var body_564334 = newJObject()
  add(path_564333, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_564334 = body
  result = call_564332.call(path_564333, nil, nil, nil, body_564334)

var largePersonGroupCreate* = Call_LargePersonGroupCreate_564326(
    name: "largePersonGroupCreate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupCreate_564327, base: "",
    url: url_LargePersonGroupCreate_564328, schemes: {Scheme.Https})
type
  Call_LargePersonGroupGet_564317 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupGet_564319(protocol: Scheme; host: string; base: string;
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

proc validate_LargePersonGroupGet_564318(path: JsonNode; query: JsonNode;
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
  var valid_564320 = path.getOrDefault("largePersonGroupId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "largePersonGroupId", valid_564320
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_564321 = query.getOrDefault("returnRecognitionModel")
  valid_564321 = validateParameter(valid_564321, JBool, required = false,
                                 default = newJBool(false))
  if valid_564321 != nil:
    section.add "returnRecognitionModel", valid_564321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564322: Call_LargePersonGroupGet_564317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ## 
  let valid = call_564322.validator(path, query, header, formData, body)
  let scheme = call_564322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564322.url(scheme.get, call_564322.host, call_564322.base,
                         call_564322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564322, url, valid)

proc call*(call_564323: Call_LargePersonGroupGet_564317;
          largePersonGroupId: string; returnRecognitionModel: bool = false): Recallable =
  ## largePersonGroupGet
  ## Retrieve the information of a large person group, including its name, userData and recognitionModel. This API returns large person group information only, use [LargePersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/599adda06ac60f11b48b5aa1) instead to retrieve person information under the large person group.
  ## 
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  var path_564324 = newJObject()
  var query_564325 = newJObject()
  add(path_564324, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_564325, "returnRecognitionModel", newJBool(returnRecognitionModel))
  result = call_564323.call(path_564324, query_564325, nil, nil, nil)

var largePersonGroupGet* = Call_LargePersonGroupGet_564317(
    name: "largePersonGroupGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupGet_564318, base: "",
    url: url_LargePersonGroupGet_564319, schemes: {Scheme.Https})
type
  Call_LargePersonGroupUpdate_564342 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupUpdate_564344(protocol: Scheme; host: string; base: string;
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

proc validate_LargePersonGroupUpdate_564343(path: JsonNode; query: JsonNode;
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
  var valid_564345 = path.getOrDefault("largePersonGroupId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "largePersonGroupId", valid_564345
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

proc call*(call_564347: Call_LargePersonGroupUpdate_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_LargePersonGroupUpdate_564342;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupUpdate
  ## Update an existing large person group's display name and userData. The properties which does not appear in request body will not be updated.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for updating large person group.
  var path_564349 = newJObject()
  var body_564350 = newJObject()
  add(path_564349, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_564350 = body
  result = call_564348.call(path_564349, nil, nil, nil, body_564350)

var largePersonGroupUpdate* = Call_LargePersonGroupUpdate_564342(
    name: "largePersonGroupUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupUpdate_564343, base: "",
    url: url_LargePersonGroupUpdate_564344, schemes: {Scheme.Https})
type
  Call_LargePersonGroupDelete_564335 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupDelete_564337(protocol: Scheme; host: string; base: string;
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

proc validate_LargePersonGroupDelete_564336(path: JsonNode; query: JsonNode;
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
  var valid_564338 = path.getOrDefault("largePersonGroupId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "largePersonGroupId", valid_564338
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_LargePersonGroupDelete_564335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_LargePersonGroupDelete_564335;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupDelete
  ## Delete an existing large person group. Persisted face features of all people in the large person group will also be deleted.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_564341 = newJObject()
  add(path_564341, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_564340.call(path_564341, nil, nil, nil, nil)

var largePersonGroupDelete* = Call_LargePersonGroupDelete_564335(
    name: "largePersonGroupDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}",
    validator: validate_LargePersonGroupDelete_564336, base: "",
    url: url_LargePersonGroupDelete_564337, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonCreate_564361 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonCreate_564363(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonCreate_564362(path: JsonNode; query: JsonNode;
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
  var valid_564364 = path.getOrDefault("largePersonGroupId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "largePersonGroupId", valid_564364
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

proc call*(call_564366: Call_LargePersonGroupPersonCreate_564361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person in a specified large person group.
  ## 
  let valid = call_564366.validator(path, query, header, formData, body)
  let scheme = call_564366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564366.url(scheme.get, call_564366.host, call_564366.base,
                         call_564366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564366, url, valid)

proc call*(call_564367: Call_LargePersonGroupPersonCreate_564361;
          largePersonGroupId: string; body: JsonNode): Recallable =
  ## largePersonGroupPersonCreate
  ## Create a new person in a specified large person group.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  var path_564368 = newJObject()
  var body_564369 = newJObject()
  add(path_564368, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_564369 = body
  result = call_564367.call(path_564368, nil, nil, nil, body_564369)

var largePersonGroupPersonCreate* = Call_LargePersonGroupPersonCreate_564361(
    name: "largePersonGroupPersonCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons",
    validator: validate_LargePersonGroupPersonCreate_564362, base: "",
    url: url_LargePersonGroupPersonCreate_564363, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonList_564351 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonList_564353(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonList_564352(path: JsonNode; query: JsonNode;
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
  var valid_564354 = path.getOrDefault("largePersonGroupId")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "largePersonGroupId", valid_564354
  result.add "path", section
  ## parameters in `query` object:
  ##   start: JString
  ##        : Starting person id to return (used to list a range of persons).
  ##   top: JInt
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  section = newJObject()
  var valid_564355 = query.getOrDefault("start")
  valid_564355 = validateParameter(valid_564355, JString, required = false,
                                 default = nil)
  if valid_564355 != nil:
    section.add "start", valid_564355
  var valid_564356 = query.getOrDefault("top")
  valid_564356 = validateParameter(valid_564356, JInt, required = false, default = nil)
  if valid_564356 != nil:
    section.add "top", valid_564356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564357: Call_LargePersonGroupPersonList_564351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  let valid = call_564357.validator(path, query, header, formData, body)
  let scheme = call_564357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564357.url(scheme.get, call_564357.host, call_564357.base,
                         call_564357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564357, url, valid)

proc call*(call_564358: Call_LargePersonGroupPersonList_564351;
          largePersonGroupId: string; start: string = ""; top: int = 0): Recallable =
  ## largePersonGroupPersonList
  ## List all persons in a large person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   start: string
  ##        : Starting person id to return (used to list a range of persons).
  ##   top: int
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  var path_564359 = newJObject()
  var query_564360 = newJObject()
  add(path_564359, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_564360, "start", newJString(start))
  add(query_564360, "top", newJInt(top))
  result = call_564358.call(path_564359, query_564360, nil, nil, nil)

var largePersonGroupPersonList* = Call_LargePersonGroupPersonList_564351(
    name: "largePersonGroupPersonList", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons",
    validator: validate_LargePersonGroupPersonList_564352, base: "",
    url: url_LargePersonGroupPersonList_564353, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonGet_564370 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonGet_564372(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonGet_564371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_564373 = path.getOrDefault("largePersonGroupId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "largePersonGroupId", valid_564373
  var valid_564374 = path.getOrDefault("personId")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "personId", valid_564374
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_LargePersonGroupPersonGet_564370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_LargePersonGroupPersonGet_564370;
          largePersonGroupId: string; personId: string): Recallable =
  ## largePersonGroupPersonGet
  ## Retrieve a person's name and userData, and the persisted faceIds representing the registered person face feature.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_564377 = newJObject()
  add(path_564377, "largePersonGroupId", newJString(largePersonGroupId))
  add(path_564377, "personId", newJString(personId))
  result = call_564376.call(path_564377, nil, nil, nil, nil)

var largePersonGroupPersonGet* = Call_LargePersonGroupPersonGet_564370(
    name: "largePersonGroupPersonGet", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonGet_564371, base: "",
    url: url_LargePersonGroupPersonGet_564372, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonUpdate_564386 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonUpdate_564388(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonUpdate_564387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update name or userData of a person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_564389 = path.getOrDefault("largePersonGroupId")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "largePersonGroupId", valid_564389
  var valid_564390 = path.getOrDefault("personId")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "personId", valid_564390
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

proc call*(call_564392: Call_LargePersonGroupPersonUpdate_564386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update name or userData of a person.
  ## 
  let valid = call_564392.validator(path, query, header, formData, body)
  let scheme = call_564392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564392.url(scheme.get, call_564392.host, call_564392.base,
                         call_564392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564392, url, valid)

proc call*(call_564393: Call_LargePersonGroupPersonUpdate_564386;
          largePersonGroupId: string; body: JsonNode; personId: string): Recallable =
  ## largePersonGroupPersonUpdate
  ## Update name or userData of a person.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_564394 = newJObject()
  var body_564395 = newJObject()
  add(path_564394, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_564395 = body
  add(path_564394, "personId", newJString(personId))
  result = call_564393.call(path_564394, nil, nil, nil, body_564395)

var largePersonGroupPersonUpdate* = Call_LargePersonGroupPersonUpdate_564386(
    name: "largePersonGroupPersonUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonUpdate_564387, base: "",
    url: url_LargePersonGroupPersonUpdate_564388, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonDelete_564378 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonDelete_564380(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonDelete_564379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_564381 = path.getOrDefault("largePersonGroupId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "largePersonGroupId", valid_564381
  var valid_564382 = path.getOrDefault("personId")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "personId", valid_564382
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564383: Call_LargePersonGroupPersonDelete_564378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  let valid = call_564383.validator(path, query, header, formData, body)
  let scheme = call_564383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564383.url(scheme.get, call_564383.host, call_564383.base,
                         call_564383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564383, url, valid)

proc call*(call_564384: Call_LargePersonGroupPersonDelete_564378;
          largePersonGroupId: string; personId: string): Recallable =
  ## largePersonGroupPersonDelete
  ## Delete an existing person from a large person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_564385 = newJObject()
  add(path_564385, "largePersonGroupId", newJString(largePersonGroupId))
  add(path_564385, "personId", newJString(personId))
  result = call_564384.call(path_564385, nil, nil, nil, nil)

var largePersonGroupPersonDelete* = Call_LargePersonGroupPersonDelete_564378(
    name: "largePersonGroupPersonDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/persons/{personId}",
    validator: validate_LargePersonGroupPersonDelete_564379, base: "",
    url: url_LargePersonGroupPersonDelete_564380, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonAddFaceFromUrl_564396 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonAddFaceFromUrl_564398(protocol: Scheme;
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

proc validate_LargePersonGroupPersonAddFaceFromUrl_564397(path: JsonNode;
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
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `largePersonGroupId` field"
  var valid_564399 = path.getOrDefault("largePersonGroupId")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "largePersonGroupId", valid_564399
  var valid_564400 = path.getOrDefault("personId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "personId", valid_564400
  result.add "path", section
  ## parameters in `query` object:
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  section = newJObject()
  var valid_564401 = query.getOrDefault("detectionModel")
  valid_564401 = validateParameter(valid_564401, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_564401 != nil:
    section.add "detectionModel", valid_564401
  var valid_564402 = query.getOrDefault("targetFace")
  valid_564402 = validateParameter(valid_564402, JArray, required = false,
                                 default = nil)
  if valid_564402 != nil:
    section.add "targetFace", valid_564402
  var valid_564403 = query.getOrDefault("userData")
  valid_564403 = validateParameter(valid_564403, JString, required = false,
                                 default = nil)
  if valid_564403 != nil:
    section.add "userData", valid_564403
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

proc call*(call_564405: Call_LargePersonGroupPersonAddFaceFromUrl_564396;
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
  let valid = call_564405.validator(path, query, header, formData, body)
  let scheme = call_564405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564405.url(scheme.get, call_564405.host, call_564405.base,
                         call_564405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564405, url, valid)

proc call*(call_564406: Call_LargePersonGroupPersonAddFaceFromUrl_564396;
          largePersonGroupId: string; personId: string; ImageUrl: JsonNode;
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil;
          userData: string = ""): Recallable =
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
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var path_564407 = newJObject()
  var query_564408 = newJObject()
  var body_564409 = newJObject()
  add(query_564408, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_564408.add "targetFace", targetFace
  add(path_564407, "largePersonGroupId", newJString(largePersonGroupId))
  add(query_564408, "userData", newJString(userData))
  add(path_564407, "personId", newJString(personId))
  if ImageUrl != nil:
    body_564409 = ImageUrl
  result = call_564406.call(path_564407, query_564408, nil, nil, body_564409)

var largePersonGroupPersonAddFaceFromUrl* = Call_LargePersonGroupPersonAddFaceFromUrl_564396(
    name: "largePersonGroupPersonAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces",
    validator: validate_LargePersonGroupPersonAddFaceFromUrl_564397, base: "",
    url: url_LargePersonGroupPersonAddFaceFromUrl_564398, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonGetFace_564410 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonGetFace_564412(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonGetFace_564411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564413 = path.getOrDefault("persistedFaceId")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "persistedFaceId", valid_564413
  var valid_564414 = path.getOrDefault("largePersonGroupId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "largePersonGroupId", valid_564414
  var valid_564415 = path.getOrDefault("personId")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "personId", valid_564415
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564416: Call_LargePersonGroupPersonGetFace_564410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ## 
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_LargePersonGroupPersonGetFace_564410;
          persistedFaceId: string; largePersonGroupId: string; personId: string): Recallable =
  ## largePersonGroupPersonGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging largePersonGroupId).
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_564418 = newJObject()
  add(path_564418, "persistedFaceId", newJString(persistedFaceId))
  add(path_564418, "largePersonGroupId", newJString(largePersonGroupId))
  add(path_564418, "personId", newJString(personId))
  result = call_564417.call(path_564418, nil, nil, nil, nil)

var largePersonGroupPersonGetFace* = Call_LargePersonGroupPersonGetFace_564410(
    name: "largePersonGroupPersonGetFace", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonGetFace_564411, base: "",
    url: url_LargePersonGroupPersonGetFace_564412, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonUpdateFace_564428 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonUpdateFace_564430(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonUpdateFace_564429(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a person persisted face's userData field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564431 = path.getOrDefault("persistedFaceId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "persistedFaceId", valid_564431
  var valid_564432 = path.getOrDefault("largePersonGroupId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "largePersonGroupId", valid_564432
  var valid_564433 = path.getOrDefault("personId")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "personId", valid_564433
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

proc call*(call_564435: Call_LargePersonGroupPersonUpdateFace_564428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a person persisted face's userData field.
  ## 
  let valid = call_564435.validator(path, query, header, formData, body)
  let scheme = call_564435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564435.url(scheme.get, call_564435.host, call_564435.base,
                         call_564435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564435, url, valid)

proc call*(call_564436: Call_LargePersonGroupPersonUpdateFace_564428;
          persistedFaceId: string; largePersonGroupId: string; body: JsonNode;
          personId: string): Recallable =
  ## largePersonGroupPersonUpdateFace
  ## Update a person persisted face's userData field.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_564437 = newJObject()
  var body_564438 = newJObject()
  add(path_564437, "persistedFaceId", newJString(persistedFaceId))
  add(path_564437, "largePersonGroupId", newJString(largePersonGroupId))
  if body != nil:
    body_564438 = body
  add(path_564437, "personId", newJString(personId))
  result = call_564436.call(path_564437, nil, nil, nil, body_564438)

var largePersonGroupPersonUpdateFace* = Call_LargePersonGroupPersonUpdateFace_564428(
    name: "largePersonGroupPersonUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonUpdateFace_564429, base: "",
    url: url_LargePersonGroupPersonUpdateFace_564430, schemes: {Scheme.Https})
type
  Call_LargePersonGroupPersonDeleteFace_564419 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupPersonDeleteFace_564421(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupPersonDeleteFace_564420(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   largePersonGroupId: JString (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564422 = path.getOrDefault("persistedFaceId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "persistedFaceId", valid_564422
  var valid_564423 = path.getOrDefault("largePersonGroupId")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "largePersonGroupId", valid_564423
  var valid_564424 = path.getOrDefault("personId")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "personId", valid_564424
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_LargePersonGroupPersonDeleteFace_564419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_LargePersonGroupPersonDeleteFace_564419;
          persistedFaceId: string; largePersonGroupId: string; personId: string): Recallable =
  ## largePersonGroupPersonDeleteFace
  ## Delete a face from a person in a large person group by specified largePersonGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  var path_564427 = newJObject()
  add(path_564427, "persistedFaceId", newJString(persistedFaceId))
  add(path_564427, "largePersonGroupId", newJString(largePersonGroupId))
  add(path_564427, "personId", newJString(personId))
  result = call_564426.call(path_564427, nil, nil, nil, nil)

var largePersonGroupPersonDeleteFace* = Call_LargePersonGroupPersonDeleteFace_564419(
    name: "largePersonGroupPersonDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/largepersongroups/{largePersonGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_LargePersonGroupPersonDeleteFace_564420, base: "",
    url: url_LargePersonGroupPersonDeleteFace_564421, schemes: {Scheme.Https})
type
  Call_LargePersonGroupTrain_564439 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupTrain_564441(protocol: Scheme; host: string; base: string;
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

proc validate_LargePersonGroupTrain_564440(path: JsonNode; query: JsonNode;
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
  var valid_564442 = path.getOrDefault("largePersonGroupId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "largePersonGroupId", valid_564442
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564443: Call_LargePersonGroupTrain_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a large person group training task, the training task may not be started immediately.
  ## 
  let valid = call_564443.validator(path, query, header, formData, body)
  let scheme = call_564443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564443.url(scheme.get, call_564443.host, call_564443.base,
                         call_564443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564443, url, valid)

proc call*(call_564444: Call_LargePersonGroupTrain_564439;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupTrain
  ## Queue a large person group training task, the training task may not be started immediately.
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_564445 = newJObject()
  add(path_564445, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_564444.call(path_564445, nil, nil, nil, nil)

var largePersonGroupTrain* = Call_LargePersonGroupTrain_564439(
    name: "largePersonGroupTrain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/train",
    validator: validate_LargePersonGroupTrain_564440, base: "",
    url: url_LargePersonGroupTrain_564441, schemes: {Scheme.Https})
type
  Call_LargePersonGroupGetTrainingStatus_564446 = ref object of OpenApiRestCall_563566
proc url_LargePersonGroupGetTrainingStatus_564448(protocol: Scheme; host: string;
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

proc validate_LargePersonGroupGetTrainingStatus_564447(path: JsonNode;
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
  var valid_564449 = path.getOrDefault("largePersonGroupId")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "largePersonGroupId", valid_564449
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_LargePersonGroupGetTrainingStatus_564446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the training status of a large person group (completed or ongoing).
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_LargePersonGroupGetTrainingStatus_564446;
          largePersonGroupId: string): Recallable =
  ## largePersonGroupGetTrainingStatus
  ## Retrieve the training status of a large person group (completed or ongoing).
  ##   largePersonGroupId: string (required)
  ##                     : Id referencing a particular large person group.
  var path_564452 = newJObject()
  add(path_564452, "largePersonGroupId", newJString(largePersonGroupId))
  result = call_564451.call(path_564452, nil, nil, nil, nil)

var largePersonGroupGetTrainingStatus* = Call_LargePersonGroupGetTrainingStatus_564446(
    name: "largePersonGroupGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/largepersongroups/{largePersonGroupId}/training",
    validator: validate_LargePersonGroupGetTrainingStatus_564447, base: "",
    url: url_LargePersonGroupGetTrainingStatus_564448, schemes: {Scheme.Https})
type
  Call_SnapshotGetOperationStatus_564453 = ref object of OpenApiRestCall_563566
proc url_SnapshotGetOperationStatus_564455(protocol: Scheme; host: string;
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

proc validate_SnapshotGetOperationStatus_564454(path: JsonNode; query: JsonNode;
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
  var valid_564456 = path.getOrDefault("operationId")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "operationId", valid_564456
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564457: Call_SnapshotGetOperationStatus_564453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the status of a take/apply snapshot operation.
  ## 
  let valid = call_564457.validator(path, query, header, formData, body)
  let scheme = call_564457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564457.url(scheme.get, call_564457.host, call_564457.base,
                         call_564457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564457, url, valid)

proc call*(call_564458: Call_SnapshotGetOperationStatus_564453; operationId: string): Recallable =
  ## snapshotGetOperationStatus
  ## Retrieve the status of a take/apply snapshot operation.
  ##   operationId: string (required)
  ##              : Id referencing a particular take/apply snapshot operation.
  var path_564459 = newJObject()
  add(path_564459, "operationId", newJString(operationId))
  result = call_564458.call(path_564459, nil, nil, nil, nil)

var snapshotGetOperationStatus* = Call_SnapshotGetOperationStatus_564453(
    name: "snapshotGetOperationStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/operations/{operationId}",
    validator: validate_SnapshotGetOperationStatus_564454, base: "",
    url: url_SnapshotGetOperationStatus_564455, schemes: {Scheme.Https})
type
  Call_PersonGroupList_564460 = ref object of OpenApiRestCall_563566
proc url_PersonGroupList_564462(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PersonGroupList_564461(path: JsonNode; query: JsonNode;
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
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: JString
  ##        : List person groups from the least personGroupId greater than the "start".
  ##   top: JInt
  ##      : The number of person groups to list.
  section = newJObject()
  var valid_564463 = query.getOrDefault("returnRecognitionModel")
  valid_564463 = validateParameter(valid_564463, JBool, required = false,
                                 default = newJBool(false))
  if valid_564463 != nil:
    section.add "returnRecognitionModel", valid_564463
  var valid_564464 = query.getOrDefault("start")
  valid_564464 = validateParameter(valid_564464, JString, required = false,
                                 default = nil)
  if valid_564464 != nil:
    section.add "start", valid_564464
  var valid_564465 = query.getOrDefault("top")
  valid_564465 = validateParameter(valid_564465, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564465 != nil:
    section.add "top", valid_564465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564466: Call_PersonGroupList_564460; path: JsonNode; query: JsonNode;
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
  let valid = call_564466.validator(path, query, header, formData, body)
  let scheme = call_564466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564466.url(scheme.get, call_564466.host, call_564466.base,
                         call_564466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564466, url, valid)

proc call*(call_564467: Call_PersonGroupList_564460;
          returnRecognitionModel: bool = false; start: string = ""; top: int = 1000): Recallable =
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
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   start: string
  ##        : List person groups from the least personGroupId greater than the "start".
  ##   top: int
  ##      : The number of person groups to list.
  var query_564468 = newJObject()
  add(query_564468, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(query_564468, "start", newJString(start))
  add(query_564468, "top", newJInt(top))
  result = call_564467.call(nil, query_564468, nil, nil, nil)

var personGroupList* = Call_PersonGroupList_564460(name: "personGroupList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/persongroups",
    validator: validate_PersonGroupList_564461, base: "", url: url_PersonGroupList_564462,
    schemes: {Scheme.Https})
type
  Call_PersonGroupCreate_564478 = ref object of OpenApiRestCall_563566
proc url_PersonGroupCreate_564480(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupCreate_564479(path: JsonNode; query: JsonNode;
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
  var valid_564481 = path.getOrDefault("personGroupId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "personGroupId", valid_564481
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

proc call*(call_564483: Call_PersonGroupCreate_564478; path: JsonNode;
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
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_PersonGroupCreate_564478; body: JsonNode;
          personGroupId: string): Recallable =
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
  ##   body: JObject (required)
  ##       : Request body for creating new person group.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564485 = newJObject()
  var body_564486 = newJObject()
  if body != nil:
    body_564486 = body
  add(path_564485, "personGroupId", newJString(personGroupId))
  result = call_564484.call(path_564485, nil, nil, nil, body_564486)

var personGroupCreate* = Call_PersonGroupCreate_564478(name: "personGroupCreate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupCreate_564479,
    base: "", url: url_PersonGroupCreate_564480, schemes: {Scheme.Https})
type
  Call_PersonGroupGet_564469 = ref object of OpenApiRestCall_563566
proc url_PersonGroupGet_564471(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupGet_564470(path: JsonNode; query: JsonNode;
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
  var valid_564472 = path.getOrDefault("personGroupId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "personGroupId", valid_564472
  result.add "path", section
  ## parameters in `query` object:
  ##   returnRecognitionModel: JBool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  section = newJObject()
  var valid_564473 = query.getOrDefault("returnRecognitionModel")
  valid_564473 = validateParameter(valid_564473, JBool, required = false,
                                 default = newJBool(false))
  if valid_564473 != nil:
    section.add "returnRecognitionModel", valid_564473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564474: Call_PersonGroupGet_564469; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ## 
  let valid = call_564474.validator(path, query, header, formData, body)
  let scheme = call_564474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564474.url(scheme.get, call_564474.host, call_564474.base,
                         call_564474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564474, url, valid)

proc call*(call_564475: Call_PersonGroupGet_564469; personGroupId: string;
          returnRecognitionModel: bool = false): Recallable =
  ## personGroupGet
  ## Retrieve person group name, userData and recognitionModel. To get person information under this personGroup, use [PersonGroup Person - List](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395241).
  ##   returnRecognitionModel: bool
  ##                         : A value indicating whether the operation should return 'recognitionModel' in response.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564476 = newJObject()
  var query_564477 = newJObject()
  add(query_564477, "returnRecognitionModel", newJBool(returnRecognitionModel))
  add(path_564476, "personGroupId", newJString(personGroupId))
  result = call_564475.call(path_564476, query_564477, nil, nil, nil)

var personGroupGet* = Call_PersonGroupGet_564469(name: "personGroupGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupGet_564470,
    base: "", url: url_PersonGroupGet_564471, schemes: {Scheme.Https})
type
  Call_PersonGroupUpdate_564494 = ref object of OpenApiRestCall_563566
proc url_PersonGroupUpdate_564496(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupUpdate_564495(path: JsonNode; query: JsonNode;
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
  var valid_564497 = path.getOrDefault("personGroupId")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "personGroupId", valid_564497
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

proc call*(call_564499: Call_PersonGroupUpdate_564494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ## 
  let valid = call_564499.validator(path, query, header, formData, body)
  let scheme = call_564499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564499.url(scheme.get, call_564499.host, call_564499.base,
                         call_564499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564499, url, valid)

proc call*(call_564500: Call_PersonGroupUpdate_564494; body: JsonNode;
          personGroupId: string): Recallable =
  ## personGroupUpdate
  ## Update an existing person group's display name and userData. The properties which does not appear in request body will not be updated.
  ##   body: JObject (required)
  ##       : Request body for updating person group.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564501 = newJObject()
  var body_564502 = newJObject()
  if body != nil:
    body_564502 = body
  add(path_564501, "personGroupId", newJString(personGroupId))
  result = call_564500.call(path_564501, nil, nil, nil, body_564502)

var personGroupUpdate* = Call_PersonGroupUpdate_564494(name: "personGroupUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupUpdate_564495,
    base: "", url: url_PersonGroupUpdate_564496, schemes: {Scheme.Https})
type
  Call_PersonGroupDelete_564487 = ref object of OpenApiRestCall_563566
proc url_PersonGroupDelete_564489(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupDelete_564488(path: JsonNode; query: JsonNode;
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
  var valid_564490 = path.getOrDefault("personGroupId")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "personGroupId", valid_564490
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564491: Call_PersonGroupDelete_564487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ## 
  let valid = call_564491.validator(path, query, header, formData, body)
  let scheme = call_564491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564491.url(scheme.get, call_564491.host, call_564491.base,
                         call_564491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564491, url, valid)

proc call*(call_564492: Call_PersonGroupDelete_564487; personGroupId: string): Recallable =
  ## personGroupDelete
  ## Delete an existing person group. Persisted face features of all people in the person group will also be deleted.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564493 = newJObject()
  add(path_564493, "personGroupId", newJString(personGroupId))
  result = call_564492.call(path_564493, nil, nil, nil, nil)

var personGroupDelete* = Call_PersonGroupDelete_564487(name: "personGroupDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/persongroups/{personGroupId}", validator: validate_PersonGroupDelete_564488,
    base: "", url: url_PersonGroupDelete_564489, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonCreate_564513 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonCreate_564515(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupPersonCreate_564514(path: JsonNode; query: JsonNode;
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
  var valid_564516 = path.getOrDefault("personGroupId")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "personGroupId", valid_564516
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

proc call*(call_564518: Call_PersonGroupPersonCreate_564513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new person in a specified person group.
  ## 
  let valid = call_564518.validator(path, query, header, formData, body)
  let scheme = call_564518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564518.url(scheme.get, call_564518.host, call_564518.base,
                         call_564518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564518, url, valid)

proc call*(call_564519: Call_PersonGroupPersonCreate_564513; body: JsonNode;
          personGroupId: string): Recallable =
  ## personGroupPersonCreate
  ## Create a new person in a specified person group.
  ##   body: JObject (required)
  ##       : Request body for creating new person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564520 = newJObject()
  var body_564521 = newJObject()
  if body != nil:
    body_564521 = body
  add(path_564520, "personGroupId", newJString(personGroupId))
  result = call_564519.call(path_564520, nil, nil, nil, body_564521)

var personGroupPersonCreate* = Call_PersonGroupPersonCreate_564513(
    name: "personGroupPersonCreate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons",
    validator: validate_PersonGroupPersonCreate_564514, base: "",
    url: url_PersonGroupPersonCreate_564515, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonList_564503 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonList_564505(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupPersonList_564504(path: JsonNode; query: JsonNode;
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
  var valid_564506 = path.getOrDefault("personGroupId")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "personGroupId", valid_564506
  result.add "path", section
  ## parameters in `query` object:
  ##   start: JString
  ##        : Starting person id to return (used to list a range of persons).
  ##   top: JInt
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  section = newJObject()
  var valid_564507 = query.getOrDefault("start")
  valid_564507 = validateParameter(valid_564507, JString, required = false,
                                 default = nil)
  if valid_564507 != nil:
    section.add "start", valid_564507
  var valid_564508 = query.getOrDefault("top")
  valid_564508 = validateParameter(valid_564508, JInt, required = false, default = nil)
  if valid_564508 != nil:
    section.add "top", valid_564508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564509: Call_PersonGroupPersonList_564503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ## 
  let valid = call_564509.validator(path, query, header, formData, body)
  let scheme = call_564509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564509.url(scheme.get, call_564509.host, call_564509.base,
                         call_564509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564509, url, valid)

proc call*(call_564510: Call_PersonGroupPersonList_564503; personGroupId: string;
          start: string = ""; top: int = 0): Recallable =
  ## personGroupPersonList
  ## List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
  ##   start: string
  ##        : Starting person id to return (used to list a range of persons).
  ##   top: int
  ##      : Number of persons to return starting with the person id indicated by the 'start' parameter.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564511 = newJObject()
  var query_564512 = newJObject()
  add(query_564512, "start", newJString(start))
  add(query_564512, "top", newJInt(top))
  add(path_564511, "personGroupId", newJString(personGroupId))
  result = call_564510.call(path_564511, query_564512, nil, nil, nil)

var personGroupPersonList* = Call_PersonGroupPersonList_564503(
    name: "personGroupPersonList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons",
    validator: validate_PersonGroupPersonList_564504, base: "",
    url: url_PersonGroupPersonList_564505, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonGet_564522 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonGet_564524(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupPersonGet_564523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_564525 = path.getOrDefault("personId")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "personId", valid_564525
  var valid_564526 = path.getOrDefault("personGroupId")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "personGroupId", valid_564526
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564527: Call_PersonGroupPersonGet_564522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ## 
  let valid = call_564527.validator(path, query, header, formData, body)
  let scheme = call_564527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564527.url(scheme.get, call_564527.host, call_564527.base,
                         call_564527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564527, url, valid)

proc call*(call_564528: Call_PersonGroupPersonGet_564522; personId: string;
          personGroupId: string): Recallable =
  ## personGroupPersonGet
  ## Retrieve a person's information, including registered persisted faces, name and userData.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564529 = newJObject()
  add(path_564529, "personId", newJString(personId))
  add(path_564529, "personGroupId", newJString(personGroupId))
  result = call_564528.call(path_564529, nil, nil, nil, nil)

var personGroupPersonGet* = Call_PersonGroupPersonGet_564522(
    name: "personGroupPersonGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonGet_564523, base: "",
    url: url_PersonGroupPersonGet_564524, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonUpdate_564538 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonUpdate_564540(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupPersonUpdate_564539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update name or userData of a person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_564541 = path.getOrDefault("personId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "personId", valid_564541
  var valid_564542 = path.getOrDefault("personGroupId")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "personGroupId", valid_564542
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

proc call*(call_564544: Call_PersonGroupPersonUpdate_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update name or userData of a person.
  ## 
  let valid = call_564544.validator(path, query, header, formData, body)
  let scheme = call_564544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564544.url(scheme.get, call_564544.host, call_564544.base,
                         call_564544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564544, url, valid)

proc call*(call_564545: Call_PersonGroupPersonUpdate_564538; body: JsonNode;
          personId: string; personGroupId: string): Recallable =
  ## personGroupPersonUpdate
  ## Update name or userData of a person.
  ##   body: JObject (required)
  ##       : Request body for person update operation.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564546 = newJObject()
  var body_564547 = newJObject()
  if body != nil:
    body_564547 = body
  add(path_564546, "personId", newJString(personId))
  add(path_564546, "personGroupId", newJString(personGroupId))
  result = call_564545.call(path_564546, nil, nil, nil, body_564547)

var personGroupPersonUpdate* = Call_PersonGroupPersonUpdate_564538(
    name: "personGroupPersonUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonUpdate_564539, base: "",
    url: url_PersonGroupPersonUpdate_564540, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonDelete_564530 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonDelete_564532(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupPersonDelete_564531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_564533 = path.getOrDefault("personId")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "personId", valid_564533
  var valid_564534 = path.getOrDefault("personGroupId")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "personGroupId", valid_564534
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564535: Call_PersonGroupPersonDelete_564530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ## 
  let valid = call_564535.validator(path, query, header, formData, body)
  let scheme = call_564535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564535.url(scheme.get, call_564535.host, call_564535.base,
                         call_564535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564535, url, valid)

proc call*(call_564536: Call_PersonGroupPersonDelete_564530; personId: string;
          personGroupId: string): Recallable =
  ## personGroupPersonDelete
  ## Delete an existing person from a person group. The persistedFaceId, userData, person name and face feature in the person entry will all be deleted.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564537 = newJObject()
  add(path_564537, "personId", newJString(personId))
  add(path_564537, "personGroupId", newJString(personGroupId))
  result = call_564536.call(path_564537, nil, nil, nil, nil)

var personGroupPersonDelete* = Call_PersonGroupPersonDelete_564530(
    name: "personGroupPersonDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}",
    validator: validate_PersonGroupPersonDelete_564531, base: "",
    url: url_PersonGroupPersonDelete_564532, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonAddFaceFromUrl_564548 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonAddFaceFromUrl_564550(protocol: Scheme; host: string;
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

proc validate_PersonGroupPersonAddFaceFromUrl_564549(path: JsonNode;
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
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `personId` field"
  var valid_564551 = path.getOrDefault("personId")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "personId", valid_564551
  var valid_564552 = path.getOrDefault("personGroupId")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "personGroupId", valid_564552
  result.add "path", section
  ## parameters in `query` object:
  ##   detectionModel: JString
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: JString
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  section = newJObject()
  var valid_564553 = query.getOrDefault("detectionModel")
  valid_564553 = validateParameter(valid_564553, JString, required = false,
                                 default = newJString("detection_01"))
  if valid_564553 != nil:
    section.add "detectionModel", valid_564553
  var valid_564554 = query.getOrDefault("targetFace")
  valid_564554 = validateParameter(valid_564554, JArray, required = false,
                                 default = nil)
  if valid_564554 != nil:
    section.add "targetFace", valid_564554
  var valid_564555 = query.getOrDefault("userData")
  valid_564555 = validateParameter(valid_564555, JString, required = false,
                                 default = nil)
  if valid_564555 != nil:
    section.add "userData", valid_564555
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

proc call*(call_564557: Call_PersonGroupPersonAddFaceFromUrl_564548;
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
  let valid = call_564557.validator(path, query, header, formData, body)
  let scheme = call_564557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564557.url(scheme.get, call_564557.host, call_564557.base,
                         call_564557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564557, url, valid)

proc call*(call_564558: Call_PersonGroupPersonAddFaceFromUrl_564548;
          personId: string; personGroupId: string; ImageUrl: JsonNode;
          detectionModel: string = "detection_01"; targetFace: JsonNode = nil;
          userData: string = ""): Recallable =
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
  ##   detectionModel: string
  ##                 : Name of detection model. Detection model is used to detect faces in the submitted image. A detection model name can be provided when performing Face - Detect or (Large)FaceList - Add Face or (Large)PersonGroup - Add Face. The default value is 'detection_01', if another model is needed, please explicitly specify it.
  ##   targetFace: JArray
  ##             : A face rectangle to specify the target face to be added to a person in the format of "targetFace=left,top,width,height". E.g. "targetFace=10,10,100,100". If there is more than one face in the image, targetFace is required to specify which face to add. No targetFace means there is only one face detected in the entire image.
  ##   userData: string
  ##           : User-specified data about the face for any purpose. The maximum length is 1KB.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var path_564559 = newJObject()
  var query_564560 = newJObject()
  var body_564561 = newJObject()
  add(query_564560, "detectionModel", newJString(detectionModel))
  if targetFace != nil:
    query_564560.add "targetFace", targetFace
  add(query_564560, "userData", newJString(userData))
  add(path_564559, "personId", newJString(personId))
  add(path_564559, "personGroupId", newJString(personGroupId))
  if ImageUrl != nil:
    body_564561 = ImageUrl
  result = call_564558.call(path_564559, query_564560, nil, nil, body_564561)

var personGroupPersonAddFaceFromUrl* = Call_PersonGroupPersonAddFaceFromUrl_564548(
    name: "personGroupPersonAddFaceFromUrl", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces",
    validator: validate_PersonGroupPersonAddFaceFromUrl_564549, base: "",
    url: url_PersonGroupPersonAddFaceFromUrl_564550, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonGetFace_564562 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonGetFace_564564(protocol: Scheme; host: string;
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

proc validate_PersonGroupPersonGetFace_564563(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564565 = path.getOrDefault("persistedFaceId")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "persistedFaceId", valid_564565
  var valid_564566 = path.getOrDefault("personId")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "personId", valid_564566
  var valid_564567 = path.getOrDefault("personGroupId")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "personGroupId", valid_564567
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564568: Call_PersonGroupPersonGetFace_564562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ## 
  let valid = call_564568.validator(path, query, header, formData, body)
  let scheme = call_564568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564568.url(scheme.get, call_564568.host, call_564568.base,
                         call_564568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564568, url, valid)

proc call*(call_564569: Call_PersonGroupPersonGetFace_564562;
          persistedFaceId: string; personId: string; personGroupId: string): Recallable =
  ## personGroupPersonGetFace
  ## Retrieve information about a persisted face (specified by persistedFaceId, personId and its belonging personGroupId).
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564570 = newJObject()
  add(path_564570, "persistedFaceId", newJString(persistedFaceId))
  add(path_564570, "personId", newJString(personId))
  add(path_564570, "personGroupId", newJString(personGroupId))
  result = call_564569.call(path_564570, nil, nil, nil, nil)

var personGroupPersonGetFace* = Call_PersonGroupPersonGetFace_564562(
    name: "personGroupPersonGetFace", meth: HttpMethod.HttpGet, host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonGetFace_564563, base: "",
    url: url_PersonGroupPersonGetFace_564564, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonUpdateFace_564580 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonUpdateFace_564582(protocol: Scheme; host: string;
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

proc validate_PersonGroupPersonUpdateFace_564581(path: JsonNode; query: JsonNode;
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
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564583 = path.getOrDefault("persistedFaceId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "persistedFaceId", valid_564583
  var valid_564584 = path.getOrDefault("personId")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "personId", valid_564584
  var valid_564585 = path.getOrDefault("personGroupId")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "personGroupId", valid_564585
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

proc call*(call_564587: Call_PersonGroupPersonUpdateFace_564580; path: JsonNode;
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
  let valid = call_564587.validator(path, query, header, formData, body)
  let scheme = call_564587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564587.url(scheme.get, call_564587.host, call_564587.base,
                         call_564587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564587, url, valid)

proc call*(call_564588: Call_PersonGroupPersonUpdateFace_564580;
          persistedFaceId: string; body: JsonNode; personId: string;
          personGroupId: string): Recallable =
  ## personGroupPersonUpdateFace
  ## Add a face to a person into a person group for face identification or verification. To deal with an image contains multiple faces, input face can be specified as an image with a targetFace rectangle. It returns a persistedFaceId representing the added face. No image will be stored. Only the extracted face feature will be stored on server until [PersonGroup PersonFace - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523e), [PersonGroup Person - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f3039523d) or [PersonGroup - Delete](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395245) is called.
  ## <br /> Note persistedFaceId is different from faceId generated by [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236).
  ## * Higher face image quality means better recognition precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * Each person entry can hold up to 248 faces.
  ## * JPEG, PNG, GIF (the first frame), and BMP format are supported. The allowed image file size is from 1KB to 6MB.
  ## * "targetFace" rectangle should contain one face. Zero or multiple faces will be regarded as an error. If the provided "targetFace" rectangle is not returned from [Face - Detect](/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236), there’s no guarantee to detect and add the face successfully.
  ## * Out of detectable face size (36x36 - 4096x4096 pixels), large head-pose, or large occlusions will cause failures.
  ## * Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   body: JObject (required)
  ##       : Request body for updating persisted face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564589 = newJObject()
  var body_564590 = newJObject()
  add(path_564589, "persistedFaceId", newJString(persistedFaceId))
  if body != nil:
    body_564590 = body
  add(path_564589, "personId", newJString(personId))
  add(path_564589, "personGroupId", newJString(personGroupId))
  result = call_564588.call(path_564589, nil, nil, nil, body_564590)

var personGroupPersonUpdateFace* = Call_PersonGroupPersonUpdateFace_564580(
    name: "personGroupPersonUpdateFace", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonUpdateFace_564581, base: "",
    url: url_PersonGroupPersonUpdateFace_564582, schemes: {Scheme.Https})
type
  Call_PersonGroupPersonDeleteFace_564571 = ref object of OpenApiRestCall_563566
proc url_PersonGroupPersonDeleteFace_564573(protocol: Scheme; host: string;
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

proc validate_PersonGroupPersonDeleteFace_564572(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   persistedFaceId: JString (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: JString (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: JString (required)
  ##                : Id referencing a particular person group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `persistedFaceId` field"
  var valid_564574 = path.getOrDefault("persistedFaceId")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "persistedFaceId", valid_564574
  var valid_564575 = path.getOrDefault("personId")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "personId", valid_564575
  var valid_564576 = path.getOrDefault("personGroupId")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "personGroupId", valid_564576
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564577: Call_PersonGroupPersonDeleteFace_564571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ## 
  let valid = call_564577.validator(path, query, header, formData, body)
  let scheme = call_564577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564577.url(scheme.get, call_564577.host, call_564577.base,
                         call_564577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564577, url, valid)

proc call*(call_564578: Call_PersonGroupPersonDeleteFace_564571;
          persistedFaceId: string; personId: string; personGroupId: string): Recallable =
  ## personGroupPersonDeleteFace
  ## Delete a face from a person in a person group by specified personGroupId, personId and persistedFaceId.
  ## <br /> Adding/deleting faces to/from a same person will be processed sequentially. Adding/deleting faces to/from different persons are processed in parallel.
  ##   persistedFaceId: string (required)
  ##                  : Id referencing a particular persistedFaceId of an existing face.
  ##   personId: string (required)
  ##           : Id referencing a particular person.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564579 = newJObject()
  add(path_564579, "persistedFaceId", newJString(persistedFaceId))
  add(path_564579, "personId", newJString(personId))
  add(path_564579, "personGroupId", newJString(personGroupId))
  result = call_564578.call(path_564579, nil, nil, nil, nil)

var personGroupPersonDeleteFace* = Call_PersonGroupPersonDeleteFace_564571(
    name: "personGroupPersonDeleteFace", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/persongroups/{personGroupId}/persons/{personId}/persistedfaces/{persistedFaceId}",
    validator: validate_PersonGroupPersonDeleteFace_564572, base: "",
    url: url_PersonGroupPersonDeleteFace_564573, schemes: {Scheme.Https})
type
  Call_PersonGroupTrain_564591 = ref object of OpenApiRestCall_563566
proc url_PersonGroupTrain_564593(protocol: Scheme; host: string; base: string;
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

proc validate_PersonGroupTrain_564592(path: JsonNode; query: JsonNode;
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
  var valid_564594 = path.getOrDefault("personGroupId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "personGroupId", valid_564594
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564595: Call_PersonGroupTrain_564591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queue a person group training task, the training task may not be started immediately.
  ## 
  let valid = call_564595.validator(path, query, header, formData, body)
  let scheme = call_564595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564595.url(scheme.get, call_564595.host, call_564595.base,
                         call_564595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564595, url, valid)

proc call*(call_564596: Call_PersonGroupTrain_564591; personGroupId: string): Recallable =
  ## personGroupTrain
  ## Queue a person group training task, the training task may not be started immediately.
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564597 = newJObject()
  add(path_564597, "personGroupId", newJString(personGroupId))
  result = call_564596.call(path_564597, nil, nil, nil, nil)

var personGroupTrain* = Call_PersonGroupTrain_564591(name: "personGroupTrain",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/persongroups/{personGroupId}/train",
    validator: validate_PersonGroupTrain_564592, base: "",
    url: url_PersonGroupTrain_564593, schemes: {Scheme.Https})
type
  Call_PersonGroupGetTrainingStatus_564598 = ref object of OpenApiRestCall_563566
proc url_PersonGroupGetTrainingStatus_564600(protocol: Scheme; host: string;
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

proc validate_PersonGroupGetTrainingStatus_564599(path: JsonNode; query: JsonNode;
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
  var valid_564601 = path.getOrDefault("personGroupId")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "personGroupId", valid_564601
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564602: Call_PersonGroupGetTrainingStatus_564598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the training status of a person group (completed or ongoing).
  ## 
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_PersonGroupGetTrainingStatus_564598;
          personGroupId: string): Recallable =
  ## personGroupGetTrainingStatus
  ## Retrieve the training status of a person group (completed or ongoing).
  ##   personGroupId: string (required)
  ##                : Id referencing a particular person group.
  var path_564604 = newJObject()
  add(path_564604, "personGroupId", newJString(personGroupId))
  result = call_564603.call(path_564604, nil, nil, nil, nil)

var personGroupGetTrainingStatus* = Call_PersonGroupGetTrainingStatus_564598(
    name: "personGroupGetTrainingStatus", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/persongroups/{personGroupId}/training",
    validator: validate_PersonGroupGetTrainingStatus_564599, base: "",
    url: url_PersonGroupGetTrainingStatus_564600, schemes: {Scheme.Https})
type
  Call_SnapshotTake_564613 = ref object of OpenApiRestCall_563566
proc url_SnapshotTake_564615(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SnapshotTake_564614(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_564617: Call_SnapshotTake_564613; path: JsonNode; query: JsonNode;
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
  let valid = call_564617.validator(path, query, header, formData, body)
  let scheme = call_564617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564617.url(scheme.get, call_564617.host, call_564617.base,
                         call_564617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564617, url, valid)

proc call*(call_564618: Call_SnapshotTake_564613; body: JsonNode): Recallable =
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
  var body_564619 = newJObject()
  if body != nil:
    body_564619 = body
  result = call_564618.call(nil, nil, nil, nil, body_564619)

var snapshotTake* = Call_SnapshotTake_564613(name: "snapshotTake",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/snapshots",
    validator: validate_SnapshotTake_564614, base: "", url: url_SnapshotTake_564615,
    schemes: {Scheme.Https})
type
  Call_SnapshotList_564605 = ref object of OpenApiRestCall_563566
proc url_SnapshotList_564607(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SnapshotList_564606(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   type: JString
  ##       : User specified object type as a search filter.
  ##   applyScope: JArray
  ##             : User specified snapshot apply scopes as a search filter. ApplyScope is an array of the target Azure subscription ids for the snapshot, specified by the user who created the snapshot by Snapshot - Take.
  section = newJObject()
  var valid_564608 = query.getOrDefault("type")
  valid_564608 = validateParameter(valid_564608, JString, required = false,
                                 default = newJString("FaceList"))
  if valid_564608 != nil:
    section.add "type", valid_564608
  var valid_564609 = query.getOrDefault("applyScope")
  valid_564609 = validateParameter(valid_564609, JArray, required = false,
                                 default = nil)
  if valid_564609 != nil:
    section.add "applyScope", valid_564609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564610: Call_SnapshotList_564605; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ## 
  let valid = call_564610.validator(path, query, header, formData, body)
  let scheme = call_564610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564610.url(scheme.get, call_564610.host, call_564610.base,
                         call_564610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564610, url, valid)

proc call*(call_564611: Call_SnapshotList_564605; `type`: string = "FaceList";
          applyScope: JsonNode = nil): Recallable =
  ## snapshotList
  ## List all accessible snapshots with related information, including snapshots that were taken by the user, or snapshots to be applied to the user (subscription id was included in the applyScope in Snapshot - Take).
  ##   type: string
  ##       : User specified object type as a search filter.
  ##   applyScope: JArray
  ##             : User specified snapshot apply scopes as a search filter. ApplyScope is an array of the target Azure subscription ids for the snapshot, specified by the user who created the snapshot by Snapshot - Take.
  var query_564612 = newJObject()
  add(query_564612, "type", newJString(`type`))
  if applyScope != nil:
    query_564612.add "applyScope", applyScope
  result = call_564611.call(nil, query_564612, nil, nil, nil)

var snapshotList* = Call_SnapshotList_564605(name: "snapshotList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/snapshots",
    validator: validate_SnapshotList_564606, base: "", url: url_SnapshotList_564607,
    schemes: {Scheme.Https})
type
  Call_SnapshotGet_564620 = ref object of OpenApiRestCall_563566
proc url_SnapshotGet_564622(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotGet_564621(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564623 = path.getOrDefault("snapshotId")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "snapshotId", valid_564623
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564624: Call_SnapshotGet_564620; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ## 
  let valid = call_564624.validator(path, query, header, formData, body)
  let scheme = call_564624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564624.url(scheme.get, call_564624.host, call_564624.base,
                         call_564624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564624, url, valid)

proc call*(call_564625: Call_SnapshotGet_564620; snapshotId: string): Recallable =
  ## snapshotGet
  ## Retrieve information about a snapshot. Snapshot is only accessible to the source subscription who took it, and target subscriptions included in the applyScope in Snapshot - Take.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  var path_564626 = newJObject()
  add(path_564626, "snapshotId", newJString(snapshotId))
  result = call_564625.call(path_564626, nil, nil, nil, nil)

var snapshotGet* = Call_SnapshotGet_564620(name: "snapshotGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/snapshots/{snapshotId}",
                                        validator: validate_SnapshotGet_564621,
                                        base: "", url: url_SnapshotGet_564622,
                                        schemes: {Scheme.Https})
type
  Call_SnapshotUpdate_564634 = ref object of OpenApiRestCall_563566
proc url_SnapshotUpdate_564636(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotUpdate_564635(path: JsonNode; query: JsonNode;
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
  var valid_564637 = path.getOrDefault("snapshotId")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "snapshotId", valid_564637
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

proc call*(call_564639: Call_SnapshotUpdate_564634; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ## 
  let valid = call_564639.validator(path, query, header, formData, body)
  let scheme = call_564639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564639.url(scheme.get, call_564639.host, call_564639.base,
                         call_564639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564639, url, valid)

proc call*(call_564640: Call_SnapshotUpdate_564634; snapshotId: string;
          body: JsonNode): Recallable =
  ## snapshotUpdate
  ## Update the information of a snapshot. Only the source subscription who took the snapshot can update the snapshot.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  ##   body: JObject (required)
  ##       : Request body for updating a snapshot.
  var path_564641 = newJObject()
  var body_564642 = newJObject()
  add(path_564641, "snapshotId", newJString(snapshotId))
  if body != nil:
    body_564642 = body
  result = call_564640.call(path_564641, nil, nil, nil, body_564642)

var snapshotUpdate* = Call_SnapshotUpdate_564634(name: "snapshotUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/snapshots/{snapshotId}", validator: validate_SnapshotUpdate_564635,
    base: "", url: url_SnapshotUpdate_564636, schemes: {Scheme.Https})
type
  Call_SnapshotDelete_564627 = ref object of OpenApiRestCall_563566
proc url_SnapshotDelete_564629(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotDelete_564628(path: JsonNode; query: JsonNode;
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
  var valid_564630 = path.getOrDefault("snapshotId")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "snapshotId", valid_564630
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564631: Call_SnapshotDelete_564627; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ## 
  let valid = call_564631.validator(path, query, header, formData, body)
  let scheme = call_564631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564631.url(scheme.get, call_564631.host, call_564631.base,
                         call_564631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564631, url, valid)

proc call*(call_564632: Call_SnapshotDelete_564627; snapshotId: string): Recallable =
  ## snapshotDelete
  ## Delete an existing snapshot according to the snapshotId. All object data and information in the snapshot will also be deleted. Only the source subscription who took the snapshot can delete the snapshot. If the user does not delete a snapshot with this API, the snapshot will still be automatically deleted in 48 hours after creation.
  ##   snapshotId: string (required)
  ##             : Id referencing a particular snapshot.
  var path_564633 = newJObject()
  add(path_564633, "snapshotId", newJString(snapshotId))
  result = call_564632.call(path_564633, nil, nil, nil, nil)

var snapshotDelete* = Call_SnapshotDelete_564627(name: "snapshotDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/snapshots/{snapshotId}", validator: validate_SnapshotDelete_564628,
    base: "", url: url_SnapshotDelete_564629, schemes: {Scheme.Https})
type
  Call_SnapshotApply_564643 = ref object of OpenApiRestCall_563566
proc url_SnapshotApply_564645(protocol: Scheme; host: string; base: string;
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

proc validate_SnapshotApply_564644(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564646 = path.getOrDefault("snapshotId")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "snapshotId", valid_564646
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

proc call*(call_564648: Call_SnapshotApply_564643; path: JsonNode; query: JsonNode;
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
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_SnapshotApply_564643; snapshotId: string; body: JsonNode): Recallable =
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
  var path_564650 = newJObject()
  var body_564651 = newJObject()
  add(path_564650, "snapshotId", newJString(snapshotId))
  if body != nil:
    body_564651 = body
  result = call_564649.call(path_564650, nil, nil, nil, body_564651)

var snapshotApply* = Call_SnapshotApply_564643(name: "snapshotApply",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/snapshots/{snapshotId}/apply", validator: validate_SnapshotApply_564644,
    base: "", url: url_SnapshotApply_564645, schemes: {Scheme.Https})
type
  Call_FaceVerifyFaceToFace_564652 = ref object of OpenApiRestCall_563566
proc url_FaceVerifyFaceToFace_564654(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FaceVerifyFaceToFace_564653(path: JsonNode; query: JsonNode;
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

proc call*(call_564656: Call_FaceVerifyFaceToFace_564652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify whether two faces belong to a same person or whether one face belongs to a person.
  ## <br/>
  ## Remarks:<br />
  ## * Higher face image quality means better identification precision. Please consider high-quality faces: frontal, clear, and face size is 200x200 pixels (100 pixels between eyes) or bigger.
  ## * For the scenarios that are sensitive to accuracy please make your own judgment.
  ## * The 'recognitionModel' associated with the query faces' faceIds should be the same as the 'recognitionModel' used by the target face, person group or large person group.
  ## 
  ## 
  let valid = call_564656.validator(path, query, header, formData, body)
  let scheme = call_564656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564656.url(scheme.get, call_564656.host, call_564656.base,
                         call_564656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564656, url, valid)

proc call*(call_564657: Call_FaceVerifyFaceToFace_564652; body: JsonNode): Recallable =
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
  var body_564658 = newJObject()
  if body != nil:
    body_564658 = body
  result = call_564657.call(nil, nil, nil, nil, body_564658)

var faceVerifyFaceToFace* = Call_FaceVerifyFaceToFace_564652(
    name: "faceVerifyFaceToFace", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/verify", validator: validate_FaceVerifyFaceToFace_564653, base: "",
    url: url_FaceVerifyFaceToFace_564654, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
