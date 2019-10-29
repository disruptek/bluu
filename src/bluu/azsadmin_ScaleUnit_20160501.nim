
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Scale unit operation endpoints and objects.
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
  macServiceName = "azsadmin-ScaleUnit"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScaleUnitsList_563778 = ref object of OpenApiRestCall_563556
proc url_ScaleUnitsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns a list of all scale units at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563943 = path.getOrDefault("subscriptionId")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "subscriptionId", valid_563943
  var valid_563944 = path.getOrDefault("location")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "location", valid_563944
  var valid_563945 = path.getOrDefault("resourceGroupName")
  valid_563945 = validateParameter(valid_563945, JString, required = true,
                                 default = nil)
  if valid_563945 != nil:
    section.add "resourceGroupName", valid_563945
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563959 = query.getOrDefault("api-version")
  valid_563959 = validateParameter(valid_563959, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_563959 != nil:
    section.add "api-version", valid_563959
  var valid_563960 = query.getOrDefault("$filter")
  valid_563960 = validateParameter(valid_563960, JString, required = false,
                                 default = nil)
  if valid_563960 != nil:
    section.add "$filter", valid_563960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563987: Call_ScaleUnitsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all scale units at a location.
  ## 
  let valid = call_563987.validator(path, query, header, formData, body)
  let scheme = call_563987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563987.url(scheme.get, call_563987.host, call_563987.base,
                         call_563987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563987, url, valid)

proc call*(call_564058: Call_ScaleUnitsList_563778; subscriptionId: string;
          location: string; resourceGroupName: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## scaleUnitsList
  ## Returns a list of all scale units at a location.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_564059 = newJObject()
  var query_564061 = newJObject()
  add(query_564061, "api-version", newJString(apiVersion))
  add(path_564059, "subscriptionId", newJString(subscriptionId))
  add(path_564059, "location", newJString(location))
  add(path_564059, "resourceGroupName", newJString(resourceGroupName))
  add(query_564061, "$filter", newJString(Filter))
  result = call_564058.call(path_564059, query_564061, nil, nil, nil)

var scaleUnitsList* = Call_ScaleUnitsList_563778(name: "scaleUnitsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits",
    validator: validate_ScaleUnitsList_563779, base: "", url: url_ScaleUnitsList_563780,
    schemes: {Scheme.Https})
type
  Call_ScaleUnitsGet_564100 = ref object of OpenApiRestCall_563556
proc url_ScaleUnitsGet_564102(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnit" in path, "`scaleUnit` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnits/"),
               (kind: VariableSegment, value: "scaleUnit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitsGet_564101(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested scale unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scaleUnit` field"
  var valid_564112 = path.getOrDefault("scaleUnit")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "scaleUnit", valid_564112
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("location")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "location", valid_564114
  var valid_564115 = path.getOrDefault("resourceGroupName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "resourceGroupName", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ScaleUnitsGet_564100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested scale unit.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ScaleUnitsGet_564100; scaleUnit: string;
          subscriptionId: string; location: string; resourceGroupName: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitsGet
  ## Returns the requested scale unit.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "scaleUnit", newJString(scaleUnit))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "location", newJString(location))
  add(path_564119, "resourceGroupName", newJString(resourceGroupName))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var scaleUnitsGet* = Call_ScaleUnitsGet_564100(name: "scaleUnitsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}",
    validator: validate_ScaleUnitsGet_564101, base: "", url: url_ScaleUnitsGet_564102,
    schemes: {Scheme.Https})
type
  Call_ScaleUnitsCreateFromJson_564121 = ref object of OpenApiRestCall_563556
proc url_ScaleUnitsCreateFromJson_564123(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnit" in path, "`scaleUnit` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnits/"),
               (kind: VariableSegment, value: "scaleUnit"),
               (kind: ConstantSegment, value: "/createFromJson")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitsCreateFromJson_564122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new scale unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scaleUnit` field"
  var valid_564124 = path.getOrDefault("scaleUnit")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "scaleUnit", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("location")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "location", valid_564126
  var valid_564127 = path.getOrDefault("resourceGroupName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "resourceGroupName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   creationData: JObject (required)
  ##               : A list of input data that allows for creating the new scale unit.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_ScaleUnitsCreateFromJson_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new scale unit.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_ScaleUnitsCreateFromJson_564121; scaleUnit: string;
          creationData: JsonNode; subscriptionId: string; location: string;
          resourceGroupName: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitsCreateFromJson
  ## Add a new scale unit.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   creationData: JObject (required)
  ##               : A list of input data that allows for creating the new scale unit.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  var body_564134 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "scaleUnit", newJString(scaleUnit))
  if creationData != nil:
    body_564134 = creationData
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "location", newJString(location))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  result = call_564131.call(path_564132, query_564133, nil, nil, body_564134)

var scaleUnitsCreateFromJson* = Call_ScaleUnitsCreateFromJson_564121(
    name: "scaleUnitsCreateFromJson", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}/createFromJson",
    validator: validate_ScaleUnitsCreateFromJson_564122, base: "",
    url: url_ScaleUnitsCreateFromJson_564123, schemes: {Scheme.Https})
type
  Call_ScaleUnitsScaleOut_564135 = ref object of OpenApiRestCall_563556
proc url_ScaleUnitsScaleOut_564137(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnit" in path, "`scaleUnit` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnits/"),
               (kind: VariableSegment, value: "scaleUnit"),
               (kind: ConstantSegment, value: "/scaleOut")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitsScaleOut_564136(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Scales out a scale unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scaleUnit` field"
  var valid_564138 = path.getOrDefault("scaleUnit")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "scaleUnit", valid_564138
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  var valid_564140 = path.getOrDefault("location")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "location", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeList: JObject (required)
  ##           : A list of input data that allows for adding a set of scale unit nodes.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_ScaleUnitsScaleOut_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scales out a scale unit.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_ScaleUnitsScaleOut_564135; scaleUnit: string;
          nodeList: JsonNode; subscriptionId: string; location: string;
          resourceGroupName: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitsScaleOut
  ## Scales out a scale unit.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   nodeList: JObject (required)
  ##           : A list of input data that allows for adding a set of scale unit nodes.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  var body_564148 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "scaleUnit", newJString(scaleUnit))
  if nodeList != nil:
    body_564148 = nodeList
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "location", newJString(location))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, body_564148)

var scaleUnitsScaleOut* = Call_ScaleUnitsScaleOut_564135(
    name: "scaleUnitsScaleOut", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}/scaleOut",
    validator: validate_ScaleUnitsScaleOut_564136, base: "",
    url: url_ScaleUnitsScaleOut_564137, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
