
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Scale unit node operation endpoints and objects.
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
  macServiceName = "azsadmin-ScaleUnitNode"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScaleUnitNodesList_574680 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesList_574682(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/scaleUnitNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesList_574681(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a list of all scale unit nodes in a location.
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

proc call*(call_574887: Call_ScaleUnitNodesList_574680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all scale unit nodes in a location.
  ## 
  let valid = call_574887.validator(path, query, header, formData, body)
  let scheme = call_574887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574887.url(scheme.get, call_574887.host, call_574887.base,
                         call_574887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574887, url, valid)

proc call*(call_574958: Call_ScaleUnitNodesList_574680; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## scaleUnitNodesList
  ## Returns a list of all scale unit nodes in a location.
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

var scaleUnitNodesList* = Call_ScaleUnitNodesList_574680(
    name: "scaleUnitNodesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes",
    validator: validate_ScaleUnitNodesList_574681, base: "",
    url: url_ScaleUnitNodesList_574682, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesGet_575000 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesGet_575002(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesGet_575001(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Return the requested scale unit node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
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
  var valid_575013 = path.getOrDefault("scaleUnitNode")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "scaleUnitNode", valid_575013
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

proc call*(call_575017: Call_ScaleUnitNodesGet_575000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested scale unit node.
  ## 
  let valid = call_575017.validator(path, query, header, formData, body)
  let scheme = call_575017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575017.url(scheme.get, call_575017.host, call_575017.base,
                         call_575017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575017, url, valid)

proc call*(call_575018: Call_ScaleUnitNodesGet_575000; resourceGroupName: string;
          scaleUnitNode: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesGet
  ## Return the requested scale unit node.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575019 = newJObject()
  var query_575020 = newJObject()
  add(path_575019, "resourceGroupName", newJString(resourceGroupName))
  add(query_575020, "api-version", newJString(apiVersion))
  add(path_575019, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575019, "subscriptionId", newJString(subscriptionId))
  add(path_575019, "location", newJString(location))
  result = call_575018.call(path_575019, query_575020, nil, nil, nil)

var scaleUnitNodesGet* = Call_ScaleUnitNodesGet_575000(name: "scaleUnitNodesGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}",
    validator: validate_ScaleUnitNodesGet_575001, base: "",
    url: url_ScaleUnitNodesGet_575002, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesPowerOff_575021 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesPowerOff_575023(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode"),
               (kind: ConstantSegment, value: "/PowerOff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesPowerOff_575022(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off a scale unit node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
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
  var valid_575025 = path.getOrDefault("scaleUnitNode")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "scaleUnitNode", valid_575025
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
  if body != nil:
    result.add "body", body

proc call*(call_575029: Call_ScaleUnitNodesPowerOff_575021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power off a scale unit node.
  ## 
  let valid = call_575029.validator(path, query, header, formData, body)
  let scheme = call_575029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575029.url(scheme.get, call_575029.host, call_575029.base,
                         call_575029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575029, url, valid)

proc call*(call_575030: Call_ScaleUnitNodesPowerOff_575021;
          resourceGroupName: string; scaleUnitNode: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesPowerOff
  ## Power off a scale unit node.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575031 = newJObject()
  var query_575032 = newJObject()
  add(path_575031, "resourceGroupName", newJString(resourceGroupName))
  add(query_575032, "api-version", newJString(apiVersion))
  add(path_575031, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575031, "subscriptionId", newJString(subscriptionId))
  add(path_575031, "location", newJString(location))
  result = call_575030.call(path_575031, query_575032, nil, nil, nil)

var scaleUnitNodesPowerOff* = Call_ScaleUnitNodesPowerOff_575021(
    name: "scaleUnitNodesPowerOff", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}/PowerOff",
    validator: validate_ScaleUnitNodesPowerOff_575022, base: "",
    url: url_ScaleUnitNodesPowerOff_575023, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesPowerOn_575033 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesPowerOn_575035(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode"),
               (kind: ConstantSegment, value: "/PowerOn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesPowerOn_575034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power on a scale unit node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575036 = path.getOrDefault("resourceGroupName")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "resourceGroupName", valid_575036
  var valid_575037 = path.getOrDefault("scaleUnitNode")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "scaleUnitNode", valid_575037
  var valid_575038 = path.getOrDefault("subscriptionId")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "subscriptionId", valid_575038
  var valid_575039 = path.getOrDefault("location")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "location", valid_575039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575040 = query.getOrDefault("api-version")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575040 != nil:
    section.add "api-version", valid_575040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575041: Call_ScaleUnitNodesPowerOn_575033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power on a scale unit node.
  ## 
  let valid = call_575041.validator(path, query, header, formData, body)
  let scheme = call_575041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575041.url(scheme.get, call_575041.host, call_575041.base,
                         call_575041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575041, url, valid)

proc call*(call_575042: Call_ScaleUnitNodesPowerOn_575033;
          resourceGroupName: string; scaleUnitNode: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesPowerOn
  ## Power on a scale unit node.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575043 = newJObject()
  var query_575044 = newJObject()
  add(path_575043, "resourceGroupName", newJString(resourceGroupName))
  add(query_575044, "api-version", newJString(apiVersion))
  add(path_575043, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575043, "subscriptionId", newJString(subscriptionId))
  add(path_575043, "location", newJString(location))
  result = call_575042.call(path_575043, query_575044, nil, nil, nil)

var scaleUnitNodesPowerOn* = Call_ScaleUnitNodesPowerOn_575033(
    name: "scaleUnitNodesPowerOn", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}/PowerOn",
    validator: validate_ScaleUnitNodesPowerOn_575034, base: "",
    url: url_ScaleUnitNodesPowerOn_575035, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesRepair_575045 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesRepair_575047(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode"),
               (kind: ConstantSegment, value: "/Repair")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesRepair_575046(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Repairs a node of the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575048 = path.getOrDefault("resourceGroupName")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "resourceGroupName", valid_575048
  var valid_575049 = path.getOrDefault("scaleUnitNode")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "scaleUnitNode", valid_575049
  var valid_575050 = path.getOrDefault("subscriptionId")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "subscriptionId", valid_575050
  var valid_575051 = path.getOrDefault("location")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "location", valid_575051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575052 = query.getOrDefault("api-version")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575052 != nil:
    section.add "api-version", valid_575052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   bareMetalNode: JObject (required)
  ##                : Description of a node.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575054: Call_ScaleUnitNodesRepair_575045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repairs a node of the cluster.
  ## 
  let valid = call_575054.validator(path, query, header, formData, body)
  let scheme = call_575054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575054.url(scheme.get, call_575054.host, call_575054.base,
                         call_575054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575054, url, valid)

proc call*(call_575055: Call_ScaleUnitNodesRepair_575045;
          resourceGroupName: string; scaleUnitNode: string; subscriptionId: string;
          bareMetalNode: JsonNode; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesRepair
  ## Repairs a node of the cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   bareMetalNode: JObject (required)
  ##                : Description of a node.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575056 = newJObject()
  var query_575057 = newJObject()
  var body_575058 = newJObject()
  add(path_575056, "resourceGroupName", newJString(resourceGroupName))
  add(query_575057, "api-version", newJString(apiVersion))
  add(path_575056, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575056, "subscriptionId", newJString(subscriptionId))
  if bareMetalNode != nil:
    body_575058 = bareMetalNode
  add(path_575056, "location", newJString(location))
  result = call_575055.call(path_575056, query_575057, nil, nil, body_575058)

var scaleUnitNodesRepair* = Call_ScaleUnitNodesRepair_575045(
    name: "scaleUnitNodesRepair", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}/Repair",
    validator: validate_ScaleUnitNodesRepair_575046, base: "",
    url: url_ScaleUnitNodesRepair_575047, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesShutdown_575059 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesShutdown_575061(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode"),
               (kind: ConstantSegment, value: "/Shutdown")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesShutdown_575060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shutdown a scale unit node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575062 = path.getOrDefault("resourceGroupName")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "resourceGroupName", valid_575062
  var valid_575063 = path.getOrDefault("scaleUnitNode")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "scaleUnitNode", valid_575063
  var valid_575064 = path.getOrDefault("subscriptionId")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "subscriptionId", valid_575064
  var valid_575065 = path.getOrDefault("location")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "location", valid_575065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575066 = query.getOrDefault("api-version")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575066 != nil:
    section.add "api-version", valid_575066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575067: Call_ScaleUnitNodesShutdown_575059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shutdown a scale unit node.
  ## 
  let valid = call_575067.validator(path, query, header, formData, body)
  let scheme = call_575067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575067.url(scheme.get, call_575067.host, call_575067.base,
                         call_575067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575067, url, valid)

proc call*(call_575068: Call_ScaleUnitNodesShutdown_575059;
          resourceGroupName: string; scaleUnitNode: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesShutdown
  ## Shutdown a scale unit node.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575069 = newJObject()
  var query_575070 = newJObject()
  add(path_575069, "resourceGroupName", newJString(resourceGroupName))
  add(query_575070, "api-version", newJString(apiVersion))
  add(path_575069, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575069, "subscriptionId", newJString(subscriptionId))
  add(path_575069, "location", newJString(location))
  result = call_575068.call(path_575069, query_575070, nil, nil, nil)

var scaleUnitNodesShutdown* = Call_ScaleUnitNodesShutdown_575059(
    name: "scaleUnitNodesShutdown", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}/Shutdown",
    validator: validate_ScaleUnitNodesShutdown_575060, base: "",
    url: url_ScaleUnitNodesShutdown_575061, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesStartMaintenanceMode_575071 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesStartMaintenanceMode_575073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode"),
               (kind: ConstantSegment, value: "/StartMaintenanceMode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesStartMaintenanceMode_575072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start maintenance mode for a scale unit node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575074 = path.getOrDefault("resourceGroupName")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "resourceGroupName", valid_575074
  var valid_575075 = path.getOrDefault("scaleUnitNode")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "scaleUnitNode", valid_575075
  var valid_575076 = path.getOrDefault("subscriptionId")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "subscriptionId", valid_575076
  var valid_575077 = path.getOrDefault("location")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "location", valid_575077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575078 = query.getOrDefault("api-version")
  valid_575078 = validateParameter(valid_575078, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575078 != nil:
    section.add "api-version", valid_575078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575079: Call_ScaleUnitNodesStartMaintenanceMode_575071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start maintenance mode for a scale unit node.
  ## 
  let valid = call_575079.validator(path, query, header, formData, body)
  let scheme = call_575079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575079.url(scheme.get, call_575079.host, call_575079.base,
                         call_575079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575079, url, valid)

proc call*(call_575080: Call_ScaleUnitNodesStartMaintenanceMode_575071;
          resourceGroupName: string; scaleUnitNode: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesStartMaintenanceMode
  ## Start maintenance mode for a scale unit node.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575081 = newJObject()
  var query_575082 = newJObject()
  add(path_575081, "resourceGroupName", newJString(resourceGroupName))
  add(query_575082, "api-version", newJString(apiVersion))
  add(path_575081, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575081, "subscriptionId", newJString(subscriptionId))
  add(path_575081, "location", newJString(location))
  result = call_575080.call(path_575081, query_575082, nil, nil, nil)

var scaleUnitNodesStartMaintenanceMode* = Call_ScaleUnitNodesStartMaintenanceMode_575071(
    name: "scaleUnitNodesStartMaintenanceMode", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}/StartMaintenanceMode",
    validator: validate_ScaleUnitNodesStartMaintenanceMode_575072, base: "",
    url: url_ScaleUnitNodesStartMaintenanceMode_575073, schemes: {Scheme.Https})
type
  Call_ScaleUnitNodesStopMaintenanceMode_575083 = ref object of OpenApiRestCall_574458
proc url_ScaleUnitNodesStopMaintenanceMode_575085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnitNode" in path, "`scaleUnitNode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnitNodes/"),
               (kind: VariableSegment, value: "scaleUnitNode"),
               (kind: ConstantSegment, value: "/StopMaintenanceMode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScaleUnitNodesStopMaintenanceMode_575084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stop maintenance mode for a scale unit node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnitNode: JString (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575086 = path.getOrDefault("resourceGroupName")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "resourceGroupName", valid_575086
  var valid_575087 = path.getOrDefault("scaleUnitNode")
  valid_575087 = validateParameter(valid_575087, JString, required = true,
                                 default = nil)
  if valid_575087 != nil:
    section.add "scaleUnitNode", valid_575087
  var valid_575088 = path.getOrDefault("subscriptionId")
  valid_575088 = validateParameter(valid_575088, JString, required = true,
                                 default = nil)
  if valid_575088 != nil:
    section.add "subscriptionId", valid_575088
  var valid_575089 = path.getOrDefault("location")
  valid_575089 = validateParameter(valid_575089, JString, required = true,
                                 default = nil)
  if valid_575089 != nil:
    section.add "location", valid_575089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575090 = query.getOrDefault("api-version")
  valid_575090 = validateParameter(valid_575090, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575090 != nil:
    section.add "api-version", valid_575090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575091: Call_ScaleUnitNodesStopMaintenanceMode_575083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stop maintenance mode for a scale unit node.
  ## 
  let valid = call_575091.validator(path, query, header, formData, body)
  let scheme = call_575091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575091.url(scheme.get, call_575091.host, call_575091.base,
                         call_575091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575091, url, valid)

proc call*(call_575092: Call_ScaleUnitNodesStopMaintenanceMode_575083;
          resourceGroupName: string; scaleUnitNode: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## scaleUnitNodesStopMaintenanceMode
  ## Stop maintenance mode for a scale unit node.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scaleUnitNode: string (required)
  ##                : Name of the scale unit node.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575093 = newJObject()
  var query_575094 = newJObject()
  add(path_575093, "resourceGroupName", newJString(resourceGroupName))
  add(query_575094, "api-version", newJString(apiVersion))
  add(path_575093, "scaleUnitNode", newJString(scaleUnitNode))
  add(path_575093, "subscriptionId", newJString(subscriptionId))
  add(path_575093, "location", newJString(location))
  result = call_575092.call(path_575093, query_575094, nil, nil, nil)

var scaleUnitNodesStopMaintenanceMode* = Call_ScaleUnitNodesStopMaintenanceMode_575083(
    name: "scaleUnitNodesStopMaintenanceMode", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnitNodes/{scaleUnitNode}/StopMaintenanceMode",
    validator: validate_ScaleUnitNodesStopMaintenanceMode_575084, base: "",
    url: url_ScaleUnitNodesStopMaintenanceMode_575085, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
