
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Computer Vision
## version: 1.0
## termsOfService: (not provided)
## license: (not provided)
## 
## The Computer Vision API provides state-of-the-art algorithms to process images and return information. For example, it can be used to determine if an image contains mature content, or it can be used to find all the faces in an image.  It also has other features like estimating dominant and accent colors, categorizing the content of images, and describing an image with complete English sentences.  Additionally, it can also intelligently generate images thumbnails for displaying large images effectively.
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-ComputerVision"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyzeImage_563778 = ref object of OpenApiRestCall_563556
proc url_AnalyzeImage_563780(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyzeImage_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   details: JArray
  ##          : A string indicating which domain-specific details to return. Multiple values should be comma-separated. Valid visual feature types include:Celebrities - identifies celebrities if detected in the image.
  ##   visualFeatures: JArray
  ##                 : A string indicating what visual feature types to return. Multiple values should be comma-separated. Valid visual feature types include:Categories - categorizes image content according to a taxonomy defined in documentation. Tags - tags the image with a detailed list of words related to the image content. Description - describes the image content with a complete English sentence. Faces - detects if faces are present. If present, generate coordinates, gender and age. ImageType - detects if image is clipart or a line drawing. Color - determines the accent color, dominant color, and whether an image is black&white.Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_563941 = query.getOrDefault("details")
  valid_563941 = validateParameter(valid_563941, JArray, required = false,
                                 default = nil)
  if valid_563941 != nil:
    section.add "details", valid_563941
  var valid_563942 = query.getOrDefault("visualFeatures")
  valid_563942 = validateParameter(valid_563942, JArray, required = false,
                                 default = nil)
  if valid_563942 != nil:
    section.add "visualFeatures", valid_563942
  var valid_563956 = query.getOrDefault("language")
  valid_563956 = validateParameter(valid_563956, JString, required = false,
                                 default = newJString("en"))
  if valid_563956 != nil:
    section.add "language", valid_563956
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

proc call*(call_563980: Call_AnalyzeImage_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_AnalyzeImage_563778; ImageUrl: JsonNode;
          details: JsonNode = nil; visualFeatures: JsonNode = nil;
          language: string = "en"): Recallable =
  ## analyzeImage
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ##   details: JArray
  ##          : A string indicating which domain-specific details to return. Multiple values should be comma-separated. Valid visual feature types include:Celebrities - identifies celebrities if detected in the image.
  ##   visualFeatures: JArray
  ##                 : A string indicating what visual feature types to return. Multiple values should be comma-separated. Valid visual feature types include:Categories - categorizes image content according to a taxonomy defined in documentation. Tags - tags the image with a detailed list of words related to the image content. Description - describes the image content with a complete English sentence. Faces - detects if faces are present. If present, generate coordinates, gender and age. ImageType - detects if image is clipart or a line drawing. Color - determines the accent color, dominant color, and whether an image is black&white.Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_564052 = newJObject()
  var body_564054 = newJObject()
  if details != nil:
    query_564052.add "details", details
  if visualFeatures != nil:
    query_564052.add "visualFeatures", visualFeatures
  add(query_564052, "language", newJString(language))
  if ImageUrl != nil:
    body_564054 = ImageUrl
  result = call_564051.call(nil, query_564052, nil, nil, body_564054)

var analyzeImage* = Call_AnalyzeImage_563778(name: "analyzeImage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/analyze",
    validator: validate_AnalyzeImage_563779, base: "/vision/v1.0",
    url: url_AnalyzeImage_563780, schemes: {Scheme.Https})
type
  Call_DescribeImage_564093 = ref object of OpenApiRestCall_563556
proc url_DescribeImage_564095(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DescribeImage_564094(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   maxCandidates: JString
  ##                : Maximum number of candidate descriptions to be returned.  The default is 1.
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_564096 = query.getOrDefault("maxCandidates")
  valid_564096 = validateParameter(valid_564096, JString, required = false,
                                 default = newJString("1"))
  if valid_564096 != nil:
    section.add "maxCandidates", valid_564096
  var valid_564097 = query.getOrDefault("language")
  valid_564097 = validateParameter(valid_564097, JString, required = false,
                                 default = newJString("en"))
  if valid_564097 != nil:
    section.add "language", valid_564097
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

proc call*(call_564099: Call_DescribeImage_564093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_DescribeImage_564093; ImageUrl: JsonNode;
          maxCandidates: string = "1"; language: string = "en"): Recallable =
  ## describeImage
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ##   maxCandidates: string
  ##                : Maximum number of candidate descriptions to be returned.  The default is 1.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_564101 = newJObject()
  var body_564102 = newJObject()
  add(query_564101, "maxCandidates", newJString(maxCandidates))
  add(query_564101, "language", newJString(language))
  if ImageUrl != nil:
    body_564102 = ImageUrl
  result = call_564100.call(nil, query_564101, nil, nil, body_564102)

var describeImage* = Call_DescribeImage_564093(name: "describeImage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/describe",
    validator: validate_DescribeImage_564094, base: "/vision/v1.0",
    url: url_DescribeImage_564095, schemes: {Scheme.Https})
type
  Call_GenerateThumbnail_564103 = ref object of OpenApiRestCall_563556
proc url_GenerateThumbnail_564105(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenerateThumbnail_564104(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   height: JInt (required)
  ##         : Height of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   width: JInt (required)
  ##        : Width of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   smartCropping: JBool
  ##                : Boolean flag for enabling smart cropping.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `height` field"
  var valid_564106 = query.getOrDefault("height")
  valid_564106 = validateParameter(valid_564106, JInt, required = true, default = nil)
  if valid_564106 != nil:
    section.add "height", valid_564106
  var valid_564107 = query.getOrDefault("width")
  valid_564107 = validateParameter(valid_564107, JInt, required = true, default = nil)
  if valid_564107 != nil:
    section.add "width", valid_564107
  var valid_564108 = query.getOrDefault("smartCropping")
  valid_564108 = validateParameter(valid_564108, JBool, required = false,
                                 default = newJBool(false))
  if valid_564108 != nil:
    section.add "smartCropping", valid_564108
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

proc call*(call_564110: Call_GenerateThumbnail_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_GenerateThumbnail_564103; height: int; width: int;
          ImageUrl: JsonNode; smartCropping: bool = false): Recallable =
  ## generateThumbnail
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ##   height: int (required)
  ##         : Height of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   width: int (required)
  ##        : Width of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   smartCropping: bool
  ##                : Boolean flag for enabling smart cropping.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_564112 = newJObject()
  var body_564113 = newJObject()
  add(query_564112, "height", newJInt(height))
  add(query_564112, "width", newJInt(width))
  add(query_564112, "smartCropping", newJBool(smartCropping))
  if ImageUrl != nil:
    body_564113 = ImageUrl
  result = call_564111.call(nil, query_564112, nil, nil, body_564113)

var generateThumbnail* = Call_GenerateThumbnail_564103(name: "generateThumbnail",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/generateThumbnail",
    validator: validate_GenerateThumbnail_564104, base: "/vision/v1.0",
    url: url_GenerateThumbnail_564105, schemes: {Scheme.Https})
type
  Call_ListModels_564114 = ref object of OpenApiRestCall_563556
proc url_ListModels_564116(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListModels_564115(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
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
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ListModels_564114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ListModels_564114): Recallable =
  ## listModels
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  result = call_564118.call(nil, nil, nil, nil, nil)

var listModels* = Call_ListModels_564114(name: "listModels",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/models",
                                      validator: validate_ListModels_564115,
                                      base: "/vision/v1.0", url: url_ListModels_564116,
                                      schemes: {Scheme.Https})
type
  Call_AnalyzeImageByDomain_564119 = ref object of OpenApiRestCall_563556
proc url_AnalyzeImageByDomain_564121(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "model"),
               (kind: ConstantSegment, value: "/analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyzeImageByDomain_564120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : The domain-specific content to recognize.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_564136 = path.getOrDefault("model")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "model", valid_564136
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_564137 = query.getOrDefault("language")
  valid_564137 = validateParameter(valid_564137, JString, required = false,
                                 default = newJString("en"))
  if valid_564137 != nil:
    section.add "language", valid_564137
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

proc call*(call_564139: Call_AnalyzeImageByDomain_564119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_AnalyzeImageByDomain_564119; model: string;
          ImageUrl: JsonNode; language: string = "en"): Recallable =
  ## analyzeImageByDomain
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ##   model: string (required)
  ##        : The domain-specific content to recognize.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  var body_564143 = newJObject()
  add(path_564141, "model", newJString(model))
  add(query_564142, "language", newJString(language))
  if ImageUrl != nil:
    body_564143 = ImageUrl
  result = call_564140.call(path_564141, query_564142, nil, nil, body_564143)

var analyzeImageByDomain* = Call_AnalyzeImageByDomain_564119(
    name: "analyzeImageByDomain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/models/{model}/analyze", validator: validate_AnalyzeImageByDomain_564120,
    base: "/vision/v1.0", url: url_AnalyzeImageByDomain_564121,
    schemes: {Scheme.Https})
type
  Call_RecognizePrintedText_564144 = ref object of OpenApiRestCall_563556
proc url_RecognizePrintedText_564146(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecognizePrintedText_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   detectOrientation: JBool (required)
  ##                    : Whether detect the text orientation in the image. With detectOrientation=true the OCR service tries to detect the image orientation and correct it before further processing (e.g. if it's upside-down). 
  ##   language: JString
  ##           : The BCP-47 language code of the text to be detected in the image. The default value is 'unk'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `detectOrientation` field"
  var valid_564147 = query.getOrDefault("detectOrientation")
  valid_564147 = validateParameter(valid_564147, JBool, required = true,
                                 default = newJBool(true))
  if valid_564147 != nil:
    section.add "detectOrientation", valid_564147
  var valid_564148 = query.getOrDefault("language")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = newJString("unk"))
  if valid_564148 != nil:
    section.add "language", valid_564148
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

proc call*(call_564150: Call_RecognizePrintedText_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_RecognizePrintedText_564144; ImageUrl: JsonNode;
          detectOrientation: bool = true; language: string = "unk"): Recallable =
  ## recognizePrintedText
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ##   detectOrientation: bool (required)
  ##                    : Whether detect the text orientation in the image. With detectOrientation=true the OCR service tries to detect the image orientation and correct it before further processing (e.g. if it's upside-down). 
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   language: string
  ##           : The BCP-47 language code of the text to be detected in the image. The default value is 'unk'
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(query_564152, "detectOrientation", newJBool(detectOrientation))
  if ImageUrl != nil:
    body_564153 = ImageUrl
  add(query_564152, "language", newJString(language))
  result = call_564151.call(nil, query_564152, nil, nil, body_564153)

var recognizePrintedText* = Call_RecognizePrintedText_564144(
    name: "recognizePrintedText", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/ocr", validator: validate_RecognizePrintedText_564145,
    base: "/vision/v1.0", url: url_RecognizePrintedText_564146,
    schemes: {Scheme.Https})
type
  Call_RecognizeText_564154 = ref object of OpenApiRestCall_563556
proc url_RecognizeText_564156(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecognizeText_564155(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   detectHandwriting: JBool
  ##                    : If 'true' is specified, handwriting recognition is performed. If this parameter is set to 'false' or is not specified, printed text recognition is performed.
  section = newJObject()
  var valid_564157 = query.getOrDefault("detectHandwriting")
  valid_564157 = validateParameter(valid_564157, JBool, required = false,
                                 default = newJBool(false))
  if valid_564157 != nil:
    section.add "detectHandwriting", valid_564157
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

proc call*(call_564159: Call_RecognizeText_564154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_RecognizeText_564154; ImageUrl: JsonNode;
          detectHandwriting: bool = false): Recallable =
  ## recognizeText
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ##   detectHandwriting: bool
  ##                    : If 'true' is specified, handwriting recognition is performed. If this parameter is set to 'false' or is not specified, printed text recognition is performed.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_564161 = newJObject()
  var body_564162 = newJObject()
  add(query_564161, "detectHandwriting", newJBool(detectHandwriting))
  if ImageUrl != nil:
    body_564162 = ImageUrl
  result = call_564160.call(nil, query_564161, nil, nil, body_564162)

var recognizeText* = Call_RecognizeText_564154(name: "recognizeText",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/recognizeText",
    validator: validate_RecognizeText_564155, base: "/vision/v1.0",
    url: url_RecognizeText_564156, schemes: {Scheme.Https})
type
  Call_TagImage_564163 = ref object of OpenApiRestCall_563556
proc url_TagImage_564165(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TagImage_564164(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_564166 = query.getOrDefault("language")
  valid_564166 = validateParameter(valid_564166, JString, required = false,
                                 default = newJString("en"))
  if valid_564166 != nil:
    section.add "language", valid_564166
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

proc call*(call_564168: Call_TagImage_564163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_TagImage_564163; ImageUrl: JsonNode;
          language: string = "en"): Recallable =
  ## tagImage
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_564170 = newJObject()
  var body_564171 = newJObject()
  add(query_564170, "language", newJString(language))
  if ImageUrl != nil:
    body_564171 = ImageUrl
  result = call_564169.call(nil, query_564170, nil, nil, body_564171)

var tagImage* = Call_TagImage_564163(name: "tagImage", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/tag",
                                  validator: validate_TagImage_564164,
                                  base: "/vision/v1.0", url: url_TagImage_564165,
                                  schemes: {Scheme.Https})
type
  Call_GetTextOperationResult_564172 = ref object of OpenApiRestCall_563556
proc url_GetTextOperationResult_564174(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/textOperations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetTextOperationResult_564173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Id of the text operation returned in the response of the 'Recognize Handwritten Text'
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564175 = path.getOrDefault("operationId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "operationId", valid_564175
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_GetTextOperationResult_564172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_GetTextOperationResult_564172; operationId: string): Recallable =
  ## getTextOperationResult
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ##   operationId: string (required)
  ##              : Id of the text operation returned in the response of the 'Recognize Handwritten Text'
  var path_564178 = newJObject()
  add(path_564178, "operationId", newJString(operationId))
  result = call_564177.call(path_564178, nil, nil, nil, nil)

var getTextOperationResult* = Call_GetTextOperationResult_564172(
    name: "getTextOperationResult", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/textOperations/{operationId}",
    validator: validate_GetTextOperationResult_564173, base: "/vision/v1.0",
    url: url_GetTextOperationResult_564174, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
