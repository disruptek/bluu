
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-ScaleUnit"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScaleUnitsList_574680 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitsList_574682(protocol: Scheme; host: string; base: string;
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

proc validate_ScaleUnitsList_574681(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns a list of all scale units at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574843 = path.getOrDefault("resourceGroupName")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "resourceGroupName", valid_574843
  var valid_574844 = path.getOrDefault("subscriptionId")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "subscriptionId", valid_574844
  var valid_574845 = path.getOrDefault("location")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "location", valid_574845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574859 = query.getOrDefault("api-version")
  valid_574859 = validateParameter(valid_574859, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574859 != nil:
    section.add "api-version", valid_574859
  var valid_574860 = query.getOrDefault("$filter")
  valid_574860 = validateParameter(valid_574860, JString, required = false,
                                 default = nil)
  if valid_574860 != nil:
    section.add "$filter", valid_574860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574887: Call_ScaleUnitsList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all scale units at a location.
  ## 
  let valid = call_574887.validator(path, query, header, formData, body)
  let scheme = call_574887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574887.url(scheme.get, call_574887.host, call_574887.base,
                         call_574887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574887, url, valid)

proc call*(call_574958: Call_ScaleUnitsList_574680; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## scaleUnitsList
  ## Returns a list of all scale units at a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574959 = newJObject()
  var query_574961 = newJObject()
  add(path_574959, "resourceGroupName", newJString(resourceGroupName))
  add(query_574961, "api-version", newJString(apiVersion))
  add(path_574959, "subscriptionId", newJString(subscriptionId))
  add(path_574959, "location", newJString(location))
  add(query_574961, "$filter", newJString(Filter))
  result = call_574958.call(path_574959, query_574961, nil, nil, nil)

var scaleUnitsList* = Call_ScaleUnitsList_574680(name: "scaleUnitsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits",
    validator: validate_ScaleUnitsList_574681, base: "", url: url_ScaleUnitsList_574682,
    schemes: {Scheme.Https})
type
  Call_ScaleUnitsGet_575000 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitsGet_575002(protocol: Scheme; host: string; base: string;
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

proc validate_ScaleUnitsGet_575001(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested scale unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575012 = path.getOrDefault("resourceGroupName")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "resourceGroupName", valid_575012
  var valid_575013 = path.getOrDefault("scaleUnit")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "scaleUnit", valid_575013
  var valid_575014 = path.getOrDefault("subscriptionId")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "subscriptionId", valid_575014
  var valid_575015 = path.getOrDefault("location")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "location", valid_575015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575016 = query.getOrDefault("api-version")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575016 != nil:
    section.add "api-version", valid_575016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575017: Call_ScaleUnitsGet_575000; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested scale unit.
  ## 
  let valid = call_575017.validator(path, query, header, formData, body)
  let scheme = call_575017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575017.url(scheme.get, call_575017.host, call_575017.base,
                         call_575017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575017, url, valid)

proc call*(call_575018: Call_ScaleUnitsGet_575000; resourceGroupName: string;
          scaleUnit: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitsGet
  ## Returns the requested scale unit.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575019 = newJObject()
  var query_575020 = newJObject()
  add(path_575019, "resourceGroupName", newJString(resourceGroupName))
  add(path_575019, "scaleUnit", newJString(scaleUnit))
  add(query_575020, "api-version", newJString(apiVersion))
  add(path_575019, "subscriptionId", newJString(subscriptionId))
  add(path_575019, "location", newJString(location))
  result = call_575018.call(path_575019, query_575020, nil, nil, nil)

var scaleUnitsGet* = Call_ScaleUnitsGet_575000(name: "scaleUnitsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}",
    validator: validate_ScaleUnitsGet_575001, base: "", url: url_ScaleUnitsGet_575002,
    schemes: {Scheme.Https})
type
  Call_ScaleUnitsCreateFromJson_575021 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitsCreateFromJson_575023(protocol: Scheme; host: string;
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

proc validate_ScaleUnitsCreateFromJson_575022(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new scale unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575024 = path.getOrDefault("resourceGroupName")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "resourceGroupName", valid_575024
  var valid_575025 = path.getOrDefault("scaleUnit")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "scaleUnit", valid_575025
  var valid_575026 = path.getOrDefault("subscriptionId")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "subscriptionId", valid_575026
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
                                 default = newJString("2016-05-01"))
  if valid_575028 != nil:
    section.add "api-version", valid_575028
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

proc call*(call_575030: Call_ScaleUnitsCreateFromJson_575021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new scale unit.
  ## 
  let valid = call_575030.validator(path, query, header, formData, body)
  let scheme = call_575030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575030.url(scheme.get, call_575030.host, call_575030.base,
                         call_575030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575030, url, valid)

proc call*(call_575031: Call_ScaleUnitsCreateFromJson_575021;
          resourceGroupName: string; scaleUnit: string; creationData: JsonNode;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitsCreateFromJson
  ## Add a new scale unit.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   creationData: JObject (required)
  ##               : A list of input data that allows for creating the new scale unit.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575032 = newJObject()
  var query_575033 = newJObject()
  var body_575034 = newJObject()
  add(path_575032, "resourceGroupName", newJString(resourceGroupName))
  add(path_575032, "scaleUnit", newJString(scaleUnit))
  add(query_575033, "api-version", newJString(apiVersion))
  if creationData != nil:
    body_575034 = creationData
  add(path_575032, "subscriptionId", newJString(subscriptionId))
  add(path_575032, "location", newJString(location))
  result = call_575031.call(path_575032, query_575033, nil, nil, body_575034)

var scaleUnitsCreateFromJson* = Call_ScaleUnitsCreateFromJson_575021(
    name: "scaleUnitsCreateFromJson", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}/createFromJson",
    validator: validate_ScaleUnitsCreateFromJson_575022, base: "",
    url: url_ScaleUnitsCreateFromJson_575023, schemes: {Scheme.Https})
type
  Call_ScaleUnitsScaleOut_575035 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitsScaleOut_575037(protocol: Scheme; host: string; base: string;
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

proc validate_ScaleUnitsScaleOut_575036(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Scales out a scale unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575038 = path.getOrDefault("resourceGroupName")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "resourceGroupName", valid_575038
  var valid_575039 = path.getOrDefault("scaleUnit")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "scaleUnit", valid_575039
  var valid_575040 = path.getOrDefault("subscriptionId")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "subscriptionId", valid_575040
  var valid_575041 = path.getOrDefault("location")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "location", valid_575041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575042 = query.getOrDefault("api-version")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575042 != nil:
    section.add "api-version", valid_575042
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

proc call*(call_575044: Call_ScaleUnitsScaleOut_575035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scales out a scale unit.
  ## 
  let valid = call_575044.validator(path, query, header, formData, body)
  let scheme = call_575044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575044.url(scheme.get, call_575044.host, call_575044.base,
                         call_575044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575044, url, valid)

proc call*(call_575045: Call_ScaleUnitsScaleOut_575035; resourceGroupName: string;
          scaleUnit: string; subscriptionId: string; nodeList: JsonNode;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitsScaleOut
  ## Scales out a scale unit.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   nodeList: JObject (required)
  ##           : A list of input data that allows for adding a set of scale unit nodes.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575046 = newJObject()
  var query_575047 = newJObject()
  var body_575048 = newJObject()
  add(path_575046, "resourceGroupName", newJString(resourceGroupName))
  add(path_575046, "scaleUnit", newJString(scaleUnit))
  add(query_575047, "api-version", newJString(apiVersion))
  add(path_575046, "subscriptionId", newJString(subscriptionId))
  if nodeList != nil:
    body_575048 = nodeList
  add(path_575046, "location", newJString(location))
  result = call_575045.call(path_575046, query_575047, nil, nil, body_575048)

var scaleUnitsScaleOut* = Call_ScaleUnitsScaleOut_575035(
    name: "scaleUnitsScaleOut", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}/scaleOut",
    validator: validate_ScaleUnitsScaleOut_575036, base: "",
    url: url_ScaleUnitsScaleOut_575037, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
