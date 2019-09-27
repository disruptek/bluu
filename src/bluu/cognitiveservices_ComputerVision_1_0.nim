
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices-ComputerVision"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyzeImage_593647 = ref object of OpenApiRestCall_593425
proc url_AnalyzeImage_593649(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyzeImage_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   visualFeatures: JArray
  ##                 : A string indicating what visual feature types to return. Multiple values should be comma-separated. Valid visual feature types include:Categories - categorizes image content according to a taxonomy defined in documentation. Tags - tags the image with a detailed list of words related to the image content. Description - describes the image content with a complete English sentence. Faces - detects if faces are present. If present, generate coordinates, gender and age. ImageType - detects if image is clipart or a line drawing. Color - determines the accent color, dominant color, and whether an image is black&white.Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   details: JArray
  ##          : A string indicating which domain-specific details to return. Multiple values should be comma-separated. Valid visual feature types include:Celebrities - identifies celebrities if detected in the image.
  section = newJObject()
  var valid_593808 = query.getOrDefault("visualFeatures")
  valid_593808 = validateParameter(valid_593808, JArray, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "visualFeatures", valid_593808
  var valid_593822 = query.getOrDefault("language")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("en"))
  if valid_593822 != nil:
    section.add "language", valid_593822
  var valid_593823 = query.getOrDefault("details")
  valid_593823 = validateParameter(valid_593823, JArray, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "details", valid_593823
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

proc call*(call_593847: Call_AnalyzeImage_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_AnalyzeImage_593647; ImageUrl: JsonNode;
          visualFeatures: JsonNode = nil; language: string = "en";
          details: JsonNode = nil): Recallable =
  ## analyzeImage
  ## This operation extracts a rich set of visual features based on the image content. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.  Within your request, there is an optional parameter to allow you to choose which features to return.  By default, image categories are returned in the response.
  ##   visualFeatures: JArray
  ##                 : A string indicating what visual feature types to return. Multiple values should be comma-separated. Valid visual feature types include:Categories - categorizes image content according to a taxonomy defined in documentation. Tags - tags the image with a detailed list of words related to the image content. Description - describes the image content with a complete English sentence. Faces - detects if faces are present. If present, generate coordinates, gender and age. ImageType - detects if image is clipart or a line drawing. Color - determines the accent color, dominant color, and whether an image is black&white.Adult - detects if the image is pornographic in nature (depicts nudity or a sex act).  Sexually suggestive content is also detected.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   details: JArray
  ##          : A string indicating which domain-specific details to return. Multiple values should be comma-separated. Valid visual feature types include:Celebrities - identifies celebrities if detected in the image.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_593919 = newJObject()
  var body_593921 = newJObject()
  if visualFeatures != nil:
    query_593919.add "visualFeatures", visualFeatures
  add(query_593919, "language", newJString(language))
  if details != nil:
    query_593919.add "details", details
  if ImageUrl != nil:
    body_593921 = ImageUrl
  result = call_593918.call(nil, query_593919, nil, nil, body_593921)

var analyzeImage* = Call_AnalyzeImage_593647(name: "analyzeImage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/analyze",
    validator: validate_AnalyzeImage_593648, base: "/vision/v1.0",
    url: url_AnalyzeImage_593649, schemes: {Scheme.Https})
type
  Call_DescribeImage_593960 = ref object of OpenApiRestCall_593425
proc url_DescribeImage_593962(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DescribeImage_593961(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   maxCandidates: JString
  ##                : Maximum number of candidate descriptions to be returned.  The default is 1.
  section = newJObject()
  var valid_593963 = query.getOrDefault("language")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = newJString("en"))
  if valid_593963 != nil:
    section.add "language", valid_593963
  var valid_593964 = query.getOrDefault("maxCandidates")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("1"))
  if valid_593964 != nil:
    section.add "maxCandidates", valid_593964
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

proc call*(call_593966: Call_DescribeImage_593960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_DescribeImage_593960; ImageUrl: JsonNode;
          language: string = "en"; maxCandidates: string = "1"): Recallable =
  ## describeImage
  ## This operation generates a description of an image in human readable language with complete sentences.  The description is based on a collection of content tags, which are also returned by the operation. More than one description can be generated for each image.  Descriptions are ordered by their confidence score. All descriptions are in English. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL.A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   maxCandidates: string
  ##                : Maximum number of candidate descriptions to be returned.  The default is 1.
  var query_593968 = newJObject()
  var body_593969 = newJObject()
  add(query_593968, "language", newJString(language))
  if ImageUrl != nil:
    body_593969 = ImageUrl
  add(query_593968, "maxCandidates", newJString(maxCandidates))
  result = call_593967.call(nil, query_593968, nil, nil, body_593969)

var describeImage* = Call_DescribeImage_593960(name: "describeImage",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/describe",
    validator: validate_DescribeImage_593961, base: "/vision/v1.0",
    url: url_DescribeImage_593962, schemes: {Scheme.Https})
type
  Call_GenerateThumbnail_593970 = ref object of OpenApiRestCall_593425
proc url_GenerateThumbnail_593972(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenerateThumbnail_593971(path: JsonNode; query: JsonNode;
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
  var valid_593973 = query.getOrDefault("height")
  valid_593973 = validateParameter(valid_593973, JInt, required = true, default = nil)
  if valid_593973 != nil:
    section.add "height", valid_593973
  var valid_593974 = query.getOrDefault("width")
  valid_593974 = validateParameter(valid_593974, JInt, required = true, default = nil)
  if valid_593974 != nil:
    section.add "width", valid_593974
  var valid_593975 = query.getOrDefault("smartCropping")
  valid_593975 = validateParameter(valid_593975, JBool, required = false,
                                 default = newJBool(false))
  if valid_593975 != nil:
    section.add "smartCropping", valid_593975
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

proc call*(call_593977: Call_GenerateThumbnail_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_GenerateThumbnail_593970; height: int;
          ImageUrl: JsonNode; width: int; smartCropping: bool = false): Recallable =
  ## generateThumbnail
  ## This operation generates a thumbnail image with the user-specified width and height. By default, the service analyzes the image, identifies the region of interest (ROI), and generates smart cropping coordinates based on the ROI. Smart cropping helps when you specify an aspect ratio that differs from that of the input image. A successful response contains the thumbnail image binary. If the request failed, the response contains an error code and a message to help determine what went wrong.
  ##   height: int (required)
  ##         : Height of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   width: int (required)
  ##        : Width of the thumbnail. It must be between 1 and 1024. Recommended minimum of 50.
  ##   smartCropping: bool
  ##                : Boolean flag for enabling smart cropping.
  var query_593979 = newJObject()
  var body_593980 = newJObject()
  add(query_593979, "height", newJInt(height))
  if ImageUrl != nil:
    body_593980 = ImageUrl
  add(query_593979, "width", newJInt(width))
  add(query_593979, "smartCropping", newJBool(smartCropping))
  result = call_593978.call(nil, query_593979, nil, nil, body_593980)

var generateThumbnail* = Call_GenerateThumbnail_593970(name: "generateThumbnail",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/generateThumbnail",
    validator: validate_GenerateThumbnail_593971, base: "/vision/v1.0",
    url: url_GenerateThumbnail_593972, schemes: {Scheme.Https})
type
  Call_ListModels_593981 = ref object of OpenApiRestCall_593425
proc url_ListModels_593983(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListModels_593982(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_593984: Call_ListModels_593981; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ListModels_593981): Recallable =
  ## listModels
  ## This operation returns the list of domain-specific models that are supported by the Computer Vision API.  Currently, the API only supports one domain-specific model: a celebrity recognizer. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  result = call_593985.call(nil, nil, nil, nil, nil)

var listModels* = Call_ListModels_593981(name: "listModels",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/models",
                                      validator: validate_ListModels_593982,
                                      base: "/vision/v1.0", url: url_ListModels_593983,
                                      schemes: {Scheme.Https})
type
  Call_AnalyzeImageByDomain_593986 = ref object of OpenApiRestCall_593425
proc url_AnalyzeImageByDomain_593988(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyzeImageByDomain_593987(path: JsonNode; query: JsonNode;
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
  var valid_594003 = path.getOrDefault("model")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "model", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  section = newJObject()
  var valid_594004 = query.getOrDefault("language")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("en"))
  if valid_594004 != nil:
    section.add "language", valid_594004
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

proc call*(call_594006: Call_AnalyzeImageByDomain_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_AnalyzeImageByDomain_593986; ImageUrl: JsonNode;
          model: string; language: string = "en"): Recallable =
  ## analyzeImageByDomain
  ## This operation recognizes content within an image by applying a domain-specific model.  The list of domain-specific models that are supported by the Computer Vision API can be retrieved using the /models GET request.  Currently, the API only provides a single domain-specific model: celebrities. Two input methods are supported -- (1) Uploading an image or (2) specifying an image URL. A successful response will be returned in JSON.  If the request failed, the response will contain an error code and a message to help understand what went wrong.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  ##   model: string (required)
  ##        : The domain-specific content to recognize.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  var body_594010 = newJObject()
  add(query_594009, "language", newJString(language))
  if ImageUrl != nil:
    body_594010 = ImageUrl
  add(path_594008, "model", newJString(model))
  result = call_594007.call(path_594008, query_594009, nil, nil, body_594010)

var analyzeImageByDomain* = Call_AnalyzeImageByDomain_593986(
    name: "analyzeImageByDomain", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/models/{model}/analyze", validator: validate_AnalyzeImageByDomain_593987,
    base: "/vision/v1.0", url: url_AnalyzeImageByDomain_593988,
    schemes: {Scheme.Https})
type
  Call_RecognizePrintedText_594011 = ref object of OpenApiRestCall_593425
proc url_RecognizePrintedText_594013(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecognizePrintedText_594012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : The BCP-47 language code of the text to be detected in the image. The default value is 'unk'
  ##   detectOrientation: JBool (required)
  ##                    : Whether detect the text orientation in the image. With detectOrientation=true the OCR service tries to detect the image orientation and correct it before further processing (e.g. if it's upside-down). 
  section = newJObject()
  var valid_594014 = query.getOrDefault("language")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("unk"))
  if valid_594014 != nil:
    section.add "language", valid_594014
  assert query != nil,
        "query argument is necessary due to required `detectOrientation` field"
  var valid_594015 = query.getOrDefault("detectOrientation")
  valid_594015 = validateParameter(valid_594015, JBool, required = true,
                                 default = newJBool(true))
  if valid_594015 != nil:
    section.add "detectOrientation", valid_594015
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

proc call*(call_594017: Call_RecognizePrintedText_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_RecognizePrintedText_594011; ImageUrl: JsonNode;
          language: string = "unk"; detectOrientation: bool = true): Recallable =
  ## recognizePrintedText
  ## Optical Character Recognition (OCR) detects printed text in an image and extracts the recognized characters into a machine-usable character stream.   Upon success, the OCR results will be returned. Upon failure, the error code together with an error message will be returned. The error code can be one of InvalidImageUrl, InvalidImageFormat, InvalidImageSize, NotSupportedImage,  NotSupportedLanguage, or InternalServerError.
  ##   language: string
  ##           : The BCP-47 language code of the text to be detected in the image. The default value is 'unk'
  ##   detectOrientation: bool (required)
  ##                    : Whether detect the text orientation in the image. With detectOrientation=true the OCR service tries to detect the image orientation and correct it before further processing (e.g. if it's upside-down). 
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(query_594019, "language", newJString(language))
  add(query_594019, "detectOrientation", newJBool(detectOrientation))
  if ImageUrl != nil:
    body_594020 = ImageUrl
  result = call_594018.call(nil, query_594019, nil, nil, body_594020)

var recognizePrintedText* = Call_RecognizePrintedText_594011(
    name: "recognizePrintedText", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/ocr", validator: validate_RecognizePrintedText_594012,
    base: "/vision/v1.0", url: url_RecognizePrintedText_594013,
    schemes: {Scheme.Https})
type
  Call_RecognizeText_594021 = ref object of OpenApiRestCall_593425
proc url_RecognizeText_594023(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecognizeText_594022(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594024 = query.getOrDefault("detectHandwriting")
  valid_594024 = validateParameter(valid_594024, JBool, required = false,
                                 default = newJBool(false))
  if valid_594024 != nil:
    section.add "detectHandwriting", valid_594024
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

proc call*(call_594026: Call_RecognizeText_594021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_RecognizeText_594021; ImageUrl: JsonNode;
          detectHandwriting: bool = false): Recallable =
  ## recognizeText
  ## Recognize Text operation. When you use the Recognize Text interface, the response contains a field called 'Operation-Location'. The 'Operation-Location' field contains the URL that you must use for your Get Handwritten Text Operation Result operation.
  ##   detectHandwriting: bool
  ##                    : If 'true' is specified, handwriting recognition is performed. If this parameter is set to 'false' or is not specified, printed text recognition is performed.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(query_594028, "detectHandwriting", newJBool(detectHandwriting))
  if ImageUrl != nil:
    body_594029 = ImageUrl
  result = call_594027.call(nil, query_594028, nil, nil, body_594029)

var recognizeText* = Call_RecognizeText_594021(name: "recognizeText",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/recognizeText",
    validator: validate_RecognizeText_594022, base: "/vision/v1.0",
    url: url_RecognizeText_594023, schemes: {Scheme.Https})
type
  Call_TagImage_594030 = ref object of OpenApiRestCall_593425
proc url_TagImage_594032(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TagImage_594031(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594033 = query.getOrDefault("language")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("en"))
  if valid_594033 != nil:
    section.add "language", valid_594033
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

proc call*(call_594035: Call_TagImage_594030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_TagImage_594030; ImageUrl: JsonNode;
          language: string = "en"): Recallable =
  ## tagImage
  ## This operation generates a list of words, or tags, that are relevant to the content of the supplied image. The Computer Vision API can return tags based on objects, living beings, scenery or actions found in images. Unlike categories, tags are not organized according to a hierarchical classification system, but correspond to image content. Tags may contain hints to avoid ambiguity or provide context, for example the tag 'cello' may be accompanied by the hint 'musical instrument'. All tags are in English.
  ##   language: string
  ##           : The desired language for output generation. If this parameter is not specified, the default value is &quot;en&quot;.Supported languages:en - English, Default. es - Spanish, ja - Japanese, pt - Portuguese, zh - Simplified Chinese.
  ##   ImageUrl: JObject (required)
  ##           : A JSON document with a URL pointing to the image that is to be analyzed.
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(query_594037, "language", newJString(language))
  if ImageUrl != nil:
    body_594038 = ImageUrl
  result = call_594036.call(nil, query_594037, nil, nil, body_594038)

var tagImage* = Call_TagImage_594030(name: "tagImage", meth: HttpMethod.HttpPost,
                                  host: "azure.local", route: "/tag",
                                  validator: validate_TagImage_594031,
                                  base: "/vision/v1.0", url: url_TagImage_594032,
                                  schemes: {Scheme.Https})
type
  Call_GetTextOperationResult_594039 = ref object of OpenApiRestCall_593425
proc url_GetTextOperationResult_594041(protocol: Scheme; host: string; base: string;
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

proc validate_GetTextOperationResult_594040(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("operationId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "operationId", valid_594042
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_GetTextOperationResult_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_GetTextOperationResult_594039; operationId: string): Recallable =
  ## getTextOperationResult
  ## This interface is used for getting text operation result. The URL to this interface should be retrieved from 'Operation-Location' field returned from Recognize Text interface.
  ##   operationId: string (required)
  ##              : Id of the text operation returned in the response of the 'Recognize Handwritten Text'
  var path_594045 = newJObject()
  add(path_594045, "operationId", newJString(operationId))
  result = call_594044.call(path_594045, nil, nil, nil, nil)

var getTextOperationResult* = Call_GetTextOperationResult_594039(
    name: "getTextOperationResult", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/textOperations/{operationId}",
    validator: validate_GetTextOperationResult_594040, base: "/vision/v1.0",
    url: url_GetTextOperationResult_594041, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
