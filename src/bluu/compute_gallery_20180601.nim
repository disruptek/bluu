
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SharedImageGalleryServiceClient
## version: 2018-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Shared Image Gallery Service Client.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "compute-gallery"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GalleriesList_563777 = ref object of OpenApiRestCall_563555
proc url_GalleriesList_563779(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleriesList_563778(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List galleries under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563954 = path.getOrDefault("subscriptionId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "subscriptionId", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_GalleriesList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List galleries under a subscription.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_GalleriesList_563777; apiVersion: string;
          subscriptionId: string): Recallable =
  ## galleriesList
  ## List galleries under a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "subscriptionId", newJString(subscriptionId))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var galleriesList* = Call_GalleriesList_563777(name: "galleriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/galleries",
    validator: validate_GalleriesList_563778, base: "", url: url_GalleriesList_563779,
    schemes: {Scheme.Https})
type
  Call_GalleriesListByResourceGroup_564091 = ref object of OpenApiRestCall_563555
proc url_GalleriesListByResourceGroup_564093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleriesListByResourceGroup_564092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List galleries under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_GalleriesListByResourceGroup_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List galleries under a resource group.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_GalleriesListByResourceGroup_564091;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## galleriesListByResourceGroup
  ## List galleries under a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "resourceGroupName", newJString(resourceGroupName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var galleriesListByResourceGroup* = Call_GalleriesListByResourceGroup_564091(
    name: "galleriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries",
    validator: validate_GalleriesListByResourceGroup_564092, base: "",
    url: url_GalleriesListByResourceGroup_564093, schemes: {Scheme.Https})
type
  Call_GalleriesCreateOrUpdate_564112 = ref object of OpenApiRestCall_563555
proc url_GalleriesCreateOrUpdate_564114(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleriesCreateOrUpdate_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Shared Image Gallery.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery. The allowed characters are alphabets and numbers with dots and periods allowed in the middle. The maximum length is 80 characters.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564132 = path.getOrDefault("galleryName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "galleryName", valid_564132
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  var valid_564134 = path.getOrDefault("resourceGroupName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "resourceGroupName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   gallery: JObject (required)
  ##          : Parameters supplied to the create or update Shared Image Gallery operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_GalleriesCreateOrUpdate_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Shared Image Gallery.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_GalleriesCreateOrUpdate_564112; apiVersion: string;
          galleryName: string; subscriptionId: string; resourceGroupName: string;
          gallery: JsonNode): Recallable =
  ## galleriesCreateOrUpdate
  ## Create or update a Shared Image Gallery.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery. The allowed characters are alphabets and numbers with dots and periods allowed in the middle. The maximum length is 80 characters.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   gallery: JObject (required)
  ##          : Parameters supplied to the create or update Shared Image Gallery operation.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "galleryName", newJString(galleryName))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  if gallery != nil:
    body_564141 = gallery
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var galleriesCreateOrUpdate* = Call_GalleriesCreateOrUpdate_564112(
    name: "galleriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}",
    validator: validate_GalleriesCreateOrUpdate_564113, base: "",
    url: url_GalleriesCreateOrUpdate_564114, schemes: {Scheme.Https})
type
  Call_GalleriesGet_564101 = ref object of OpenApiRestCall_563555
proc url_GalleriesGet_564103(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleriesGet_564102(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a Shared Image Gallery.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564104 = path.getOrDefault("galleryName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "galleryName", valid_564104
  var valid_564105 = path.getOrDefault("subscriptionId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "subscriptionId", valid_564105
  var valid_564106 = path.getOrDefault("resourceGroupName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "resourceGroupName", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_GalleriesGet_564101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a Shared Image Gallery.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_GalleriesGet_564101; apiVersion: string;
          galleryName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## galleriesGet
  ## Retrieves information about a Shared Image Gallery.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "galleryName", newJString(galleryName))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var galleriesGet* = Call_GalleriesGet_564101(name: "galleriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}",
    validator: validate_GalleriesGet_564102, base: "", url: url_GalleriesGet_564103,
    schemes: {Scheme.Https})
type
  Call_GalleriesDelete_564142 = ref object of OpenApiRestCall_563555
proc url_GalleriesDelete_564144(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleriesDelete_564143(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a Shared Image Gallery.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564145 = path.getOrDefault("galleryName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "galleryName", valid_564145
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564148 = query.getOrDefault("api-version")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "api-version", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_GalleriesDelete_564142; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Shared Image Gallery.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_GalleriesDelete_564142; apiVersion: string;
          galleryName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## galleriesDelete
  ## Delete a Shared Image Gallery.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery to be deleted.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "galleryName", newJString(galleryName))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var galleriesDelete* = Call_GalleriesDelete_564142(name: "galleriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}",
    validator: validate_GalleriesDelete_564143, base: "", url: url_GalleriesDelete_564144,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesListByGallery_564153 = ref object of OpenApiRestCall_563555
proc url_GalleryImagesListByGallery_564155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesListByGallery_564154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List gallery Image Definitions in a gallery.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery from which Image Definitions are to be listed.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564156 = path.getOrDefault("galleryName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "galleryName", valid_564156
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("resourceGroupName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceGroupName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_GalleryImagesListByGallery_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery Image Definitions in a gallery.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_GalleryImagesListByGallery_564153; apiVersion: string;
          galleryName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## galleryImagesListByGallery
  ## List gallery Image Definitions in a gallery.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery from which Image Definitions are to be listed.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "galleryName", newJString(galleryName))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var galleryImagesListByGallery* = Call_GalleryImagesListByGallery_564153(
    name: "galleryImagesListByGallery", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images",
    validator: validate_GalleryImagesListByGallery_564154, base: "",
    url: url_GalleryImagesListByGallery_564155, schemes: {Scheme.Https})
type
  Call_GalleryImagesCreateOrUpdate_564176 = ref object of OpenApiRestCall_563555
proc url_GalleryImagesCreateOrUpdate_564178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesCreateOrUpdate_564177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a gallery Image Definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition is to be created.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image Definition to be created or updated. The allowed characters are alphabets and numbers with dots, dashes, and periods allowed in the middle. The maximum length is 80 characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564179 = path.getOrDefault("galleryName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "galleryName", valid_564179
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("galleryImageName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "galleryImageName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   galleryImage: JObject (required)
  ##               : Parameters supplied to the create or update gallery image operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_GalleryImagesCreateOrUpdate_564176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a gallery Image Definition.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_GalleryImagesCreateOrUpdate_564176;
          galleryImage: JsonNode; apiVersion: string; galleryName: string;
          subscriptionId: string; resourceGroupName: string;
          galleryImageName: string): Recallable =
  ## galleryImagesCreateOrUpdate
  ## Create or update a gallery Image Definition.
  ##   galleryImage: JObject (required)
  ##               : Parameters supplied to the create or update gallery image operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition is to be created.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image Definition to be created or updated. The allowed characters are alphabets and numbers with dots, dashes, and periods allowed in the middle. The maximum length is 80 characters.
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  var body_564189 = newJObject()
  if galleryImage != nil:
    body_564189 = galleryImage
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "galleryName", newJString(galleryName))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  add(path_564187, "galleryImageName", newJString(galleryImageName))
  result = call_564186.call(path_564187, query_564188, nil, nil, body_564189)

var galleryImagesCreateOrUpdate* = Call_GalleryImagesCreateOrUpdate_564176(
    name: "galleryImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}",
    validator: validate_GalleryImagesCreateOrUpdate_564177, base: "",
    url: url_GalleryImagesCreateOrUpdate_564178, schemes: {Scheme.Https})
type
  Call_GalleryImagesGet_564164 = ref object of OpenApiRestCall_563555
proc url_GalleryImagesGet_564166(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesGet_564165(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves information about a gallery Image Definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery from which the Image Definitions are to be retrieved.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image Definition to be retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564167 = path.getOrDefault("galleryName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "galleryName", valid_564167
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("galleryImageName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "galleryImageName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_GalleryImagesGet_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a gallery Image Definition.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_GalleryImagesGet_564164; apiVersion: string;
          galleryName: string; subscriptionId: string; resourceGroupName: string;
          galleryImageName: string): Recallable =
  ## galleryImagesGet
  ## Retrieves information about a gallery Image Definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery from which the Image Definitions are to be retrieved.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image Definition to be retrieved.
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "galleryName", newJString(galleryName))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  add(path_564174, "galleryImageName", newJString(galleryImageName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var galleryImagesGet* = Call_GalleryImagesGet_564164(name: "galleryImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}",
    validator: validate_GalleryImagesGet_564165, base: "",
    url: url_GalleryImagesGet_564166, schemes: {Scheme.Https})
type
  Call_GalleryImagesDelete_564190 = ref object of OpenApiRestCall_563555
proc url_GalleryImagesDelete_564192(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesDelete_564191(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete a gallery image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition is to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image Definition to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564193 = path.getOrDefault("galleryName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "galleryName", valid_564193
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("resourceGroupName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "resourceGroupName", valid_564195
  var valid_564196 = path.getOrDefault("galleryImageName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "galleryImageName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_GalleryImagesDelete_564190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a gallery image.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_GalleryImagesDelete_564190; apiVersion: string;
          galleryName: string; subscriptionId: string; resourceGroupName: string;
          galleryImageName: string): Recallable =
  ## galleryImagesDelete
  ## Delete a gallery image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition is to be deleted.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image Definition to be deleted.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "galleryName", newJString(galleryName))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  add(path_564200, "galleryImageName", newJString(galleryImageName))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var galleryImagesDelete* = Call_GalleryImagesDelete_564190(
    name: "galleryImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}",
    validator: validate_GalleryImagesDelete_564191, base: "",
    url: url_GalleryImagesDelete_564192, schemes: {Scheme.Https})
type
  Call_GalleryImageVersionsListByGalleryImage_564202 = ref object of OpenApiRestCall_563555
proc url_GalleryImageVersionsListByGalleryImage_564204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImageVersionsListByGalleryImage_564203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List gallery Image Versions in a gallery Image Definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the Shared Image Gallery Image Definition from which the Image Versions are to be listed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryName` field"
  var valid_564205 = path.getOrDefault("galleryName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "galleryName", valid_564205
  var valid_564206 = path.getOrDefault("subscriptionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "subscriptionId", valid_564206
  var valid_564207 = path.getOrDefault("resourceGroupName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "resourceGroupName", valid_564207
  var valid_564208 = path.getOrDefault("galleryImageName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "galleryImageName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_GalleryImageVersionsListByGalleryImage_564202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List gallery Image Versions in a gallery Image Definition.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_GalleryImageVersionsListByGalleryImage_564202;
          apiVersion: string; galleryName: string; subscriptionId: string;
          resourceGroupName: string; galleryImageName: string): Recallable =
  ## galleryImageVersionsListByGalleryImage
  ## List gallery Image Versions in a gallery Image Definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the Shared Image Gallery Image Definition from which the Image Versions are to be listed.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "galleryName", newJString(galleryName))
  add(path_564212, "subscriptionId", newJString(subscriptionId))
  add(path_564212, "resourceGroupName", newJString(resourceGroupName))
  add(path_564212, "galleryImageName", newJString(galleryImageName))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var galleryImageVersionsListByGalleryImage* = Call_GalleryImageVersionsListByGalleryImage_564202(
    name: "galleryImageVersionsListByGalleryImage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}/versions",
    validator: validate_GalleryImageVersionsListByGalleryImage_564203, base: "",
    url: url_GalleryImageVersionsListByGalleryImage_564204,
    schemes: {Scheme.Https})
type
  Call_GalleryImageVersionsCreateOrUpdate_564242 = ref object of OpenApiRestCall_563555
proc url_GalleryImageVersionsCreateOrUpdate_564244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  assert "galleryImageVersionName" in path,
        "`galleryImageVersionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "galleryImageVersionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImageVersionsCreateOrUpdate_564243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a gallery Image Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryImageVersionName: JString (required)
  ##                          : The name of the gallery Image Version to be created. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image Definition in which the Image Version is to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `galleryImageVersionName` field"
  var valid_564245 = path.getOrDefault("galleryImageVersionName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "galleryImageVersionName", valid_564245
  var valid_564246 = path.getOrDefault("galleryName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "galleryName", valid_564246
  var valid_564247 = path.getOrDefault("subscriptionId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "subscriptionId", valid_564247
  var valid_564248 = path.getOrDefault("resourceGroupName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "resourceGroupName", valid_564248
  var valid_564249 = path.getOrDefault("galleryImageName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "galleryImageName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   galleryImageVersion: JObject (required)
  ##                      : Parameters supplied to the create or update gallery Image Version operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_GalleryImageVersionsCreateOrUpdate_564242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a gallery Image Version.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_GalleryImageVersionsCreateOrUpdate_564242;
          galleryImageVersionName: string; apiVersion: string; galleryName: string;
          galleryImageVersion: JsonNode; subscriptionId: string;
          resourceGroupName: string; galleryImageName: string): Recallable =
  ## galleryImageVersionsCreateOrUpdate
  ## Create or update a gallery Image Version.
  ##   galleryImageVersionName: string (required)
  ##                          : The name of the gallery Image Version to be created. Needs to follow semantic version name pattern: The allowed characters are digit and period. Digits must be within the range of a 32-bit integer. Format: <MajorVersion>.<MinorVersion>.<Patch>
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   galleryImageVersion: JObject (required)
  ##                      : Parameters supplied to the create or update gallery Image Version operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image Definition in which the Image Version is to be created.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  var body_564256 = newJObject()
  add(path_564254, "galleryImageVersionName", newJString(galleryImageVersionName))
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "galleryName", newJString(galleryName))
  if galleryImageVersion != nil:
    body_564256 = galleryImageVersion
  add(path_564254, "subscriptionId", newJString(subscriptionId))
  add(path_564254, "resourceGroupName", newJString(resourceGroupName))
  add(path_564254, "galleryImageName", newJString(galleryImageName))
  result = call_564253.call(path_564254, query_564255, nil, nil, body_564256)

var galleryImageVersionsCreateOrUpdate* = Call_GalleryImageVersionsCreateOrUpdate_564242(
    name: "galleryImageVersionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}/versions/{galleryImageVersionName}",
    validator: validate_GalleryImageVersionsCreateOrUpdate_564243, base: "",
    url: url_GalleryImageVersionsCreateOrUpdate_564244, schemes: {Scheme.Https})
type
  Call_GalleryImageVersionsGet_564214 = ref object of OpenApiRestCall_563555
proc url_GalleryImageVersionsGet_564216(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  assert "galleryImageVersionName" in path,
        "`galleryImageVersionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "galleryImageVersionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImageVersionsGet_564215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a gallery Image Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryImageVersionName: JString (required)
  ##                          : The name of the gallery Image Version to be retrieved.
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image Definition in which the Image Version resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `galleryImageVersionName` field"
  var valid_564218 = path.getOrDefault("galleryImageVersionName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "galleryImageVersionName", valid_564218
  var valid_564219 = path.getOrDefault("galleryName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "galleryName", valid_564219
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("resourceGroupName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceGroupName", valid_564221
  var valid_564222 = path.getOrDefault("galleryImageName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "galleryImageName", valid_564222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564223 = query.getOrDefault("api-version")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "api-version", valid_564223
  var valid_564237 = query.getOrDefault("$expand")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = newJString("ReplicationStatus"))
  if valid_564237 != nil:
    section.add "$expand", valid_564237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_GalleryImageVersionsGet_564214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a gallery Image Version.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_GalleryImageVersionsGet_564214;
          galleryImageVersionName: string; apiVersion: string; galleryName: string;
          subscriptionId: string; resourceGroupName: string;
          galleryImageName: string; Expand: string = "ReplicationStatus"): Recallable =
  ## galleryImageVersionsGet
  ## Retrieves information about a gallery Image Version.
  ##   galleryImageVersionName: string (required)
  ##                          : The name of the gallery Image Version to be retrieved.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image Definition in which the Image Version resides.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(path_564240, "galleryImageVersionName", newJString(galleryImageVersionName))
  add(query_564241, "api-version", newJString(apiVersion))
  add(query_564241, "$expand", newJString(Expand))
  add(path_564240, "galleryName", newJString(galleryName))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  add(path_564240, "galleryImageName", newJString(galleryImageName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var galleryImageVersionsGet* = Call_GalleryImageVersionsGet_564214(
    name: "galleryImageVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}/versions/{galleryImageVersionName}",
    validator: validate_GalleryImageVersionsGet_564215, base: "",
    url: url_GalleryImageVersionsGet_564216, schemes: {Scheme.Https})
type
  Call_GalleryImageVersionsDelete_564257 = ref object of OpenApiRestCall_563555
proc url_GalleryImageVersionsDelete_564259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "galleryName" in path, "`galleryName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  assert "galleryImageVersionName" in path,
        "`galleryImageVersionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/galleries/"),
               (kind: VariableSegment, value: "galleryName"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "galleryImageName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "galleryImageVersionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImageVersionsDelete_564258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a gallery Image Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryImageVersionName: JString (required)
  ##                          : The name of the gallery Image Version to be deleted.
  ##   galleryName: JString (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image Definition in which the Image Version resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `galleryImageVersionName` field"
  var valid_564260 = path.getOrDefault("galleryImageVersionName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "galleryImageVersionName", valid_564260
  var valid_564261 = path.getOrDefault("galleryName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "galleryName", valid_564261
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  var valid_564264 = path.getOrDefault("galleryImageName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "galleryImageName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_GalleryImageVersionsDelete_564257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a gallery Image Version.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_GalleryImageVersionsDelete_564257;
          galleryImageVersionName: string; apiVersion: string; galleryName: string;
          subscriptionId: string; resourceGroupName: string;
          galleryImageName: string): Recallable =
  ## galleryImageVersionsDelete
  ## Delete a gallery Image Version.
  ##   galleryImageVersionName: string (required)
  ##                          : The name of the gallery Image Version to be deleted.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   galleryName: string (required)
  ##              : The name of the Shared Image Gallery in which the Image Definition resides.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image Definition in which the Image Version resides.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(path_564268, "galleryImageVersionName", newJString(galleryImageVersionName))
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "galleryName", newJString(galleryName))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  add(path_564268, "galleryImageName", newJString(galleryImageName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var galleryImageVersionsDelete* = Call_GalleryImageVersionsDelete_564257(
    name: "galleryImageVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{galleryImageName}/versions/{galleryImageVersionName}",
    validator: validate_GalleryImageVersionsDelete_564258, base: "",
    url: url_GalleryImageVersionsDelete_564259, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
