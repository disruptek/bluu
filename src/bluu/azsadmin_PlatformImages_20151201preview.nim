
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Compute Admin Client
## version: 2015-12-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "azsadmin-PlatformImages"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlatformImagesList_574663 = ref object of OpenApiRestCall_574441
proc url_PlatformImagesList_574665(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/artifactTypes/platformImage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlatformImagesList_574664(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a list of all platform images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574825 = path.getOrDefault("subscriptionId")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "subscriptionId", valid_574825
  var valid_574826 = path.getOrDefault("location")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "location", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574867: Call_PlatformImagesList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all platform images.
  ## 
  let valid = call_574867.validator(path, query, header, formData, body)
  let scheme = call_574867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574867.url(scheme.get, call_574867.host, call_574867.base,
                         call_574867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574867, url, valid)

proc call*(call_574938: Call_PlatformImagesList_574663; subscriptionId: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## platformImagesList
  ## Returns a list of all platform images.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_574939 = newJObject()
  var query_574941 = newJObject()
  add(query_574941, "api-version", newJString(apiVersion))
  add(path_574939, "subscriptionId", newJString(subscriptionId))
  add(path_574939, "location", newJString(location))
  result = call_574938.call(path_574939, query_574941, nil, nil, nil)

var platformImagesList* = Call_PlatformImagesList_574663(
    name: "platformImagesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/platformImage",
    validator: validate_PlatformImagesList_574664, base: "",
    url: url_PlatformImagesList_574665, schemes: {Scheme.Https})
type
  Call_PlatformImagesCreate_575003 = ref object of OpenApiRestCall_574441
proc url_PlatformImagesCreate_575005(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisher" in path, "`publisher` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/artifactTypes/platformImage/publishers/"),
               (kind: VariableSegment, value: "publisher"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "sku"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlatformImagesCreate_575004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new platform image with given publisher, offer, skus and version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisher: JString (required)
  ##            : Name of the publisher.
  ##   version: JString (required)
  ##          : The version of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: JString (required)
  ##      : Name of the SKU.
  ##   offer: JString (required)
  ##        : Name of the offer.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `publisher` field"
  var valid_575006 = path.getOrDefault("publisher")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "publisher", valid_575006
  var valid_575007 = path.getOrDefault("version")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "version", valid_575007
  var valid_575008 = path.getOrDefault("subscriptionId")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "subscriptionId", valid_575008
  var valid_575009 = path.getOrDefault("sku")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "sku", valid_575009
  var valid_575010 = path.getOrDefault("offer")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "offer", valid_575010
  var valid_575011 = path.getOrDefault("location")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "location", valid_575011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575012 = query.getOrDefault("api-version")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575012 != nil:
    section.add "api-version", valid_575012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newImage: JObject (required)
  ##           : New platform image.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575014: Call_PlatformImagesCreate_575003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new platform image with given publisher, offer, skus and version.
  ## 
  let valid = call_575014.validator(path, query, header, formData, body)
  let scheme = call_575014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575014.url(scheme.get, call_575014.host, call_575014.base,
                         call_575014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575014, url, valid)

proc call*(call_575015: Call_PlatformImagesCreate_575003; newImage: JsonNode;
          publisher: string; version: string; subscriptionId: string; sku: string;
          offer: string; location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## platformImagesCreate
  ## Creates a new platform image with given publisher, offer, skus and version.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   newImage: JObject (required)
  ##           : New platform image.
  ##   publisher: string (required)
  ##            : Name of the publisher.
  ##   version: string (required)
  ##          : The version of the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: string (required)
  ##      : Name of the SKU.
  ##   offer: string (required)
  ##        : Name of the offer.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575016 = newJObject()
  var query_575017 = newJObject()
  var body_575018 = newJObject()
  add(query_575017, "api-version", newJString(apiVersion))
  if newImage != nil:
    body_575018 = newImage
  add(path_575016, "publisher", newJString(publisher))
  add(path_575016, "version", newJString(version))
  add(path_575016, "subscriptionId", newJString(subscriptionId))
  add(path_575016, "sku", newJString(sku))
  add(path_575016, "offer", newJString(offer))
  add(path_575016, "location", newJString(location))
  result = call_575015.call(path_575016, query_575017, nil, nil, body_575018)

var platformImagesCreate* = Call_PlatformImagesCreate_575003(
    name: "platformImagesCreate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/platformImage/publishers/{publisher}/offers/{offer}/skus/{sku}/versions/{version}",
    validator: validate_PlatformImagesCreate_575004, base: "",
    url: url_PlatformImagesCreate_575005, schemes: {Scheme.Https})
type
  Call_PlatformImagesGet_574980 = ref object of OpenApiRestCall_574441
proc url_PlatformImagesGet_574982(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisher" in path, "`publisher` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/artifactTypes/platformImage/publishers/"),
               (kind: VariableSegment, value: "publisher"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "sku"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlatformImagesGet_574981(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the specific platform image matching publisher, offer, skus and version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisher: JString (required)
  ##            : Name of the publisher.
  ##   version: JString (required)
  ##          : The version of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: JString (required)
  ##      : Name of the SKU.
  ##   offer: JString (required)
  ##        : Name of the offer.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `publisher` field"
  var valid_574992 = path.getOrDefault("publisher")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "publisher", valid_574992
  var valid_574993 = path.getOrDefault("version")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "version", valid_574993
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("sku")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "sku", valid_574995
  var valid_574996 = path.getOrDefault("offer")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "offer", valid_574996
  var valid_574997 = path.getOrDefault("location")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "location", valid_574997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574998 = query.getOrDefault("api-version")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_574998 != nil:
    section.add "api-version", valid_574998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574999: Call_PlatformImagesGet_574980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specific platform image matching publisher, offer, skus and version.
  ## 
  let valid = call_574999.validator(path, query, header, formData, body)
  let scheme = call_574999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574999.url(scheme.get, call_574999.host, call_574999.base,
                         call_574999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574999, url, valid)

proc call*(call_575000: Call_PlatformImagesGet_574980; publisher: string;
          version: string; subscriptionId: string; sku: string; offer: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## platformImagesGet
  ## Returns the specific platform image matching publisher, offer, skus and version.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publisher: string (required)
  ##            : Name of the publisher.
  ##   version: string (required)
  ##          : The version of the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: string (required)
  ##      : Name of the SKU.
  ##   offer: string (required)
  ##        : Name of the offer.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575001 = newJObject()
  var query_575002 = newJObject()
  add(query_575002, "api-version", newJString(apiVersion))
  add(path_575001, "publisher", newJString(publisher))
  add(path_575001, "version", newJString(version))
  add(path_575001, "subscriptionId", newJString(subscriptionId))
  add(path_575001, "sku", newJString(sku))
  add(path_575001, "offer", newJString(offer))
  add(path_575001, "location", newJString(location))
  result = call_575000.call(path_575001, query_575002, nil, nil, nil)

var platformImagesGet* = Call_PlatformImagesGet_574980(name: "platformImagesGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/platformImage/publishers/{publisher}/offers/{offer}/skus/{sku}/versions/{version}",
    validator: validate_PlatformImagesGet_574981, base: "",
    url: url_PlatformImagesGet_574982, schemes: {Scheme.Https})
type
  Call_PlatformImagesDelete_575019 = ref object of OpenApiRestCall_574441
proc url_PlatformImagesDelete_575021(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisher" in path, "`publisher` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/artifactTypes/platformImage/publishers/"),
               (kind: VariableSegment, value: "publisher"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "sku"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlatformImagesDelete_575020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a platform image
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisher: JString (required)
  ##            : Name of the publisher.
  ##   version: JString (required)
  ##          : The version of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: JString (required)
  ##      : Name of the SKU.
  ##   offer: JString (required)
  ##        : Name of the offer.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `publisher` field"
  var valid_575022 = path.getOrDefault("publisher")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "publisher", valid_575022
  var valid_575023 = path.getOrDefault("version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "version", valid_575023
  var valid_575024 = path.getOrDefault("subscriptionId")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "subscriptionId", valid_575024
  var valid_575025 = path.getOrDefault("sku")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "sku", valid_575025
  var valid_575026 = path.getOrDefault("offer")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "offer", valid_575026
  var valid_575027 = path.getOrDefault("location")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "location", valid_575027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575028 = query.getOrDefault("api-version")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575028 != nil:
    section.add "api-version", valid_575028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575029: Call_PlatformImagesDelete_575019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a platform image
  ## 
  let valid = call_575029.validator(path, query, header, formData, body)
  let scheme = call_575029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575029.url(scheme.get, call_575029.host, call_575029.base,
                         call_575029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575029, url, valid)

proc call*(call_575030: Call_PlatformImagesDelete_575019; publisher: string;
          version: string; subscriptionId: string; sku: string; offer: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## platformImagesDelete
  ## Delete a platform image
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publisher: string (required)
  ##            : Name of the publisher.
  ##   version: string (required)
  ##          : The version of the resource.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: string (required)
  ##      : Name of the SKU.
  ##   offer: string (required)
  ##        : Name of the offer.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575031 = newJObject()
  var query_575032 = newJObject()
  add(query_575032, "api-version", newJString(apiVersion))
  add(path_575031, "publisher", newJString(publisher))
  add(path_575031, "version", newJString(version))
  add(path_575031, "subscriptionId", newJString(subscriptionId))
  add(path_575031, "sku", newJString(sku))
  add(path_575031, "offer", newJString(offer))
  add(path_575031, "location", newJString(location))
  result = call_575030.call(path_575031, query_575032, nil, nil, nil)

var platformImagesDelete* = Call_PlatformImagesDelete_575019(
    name: "platformImagesDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/artifactTypes/platformImage/publishers/{publisher}/offers/{offer}/skus/{sku}/versions/{version}",
    validator: validate_PlatformImagesDelete_575020, base: "",
    url: url_PlatformImagesDelete_575021, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
