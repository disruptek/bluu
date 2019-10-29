
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DevTestLabsClient
## version: 2015-05-21-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure DevTest Labs REST API version 2015-05-21-preview.
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

  OpenApiRestCall_563548 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563548](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563548): Option[Scheme] {.used.} =
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
  macServiceName = "devtestlabs-DTL"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LabListBySubscription_563770 = ref object of OpenApiRestCall_563548
proc url_LabListBySubscription_563772(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabListBySubscription_563771(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563948 = path.getOrDefault("subscriptionId")
  valid_563948 = validateParameter(valid_563948, JString, required = true,
                                 default = nil)
  if valid_563948 != nil:
    section.add "subscriptionId", valid_563948
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_563949 = query.getOrDefault("$top")
  valid_563949 = validateParameter(valid_563949, JInt, required = false, default = nil)
  if valid_563949 != nil:
    section.add "$top", valid_563949
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563963 = query.getOrDefault("api-version")
  valid_563963 = validateParameter(valid_563963, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_563963 != nil:
    section.add "api-version", valid_563963
  var valid_563964 = query.getOrDefault("$filter")
  valid_563964 = validateParameter(valid_563964, JString, required = false,
                                 default = nil)
  if valid_563964 != nil:
    section.add "$filter", valid_563964
  var valid_563965 = query.getOrDefault("$orderBy")
  valid_563965 = validateParameter(valid_563965, JString, required = false,
                                 default = nil)
  if valid_563965 != nil:
    section.add "$orderBy", valid_563965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563988: Call_LabListBySubscription_563770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs.
  ## 
  let valid = call_563988.validator(path, query, header, formData, body)
  let scheme = call_563988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563988.url(scheme.get, call_563988.host, call_563988.base,
                         call_563988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563988, url, valid)

proc call*(call_564059: Call_LabListBySubscription_563770; subscriptionId: string;
          Top: int = 0; apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## labListBySubscription
  ## List labs.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564060 = newJObject()
  var query_564062 = newJObject()
  add(query_564062, "$top", newJInt(Top))
  add(query_564062, "api-version", newJString(apiVersion))
  add(path_564060, "subscriptionId", newJString(subscriptionId))
  add(query_564062, "$filter", newJString(Filter))
  add(query_564062, "$orderBy", newJString(OrderBy))
  result = call_564059.call(path_564060, query_564062, nil, nil, nil)

var labListBySubscription* = Call_LabListBySubscription_563770(
    name: "labListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabListBySubscription_563771, base: "",
    url: url_LabListBySubscription_563772, schemes: {Scheme.Https})
type
  Call_LabListByResourceGroup_564101 = ref object of OpenApiRestCall_563548
proc url_LabListByResourceGroup_564103(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabListByResourceGroup_564102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564106 = query.getOrDefault("$top")
  valid_564106 = validateParameter(valid_564106, JInt, required = false, default = nil)
  if valid_564106 != nil:
    section.add "$top", valid_564106
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  var valid_564108 = query.getOrDefault("$filter")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = nil)
  if valid_564108 != nil:
    section.add "$filter", valid_564108
  var valid_564109 = query.getOrDefault("$orderBy")
  valid_564109 = validateParameter(valid_564109, JString, required = false,
                                 default = nil)
  if valid_564109 != nil:
    section.add "$orderBy", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_LabListByResourceGroup_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_LabListByResourceGroup_564101; subscriptionId: string;
          resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## labListByResourceGroup
  ## List labs.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(query_564113, "$top", newJInt(Top))
  add(query_564113, "api-version", newJString(apiVersion))
  add(path_564112, "subscriptionId", newJString(subscriptionId))
  add(path_564112, "resourceGroupName", newJString(resourceGroupName))
  add(query_564113, "$filter", newJString(Filter))
  add(query_564113, "$orderBy", newJString(OrderBy))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var labListByResourceGroup* = Call_LabListByResourceGroup_564101(
    name: "labListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabListByResourceGroup_564102, base: "",
    url: url_LabListByResourceGroup_564103, schemes: {Scheme.Https})
type
  Call_ArtifactSourceList_564114 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourceList_564116(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceList_564115(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564117 = path.getOrDefault("labName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "labName", valid_564117
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564120 = query.getOrDefault("$top")
  valid_564120 = validateParameter(valid_564120, JInt, required = false, default = nil)
  if valid_564120 != nil:
    section.add "$top", valid_564120
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  var valid_564122 = query.getOrDefault("$filter")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "$filter", valid_564122
  var valid_564123 = query.getOrDefault("$orderBy")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "$orderBy", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_ArtifactSourceList_564114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_ArtifactSourceList_564114; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## artifactSourceList
  ## List artifact sources.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(path_564126, "labName", newJString(labName))
  add(query_564127, "$top", newJInt(Top))
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  add(query_564127, "$filter", newJString(Filter))
  add(query_564127, "$orderBy", newJString(OrderBy))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var artifactSourceList* = Call_ArtifactSourceList_564114(
    name: "artifactSourceList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourceList_564115, base: "",
    url: url_ArtifactSourceList_564116, schemes: {Scheme.Https})
type
  Call_ArtifactList_564128 = ref object of OpenApiRestCall_563548
proc url_ArtifactList_564130(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactList_564129(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564131 = path.getOrDefault("labName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "labName", valid_564131
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  var valid_564134 = path.getOrDefault("artifactSourceName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "artifactSourceName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564135 = query.getOrDefault("$top")
  valid_564135 = validateParameter(valid_564135, JInt, required = false, default = nil)
  if valid_564135 != nil:
    section.add "$top", valid_564135
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  var valid_564137 = query.getOrDefault("$filter")
  valid_564137 = validateParameter(valid_564137, JString, required = false,
                                 default = nil)
  if valid_564137 != nil:
    section.add "$filter", valid_564137
  var valid_564138 = query.getOrDefault("$orderBy")
  valid_564138 = validateParameter(valid_564138, JString, required = false,
                                 default = nil)
  if valid_564138 != nil:
    section.add "$orderBy", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_ArtifactList_564128; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_ArtifactList_564128; labName: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## artifactList
  ## List artifacts.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   OrderBy: string
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(path_564141, "labName", newJString(labName))
  add(query_564142, "$top", newJInt(Top))
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "resourceGroupName", newJString(resourceGroupName))
  add(query_564142, "$filter", newJString(Filter))
  add(path_564141, "artifactSourceName", newJString(artifactSourceName))
  add(query_564142, "$orderBy", newJString(OrderBy))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var artifactList* = Call_ArtifactList_564128(name: "artifactList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactList_564129, base: "", url: url_ArtifactList_564130,
    schemes: {Scheme.Https})
type
  Call_ArtifactGetResource_564143 = ref object of OpenApiRestCall_563548
proc url_ArtifactGetResource_564145(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactGetResource_564144(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564146 = path.getOrDefault("labName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "labName", valid_564146
  var valid_564147 = path.getOrDefault("name")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "name", valid_564147
  var valid_564148 = path.getOrDefault("subscriptionId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "subscriptionId", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  var valid_564150 = path.getOrDefault("artifactSourceName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "artifactSourceName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_ArtifactGetResource_564143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_ArtifactGetResource_564143; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactGetResource
  ## Get artifact.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(path_564154, "labName", newJString(labName))
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "name", newJString(name))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  add(path_564154, "artifactSourceName", newJString(artifactSourceName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var artifactGetResource* = Call_ArtifactGetResource_564143(
    name: "artifactGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactGetResource_564144, base: "",
    url: url_ArtifactGetResource_564145, schemes: {Scheme.Https})
type
  Call_ArtifactGenerateArmTemplate_564156 = ref object of OpenApiRestCall_563548
proc url_ArtifactGenerateArmTemplate_564158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateArmTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactGenerateArmTemplate_564157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564159 = path.getOrDefault("labName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "labName", valid_564159
  var valid_564160 = path.getOrDefault("name")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "name", valid_564160
  var valid_564161 = path.getOrDefault("subscriptionId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "subscriptionId", valid_564161
  var valid_564162 = path.getOrDefault("resourceGroupName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "resourceGroupName", valid_564162
  var valid_564163 = path.getOrDefault("artifactSourceName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "artifactSourceName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateArmTemplateRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_ArtifactGenerateArmTemplate_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_ArtifactGenerateArmTemplate_564156; labName: string;
          generateArmTemplateRequest: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactGenerateArmTemplate
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   generateArmTemplateRequest: JObject (required)
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  var body_564170 = newJObject()
  add(path_564168, "labName", newJString(labName))
  add(query_564169, "api-version", newJString(apiVersion))
  if generateArmTemplateRequest != nil:
    body_564170 = generateArmTemplateRequest
  add(path_564168, "name", newJString(name))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "resourceGroupName", newJString(resourceGroupName))
  add(path_564168, "artifactSourceName", newJString(artifactSourceName))
  result = call_564167.call(path_564168, query_564169, nil, nil, body_564170)

var artifactGenerateArmTemplate* = Call_ArtifactGenerateArmTemplate_564156(
    name: "artifactGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactGenerateArmTemplate_564157, base: "",
    url: url_ArtifactGenerateArmTemplate_564158, schemes: {Scheme.Https})
type
  Call_ArtifactSourceCreateOrUpdateResource_564183 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourceCreateOrUpdateResource_564185(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceCreateOrUpdateResource_564184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564186 = path.getOrDefault("labName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "labName", valid_564186
  var valid_564187 = path.getOrDefault("name")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "name", valid_564187
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_ArtifactSourceCreateOrUpdateResource_564183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_ArtifactSourceCreateOrUpdateResource_564183;
          labName: string; name: string; subscriptionId: string;
          artifactSource: JsonNode; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceCreateOrUpdateResource
  ## Create or replace an existing artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSource: JObject (required)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  var body_564196 = newJObject()
  add(path_564194, "labName", newJString(labName))
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "name", newJString(name))
  add(path_564194, "subscriptionId", newJString(subscriptionId))
  if artifactSource != nil:
    body_564196 = artifactSource
  add(path_564194, "resourceGroupName", newJString(resourceGroupName))
  result = call_564193.call(path_564194, query_564195, nil, nil, body_564196)

var artifactSourceCreateOrUpdateResource* = Call_ArtifactSourceCreateOrUpdateResource_564183(
    name: "artifactSourceCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceCreateOrUpdateResource_564184, base: "",
    url: url_ArtifactSourceCreateOrUpdateResource_564185, schemes: {Scheme.Https})
type
  Call_ArtifactSourceGetResource_564171 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourceGetResource_564173(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceGetResource_564172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564174 = path.getOrDefault("labName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "labName", valid_564174
  var valid_564175 = path.getOrDefault("name")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "name", valid_564175
  var valid_564176 = path.getOrDefault("subscriptionId")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "subscriptionId", valid_564176
  var valid_564177 = path.getOrDefault("resourceGroupName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "resourceGroupName", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_ArtifactSourceGetResource_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_ArtifactSourceGetResource_564171; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceGetResource
  ## Get artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  add(path_564181, "labName", newJString(labName))
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "name", newJString(name))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  result = call_564180.call(path_564181, query_564182, nil, nil, nil)

var artifactSourceGetResource* = Call_ArtifactSourceGetResource_564171(
    name: "artifactSourceGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceGetResource_564172, base: "",
    url: url_ArtifactSourceGetResource_564173, schemes: {Scheme.Https})
type
  Call_ArtifactSourcePatchResource_564209 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourcePatchResource_564211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcePatchResource_564210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564212 = path.getOrDefault("labName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "labName", valid_564212
  var valid_564213 = path.getOrDefault("name")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "name", valid_564213
  var valid_564214 = path.getOrDefault("subscriptionId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "subscriptionId", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_ArtifactSourcePatchResource_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of artifact sources.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_ArtifactSourcePatchResource_564209; labName: string;
          name: string; subscriptionId: string; artifactSource: JsonNode;
          resourceGroupName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourcePatchResource
  ## Modify properties of artifact sources.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSource: JObject (required)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(path_564220, "labName", newJString(labName))
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "name", newJString(name))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  if artifactSource != nil:
    body_564222 = artifactSource
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var artifactSourcePatchResource* = Call_ArtifactSourcePatchResource_564209(
    name: "artifactSourcePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcePatchResource_564210, base: "",
    url: url_ArtifactSourcePatchResource_564211, schemes: {Scheme.Https})
type
  Call_ArtifactSourceDeleteResource_564197 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourceDeleteResource_564199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceDeleteResource_564198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564200 = path.getOrDefault("labName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "labName", valid_564200
  var valid_564201 = path.getOrDefault("name")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "name", valid_564201
  var valid_564202 = path.getOrDefault("subscriptionId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "subscriptionId", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_ArtifactSourceDeleteResource_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_ArtifactSourceDeleteResource_564197; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceDeleteResource
  ## Delete artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(path_564207, "labName", newJString(labName))
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "name", newJString(name))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var artifactSourceDeleteResource* = Call_ArtifactSourceDeleteResource_564197(
    name: "artifactSourceDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceDeleteResource_564198, base: "",
    url: url_ArtifactSourceDeleteResource_564199, schemes: {Scheme.Https})
type
  Call_CostInsightList_564223 = ref object of OpenApiRestCall_563548
proc url_CostInsightList_564225(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costinsights")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostInsightList_564224(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List cost insights.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564226 = path.getOrDefault("labName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "labName", valid_564226
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("resourceGroupName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceGroupName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564229 = query.getOrDefault("$top")
  valid_564229 = validateParameter(valid_564229, JInt, required = false, default = nil)
  if valid_564229 != nil:
    section.add "$top", valid_564229
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  var valid_564231 = query.getOrDefault("$filter")
  valid_564231 = validateParameter(valid_564231, JString, required = false,
                                 default = nil)
  if valid_564231 != nil:
    section.add "$filter", valid_564231
  var valid_564232 = query.getOrDefault("$orderBy")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "$orderBy", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_CostInsightList_564223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cost insights.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_CostInsightList_564223; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## costInsightList
  ## List cost insights.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  add(path_564235, "labName", newJString(labName))
  add(query_564236, "$top", newJInt(Top))
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  add(query_564236, "$filter", newJString(Filter))
  add(query_564236, "$orderBy", newJString(OrderBy))
  result = call_564234.call(path_564235, query_564236, nil, nil, nil)

var costInsightList* = Call_CostInsightList_564223(name: "costInsightList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights",
    validator: validate_CostInsightList_564224, base: "", url: url_CostInsightList_564225,
    schemes: {Scheme.Https})
type
  Call_CostInsightGetResource_564237 = ref object of OpenApiRestCall_563548
proc url_CostInsightGetResource_564239(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costinsights/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostInsightGetResource_564238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost insight.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564240 = path.getOrDefault("labName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "labName", valid_564240
  var valid_564241 = path.getOrDefault("name")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "name", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("resourceGroupName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceGroupName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564244 != nil:
    section.add "api-version", valid_564244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564245: Call_CostInsightGetResource_564237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost insight.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_CostInsightGetResource_564237; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costInsightGetResource
  ## Get cost insight.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  add(path_564247, "labName", newJString(labName))
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "name", newJString(name))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  result = call_564246.call(path_564247, query_564248, nil, nil, nil)

var costInsightGetResource* = Call_CostInsightGetResource_564237(
    name: "costInsightGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights/{name}",
    validator: validate_CostInsightGetResource_564238, base: "",
    url: url_CostInsightGetResource_564239, schemes: {Scheme.Https})
type
  Call_CostInsightRefreshData_564249 = ref object of OpenApiRestCall_563548
proc url_CostInsightRefreshData_564251(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costinsights/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/refreshData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostInsightRefreshData_564250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564252 = path.getOrDefault("labName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "labName", valid_564252
  var valid_564253 = path.getOrDefault("name")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "name", valid_564253
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_CostInsightRefreshData_564249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_CostInsightRefreshData_564249; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costInsightRefreshData
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(path_564259, "labName", newJString(labName))
  add(query_564260, "api-version", newJString(apiVersion))
  add(path_564259, "name", newJString(name))
  add(path_564259, "subscriptionId", newJString(subscriptionId))
  add(path_564259, "resourceGroupName", newJString(resourceGroupName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var costInsightRefreshData* = Call_CostInsightRefreshData_564249(
    name: "costInsightRefreshData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights/{name}/refreshData",
    validator: validate_CostInsightRefreshData_564250, base: "",
    url: url_CostInsightRefreshData_564251, schemes: {Scheme.Https})
type
  Call_CostList_564261 = ref object of OpenApiRestCall_563548
proc url_CostList_564263(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostList_564262(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List costs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564264 = path.getOrDefault("labName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "labName", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("resourceGroupName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "resourceGroupName", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564267 = query.getOrDefault("$top")
  valid_564267 = validateParameter(valid_564267, JInt, required = false, default = nil)
  if valid_564267 != nil:
    section.add "$top", valid_564267
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  var valid_564269 = query.getOrDefault("$filter")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "$filter", valid_564269
  var valid_564270 = query.getOrDefault("$orderBy")
  valid_564270 = validateParameter(valid_564270, JString, required = false,
                                 default = nil)
  if valid_564270 != nil:
    section.add "$orderBy", valid_564270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_CostList_564261; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List costs.
  ## 
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_CostList_564261; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## costList
  ## List costs.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  add(path_564273, "labName", newJString(labName))
  add(query_564274, "$top", newJInt(Top))
  add(query_564274, "api-version", newJString(apiVersion))
  add(path_564273, "subscriptionId", newJString(subscriptionId))
  add(path_564273, "resourceGroupName", newJString(resourceGroupName))
  add(query_564274, "$filter", newJString(Filter))
  add(query_564274, "$orderBy", newJString(OrderBy))
  result = call_564272.call(path_564273, query_564274, nil, nil, nil)

var costList* = Call_CostList_564261(name: "costList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs",
                                  validator: validate_CostList_564262, base: "",
                                  url: url_CostList_564263,
                                  schemes: {Scheme.Https})
type
  Call_CostGetResource_564275 = ref object of OpenApiRestCall_563548
proc url_CostGetResource_564277(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostGetResource_564276(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564278 = path.getOrDefault("labName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "labName", valid_564278
  var valid_564279 = path.getOrDefault("name")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "name", valid_564279
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("resourceGroupName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "resourceGroupName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_CostGetResource_564275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_CostGetResource_564275; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costGetResource
  ## Get cost.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  add(path_564285, "labName", newJString(labName))
  add(query_564286, "api-version", newJString(apiVersion))
  add(path_564285, "name", newJString(name))
  add(path_564285, "subscriptionId", newJString(subscriptionId))
  add(path_564285, "resourceGroupName", newJString(resourceGroupName))
  result = call_564284.call(path_564285, query_564286, nil, nil, nil)

var costGetResource* = Call_CostGetResource_564275(name: "costGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostGetResource_564276, base: "", url: url_CostGetResource_564277,
    schemes: {Scheme.Https})
type
  Call_CostRefreshData_564287 = ref object of OpenApiRestCall_563548
proc url_CostRefreshData_564289(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/refreshData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostRefreshData_564288(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564290 = path.getOrDefault("labName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "labName", valid_564290
  var valid_564291 = path.getOrDefault("name")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "name", valid_564291
  var valid_564292 = path.getOrDefault("subscriptionId")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "subscriptionId", valid_564292
  var valid_564293 = path.getOrDefault("resourceGroupName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "resourceGroupName", valid_564293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564294 = query.getOrDefault("api-version")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564294 != nil:
    section.add "api-version", valid_564294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564295: Call_CostRefreshData_564287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ## 
  let valid = call_564295.validator(path, query, header, formData, body)
  let scheme = call_564295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564295.url(scheme.get, call_564295.host, call_564295.base,
                         call_564295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564295, url, valid)

proc call*(call_564296: Call_CostRefreshData_564287; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costRefreshData
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564297 = newJObject()
  var query_564298 = newJObject()
  add(path_564297, "labName", newJString(labName))
  add(query_564298, "api-version", newJString(apiVersion))
  add(path_564297, "name", newJString(name))
  add(path_564297, "subscriptionId", newJString(subscriptionId))
  add(path_564297, "resourceGroupName", newJString(resourceGroupName))
  result = call_564296.call(path_564297, query_564298, nil, nil, nil)

var costRefreshData* = Call_CostRefreshData_564287(name: "costRefreshData",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}/refreshData",
    validator: validate_CostRefreshData_564288, base: "", url: url_CostRefreshData_564289,
    schemes: {Scheme.Https})
type
  Call_CustomImageList_564299 = ref object of OpenApiRestCall_563548
proc url_CustomImageList_564301(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageList_564300(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List custom images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564302 = path.getOrDefault("labName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "labName", valid_564302
  var valid_564303 = path.getOrDefault("subscriptionId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "subscriptionId", valid_564303
  var valid_564304 = path.getOrDefault("resourceGroupName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "resourceGroupName", valid_564304
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564305 = query.getOrDefault("$top")
  valid_564305 = validateParameter(valid_564305, JInt, required = false, default = nil)
  if valid_564305 != nil:
    section.add "$top", valid_564305
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  var valid_564307 = query.getOrDefault("$filter")
  valid_564307 = validateParameter(valid_564307, JString, required = false,
                                 default = nil)
  if valid_564307 != nil:
    section.add "$filter", valid_564307
  var valid_564308 = query.getOrDefault("$orderBy")
  valid_564308 = validateParameter(valid_564308, JString, required = false,
                                 default = nil)
  if valid_564308 != nil:
    section.add "$orderBy", valid_564308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_CustomImageList_564299; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images.
  ## 
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_CustomImageList_564299; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## customImageList
  ## List custom images.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564311 = newJObject()
  var query_564312 = newJObject()
  add(path_564311, "labName", newJString(labName))
  add(query_564312, "$top", newJInt(Top))
  add(query_564312, "api-version", newJString(apiVersion))
  add(path_564311, "subscriptionId", newJString(subscriptionId))
  add(path_564311, "resourceGroupName", newJString(resourceGroupName))
  add(query_564312, "$filter", newJString(Filter))
  add(query_564312, "$orderBy", newJString(OrderBy))
  result = call_564310.call(path_564311, query_564312, nil, nil, nil)

var customImageList* = Call_CustomImageList_564299(name: "customImageList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImageList_564300, base: "", url: url_CustomImageList_564301,
    schemes: {Scheme.Https})
type
  Call_CustomImageCreateOrUpdateResource_564325 = ref object of OpenApiRestCall_563548
proc url_CustomImageCreateOrUpdateResource_564327(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageCreateOrUpdateResource_564326(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564328 = path.getOrDefault("labName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "labName", valid_564328
  var valid_564329 = path.getOrDefault("name")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "name", valid_564329
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564332 != nil:
    section.add "api-version", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customImage: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_CustomImageCreateOrUpdateResource_564325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_CustomImageCreateOrUpdateResource_564325;
          labName: string; customImage: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageCreateOrUpdateResource
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   customImage: JObject (required)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  var body_564338 = newJObject()
  add(path_564336, "labName", newJString(labName))
  if customImage != nil:
    body_564338 = customImage
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "name", newJString(name))
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  result = call_564335.call(path_564336, query_564337, nil, nil, body_564338)

var customImageCreateOrUpdateResource* = Call_CustomImageCreateOrUpdateResource_564325(
    name: "customImageCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageCreateOrUpdateResource_564326, base: "",
    url: url_CustomImageCreateOrUpdateResource_564327, schemes: {Scheme.Https})
type
  Call_CustomImageGetResource_564313 = ref object of OpenApiRestCall_563548
proc url_CustomImageGetResource_564315(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageGetResource_564314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get custom image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564316 = path.getOrDefault("labName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "labName", valid_564316
  var valid_564317 = path.getOrDefault("name")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "name", valid_564317
  var valid_564318 = path.getOrDefault("subscriptionId")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "subscriptionId", valid_564318
  var valid_564319 = path.getOrDefault("resourceGroupName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "resourceGroupName", valid_564319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564320 = query.getOrDefault("api-version")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564320 != nil:
    section.add "api-version", valid_564320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_CustomImageGetResource_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_CustomImageGetResource_564313; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageGetResource
  ## Get custom image.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(path_564323, "labName", newJString(labName))
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "name", newJString(name))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var customImageGetResource* = Call_CustomImageGetResource_564313(
    name: "customImageGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageGetResource_564314, base: "",
    url: url_CustomImageGetResource_564315, schemes: {Scheme.Https})
type
  Call_CustomImageDeleteResource_564339 = ref object of OpenApiRestCall_563548
proc url_CustomImageDeleteResource_564341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageDeleteResource_564340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564342 = path.getOrDefault("labName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "labName", valid_564342
  var valid_564343 = path.getOrDefault("name")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "name", valid_564343
  var valid_564344 = path.getOrDefault("subscriptionId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "subscriptionId", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_CustomImageDeleteResource_564339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_CustomImageDeleteResource_564339; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageDeleteResource
  ## Delete custom image. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564349 = newJObject()
  var query_564350 = newJObject()
  add(path_564349, "labName", newJString(labName))
  add(query_564350, "api-version", newJString(apiVersion))
  add(path_564349, "name", newJString(name))
  add(path_564349, "subscriptionId", newJString(subscriptionId))
  add(path_564349, "resourceGroupName", newJString(resourceGroupName))
  result = call_564348.call(path_564349, query_564350, nil, nil, nil)

var customImageDeleteResource* = Call_CustomImageDeleteResource_564339(
    name: "customImageDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageDeleteResource_564340, base: "",
    url: url_CustomImageDeleteResource_564341, schemes: {Scheme.Https})
type
  Call_FormulaList_564351 = ref object of OpenApiRestCall_563548
proc url_FormulaList_564353(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaList_564352(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List formulas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564354 = path.getOrDefault("labName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "labName", valid_564354
  var valid_564355 = path.getOrDefault("subscriptionId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "subscriptionId", valid_564355
  var valid_564356 = path.getOrDefault("resourceGroupName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "resourceGroupName", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564357 = query.getOrDefault("$top")
  valid_564357 = validateParameter(valid_564357, JInt, required = false, default = nil)
  if valid_564357 != nil:
    section.add "$top", valid_564357
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564358 = query.getOrDefault("api-version")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564358 != nil:
    section.add "api-version", valid_564358
  var valid_564359 = query.getOrDefault("$filter")
  valid_564359 = validateParameter(valid_564359, JString, required = false,
                                 default = nil)
  if valid_564359 != nil:
    section.add "$filter", valid_564359
  var valid_564360 = query.getOrDefault("$orderBy")
  valid_564360 = validateParameter(valid_564360, JString, required = false,
                                 default = nil)
  if valid_564360 != nil:
    section.add "$orderBy", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_FormulaList_564351; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas.
  ## 
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_FormulaList_564351; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## formulaList
  ## List formulas.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(path_564363, "labName", newJString(labName))
  add(query_564364, "$top", newJInt(Top))
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "subscriptionId", newJString(subscriptionId))
  add(path_564363, "resourceGroupName", newJString(resourceGroupName))
  add(query_564364, "$filter", newJString(Filter))
  add(query_564364, "$orderBy", newJString(OrderBy))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var formulaList* = Call_FormulaList_564351(name: "formulaList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
                                        validator: validate_FormulaList_564352,
                                        base: "", url: url_FormulaList_564353,
                                        schemes: {Scheme.Https})
type
  Call_FormulaCreateOrUpdateResource_564377 = ref object of OpenApiRestCall_563548
proc url_FormulaCreateOrUpdateResource_564379(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaCreateOrUpdateResource_564378(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564380 = path.getOrDefault("labName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "labName", valid_564380
  var valid_564381 = path.getOrDefault("name")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "name", valid_564381
  var valid_564382 = path.getOrDefault("subscriptionId")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "subscriptionId", valid_564382
  var valid_564383 = path.getOrDefault("resourceGroupName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "resourceGroupName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564384 = query.getOrDefault("api-version")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564384 != nil:
    section.add "api-version", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   formula: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564386: Call_FormulaCreateOrUpdateResource_564377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_FormulaCreateOrUpdateResource_564377; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          formula: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaCreateOrUpdateResource
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  var path_564388 = newJObject()
  var query_564389 = newJObject()
  var body_564390 = newJObject()
  add(path_564388, "labName", newJString(labName))
  add(query_564389, "api-version", newJString(apiVersion))
  add(path_564388, "name", newJString(name))
  add(path_564388, "subscriptionId", newJString(subscriptionId))
  add(path_564388, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_564390 = formula
  result = call_564387.call(path_564388, query_564389, nil, nil, body_564390)

var formulaCreateOrUpdateResource* = Call_FormulaCreateOrUpdateResource_564377(
    name: "formulaCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaCreateOrUpdateResource_564378, base: "",
    url: url_FormulaCreateOrUpdateResource_564379, schemes: {Scheme.Https})
type
  Call_FormulaGetResource_564365 = ref object of OpenApiRestCall_563548
proc url_FormulaGetResource_564367(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaGetResource_564366(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564368 = path.getOrDefault("labName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "labName", valid_564368
  var valid_564369 = path.getOrDefault("name")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "name", valid_564369
  var valid_564370 = path.getOrDefault("subscriptionId")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "subscriptionId", valid_564370
  var valid_564371 = path.getOrDefault("resourceGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "resourceGroupName", valid_564371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564372 = query.getOrDefault("api-version")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564372 != nil:
    section.add "api-version", valid_564372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564373: Call_FormulaGetResource_564365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_FormulaGetResource_564365; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaGetResource
  ## Get formula.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(path_564375, "labName", newJString(labName))
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "name", newJString(name))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var formulaGetResource* = Call_FormulaGetResource_564365(
    name: "formulaGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaGetResource_564366, base: "",
    url: url_FormulaGetResource_564367, schemes: {Scheme.Https})
type
  Call_FormulaDeleteResource_564391 = ref object of OpenApiRestCall_563548
proc url_FormulaDeleteResource_564393(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaDeleteResource_564392(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564394 = path.getOrDefault("labName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "labName", valid_564394
  var valid_564395 = path.getOrDefault("name")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "name", valid_564395
  var valid_564396 = path.getOrDefault("subscriptionId")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "subscriptionId", valid_564396
  var valid_564397 = path.getOrDefault("resourceGroupName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "resourceGroupName", valid_564397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564398 = query.getOrDefault("api-version")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564398 != nil:
    section.add "api-version", valid_564398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564399: Call_FormulaDeleteResource_564391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_564399.validator(path, query, header, formData, body)
  let scheme = call_564399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564399.url(scheme.get, call_564399.host, call_564399.base,
                         call_564399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564399, url, valid)

proc call*(call_564400: Call_FormulaDeleteResource_564391; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaDeleteResource
  ## Delete formula.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564401 = newJObject()
  var query_564402 = newJObject()
  add(path_564401, "labName", newJString(labName))
  add(query_564402, "api-version", newJString(apiVersion))
  add(path_564401, "name", newJString(name))
  add(path_564401, "subscriptionId", newJString(subscriptionId))
  add(path_564401, "resourceGroupName", newJString(resourceGroupName))
  result = call_564400.call(path_564401, query_564402, nil, nil, nil)

var formulaDeleteResource* = Call_FormulaDeleteResource_564391(
    name: "formulaDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaDeleteResource_564392, base: "",
    url: url_FormulaDeleteResource_564393, schemes: {Scheme.Https})
type
  Call_GalleryImageList_564403 = ref object of OpenApiRestCall_563548
proc url_GalleryImageList_564405(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/galleryimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImageList_564404(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List gallery images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564406 = path.getOrDefault("labName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "labName", valid_564406
  var valid_564407 = path.getOrDefault("subscriptionId")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "subscriptionId", valid_564407
  var valid_564408 = path.getOrDefault("resourceGroupName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "resourceGroupName", valid_564408
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564409 = query.getOrDefault("$top")
  valid_564409 = validateParameter(valid_564409, JInt, required = false, default = nil)
  if valid_564409 != nil:
    section.add "$top", valid_564409
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564410 != nil:
    section.add "api-version", valid_564410
  var valid_564411 = query.getOrDefault("$filter")
  valid_564411 = validateParameter(valid_564411, JString, required = false,
                                 default = nil)
  if valid_564411 != nil:
    section.add "$filter", valid_564411
  var valid_564412 = query.getOrDefault("$orderBy")
  valid_564412 = validateParameter(valid_564412, JString, required = false,
                                 default = nil)
  if valid_564412 != nil:
    section.add "$orderBy", valid_564412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_GalleryImageList_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_GalleryImageList_564403; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## galleryImageList
  ## List gallery images.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  add(path_564415, "labName", newJString(labName))
  add(query_564416, "$top", newJInt(Top))
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  add(query_564416, "$filter", newJString(Filter))
  add(query_564416, "$orderBy", newJString(OrderBy))
  result = call_564414.call(path_564415, query_564416, nil, nil, nil)

var galleryImageList* = Call_GalleryImageList_564403(name: "galleryImageList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImageList_564404, base: "",
    url: url_GalleryImageList_564405, schemes: {Scheme.Https})
type
  Call_PolicySetEvaluatePolicies_564417 = ref object of OpenApiRestCall_563548
proc url_PolicySetEvaluatePolicies_564419(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/evaluatePolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetEvaluatePolicies_564418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Evaluates Lab Policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564420 = path.getOrDefault("labName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "labName", valid_564420
  var valid_564421 = path.getOrDefault("name")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "name", valid_564421
  var valid_564422 = path.getOrDefault("subscriptionId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "subscriptionId", valid_564422
  var valid_564423 = path.getOrDefault("resourceGroupName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "resourceGroupName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   evaluatePoliciesRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_PolicySetEvaluatePolicies_564417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates Lab Policy.
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_PolicySetEvaluatePolicies_564417; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          evaluatePoliciesRequest: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policySetEvaluatePolicies
  ## Evaluates Lab Policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   evaluatePoliciesRequest: JObject (required)
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  var body_564430 = newJObject()
  add(path_564428, "labName", newJString(labName))
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "name", newJString(name))
  add(path_564428, "subscriptionId", newJString(subscriptionId))
  add(path_564428, "resourceGroupName", newJString(resourceGroupName))
  if evaluatePoliciesRequest != nil:
    body_564430 = evaluatePoliciesRequest
  result = call_564427.call(path_564428, query_564429, nil, nil, body_564430)

var policySetEvaluatePolicies* = Call_PolicySetEvaluatePolicies_564417(
    name: "policySetEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetEvaluatePolicies_564418, base: "",
    url: url_PolicySetEvaluatePolicies_564419, schemes: {Scheme.Https})
type
  Call_PolicyList_564431 = ref object of OpenApiRestCall_563548
proc url_PolicyList_564433(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyList_564432(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564434 = path.getOrDefault("labName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "labName", valid_564434
  var valid_564435 = path.getOrDefault("policySetName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "policySetName", valid_564435
  var valid_564436 = path.getOrDefault("subscriptionId")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "subscriptionId", valid_564436
  var valid_564437 = path.getOrDefault("resourceGroupName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "resourceGroupName", valid_564437
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564438 = query.getOrDefault("$top")
  valid_564438 = validateParameter(valid_564438, JInt, required = false, default = nil)
  if valid_564438 != nil:
    section.add "$top", valid_564438
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564439 = query.getOrDefault("api-version")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564439 != nil:
    section.add "api-version", valid_564439
  var valid_564440 = query.getOrDefault("$filter")
  valid_564440 = validateParameter(valid_564440, JString, required = false,
                                 default = nil)
  if valid_564440 != nil:
    section.add "$filter", valid_564440
  var valid_564441 = query.getOrDefault("$orderBy")
  valid_564441 = validateParameter(valid_564441, JString, required = false,
                                 default = nil)
  if valid_564441 != nil:
    section.add "$orderBy", valid_564441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564442: Call_PolicyList_564431; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies.
  ## 
  let valid = call_564442.validator(path, query, header, formData, body)
  let scheme = call_564442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564442.url(scheme.get, call_564442.host, call_564442.base,
                         call_564442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564442, url, valid)

proc call*(call_564443: Call_PolicyList_564431; labName: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## policyList
  ## List policies.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564444 = newJObject()
  var query_564445 = newJObject()
  add(path_564444, "labName", newJString(labName))
  add(query_564445, "$top", newJInt(Top))
  add(query_564445, "api-version", newJString(apiVersion))
  add(path_564444, "policySetName", newJString(policySetName))
  add(path_564444, "subscriptionId", newJString(subscriptionId))
  add(path_564444, "resourceGroupName", newJString(resourceGroupName))
  add(query_564445, "$filter", newJString(Filter))
  add(query_564445, "$orderBy", newJString(OrderBy))
  result = call_564443.call(path_564444, query_564445, nil, nil, nil)

var policyList* = Call_PolicyList_564431(name: "policyList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
                                      validator: validate_PolicyList_564432,
                                      base: "", url: url_PolicyList_564433,
                                      schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdateResource_564459 = ref object of OpenApiRestCall_563548
proc url_PolicyCreateOrUpdateResource_564461(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyCreateOrUpdateResource_564460(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564462 = path.getOrDefault("labName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "labName", valid_564462
  var valid_564463 = path.getOrDefault("name")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "name", valid_564463
  var valid_564464 = path.getOrDefault("policySetName")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "policySetName", valid_564464
  var valid_564465 = path.getOrDefault("subscriptionId")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "subscriptionId", valid_564465
  var valid_564466 = path.getOrDefault("resourceGroupName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "resourceGroupName", valid_564466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564467 = query.getOrDefault("api-version")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564467 != nil:
    section.add "api-version", valid_564467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_PolicyCreateOrUpdateResource_564459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_PolicyCreateOrUpdateResource_564459; labName: string;
          policy: JsonNode; name: string; policySetName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyCreateOrUpdateResource
  ## Create or replace an existing policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   policy: JObject (required)
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564471 = newJObject()
  var query_564472 = newJObject()
  var body_564473 = newJObject()
  add(path_564471, "labName", newJString(labName))
  add(query_564472, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564473 = policy
  add(path_564471, "name", newJString(name))
  add(path_564471, "policySetName", newJString(policySetName))
  add(path_564471, "subscriptionId", newJString(subscriptionId))
  add(path_564471, "resourceGroupName", newJString(resourceGroupName))
  result = call_564470.call(path_564471, query_564472, nil, nil, body_564473)

var policyCreateOrUpdateResource* = Call_PolicyCreateOrUpdateResource_564459(
    name: "policyCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyCreateOrUpdateResource_564460, base: "",
    url: url_PolicyCreateOrUpdateResource_564461, schemes: {Scheme.Https})
type
  Call_PolicyGetResource_564446 = ref object of OpenApiRestCall_563548
proc url_PolicyGetResource_564448(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGetResource_564447(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564449 = path.getOrDefault("labName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "labName", valid_564449
  var valid_564450 = path.getOrDefault("name")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "name", valid_564450
  var valid_564451 = path.getOrDefault("policySetName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "policySetName", valid_564451
  var valid_564452 = path.getOrDefault("subscriptionId")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "subscriptionId", valid_564452
  var valid_564453 = path.getOrDefault("resourceGroupName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "resourceGroupName", valid_564453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564454 = query.getOrDefault("api-version")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564454 != nil:
    section.add "api-version", valid_564454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564455: Call_PolicyGetResource_564446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_564455.validator(path, query, header, formData, body)
  let scheme = call_564455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564455.url(scheme.get, call_564455.host, call_564455.base,
                         call_564455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564455, url, valid)

proc call*(call_564456: Call_PolicyGetResource_564446; labName: string; name: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyGetResource
  ## Get policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564457 = newJObject()
  var query_564458 = newJObject()
  add(path_564457, "labName", newJString(labName))
  add(query_564458, "api-version", newJString(apiVersion))
  add(path_564457, "name", newJString(name))
  add(path_564457, "policySetName", newJString(policySetName))
  add(path_564457, "subscriptionId", newJString(subscriptionId))
  add(path_564457, "resourceGroupName", newJString(resourceGroupName))
  result = call_564456.call(path_564457, query_564458, nil, nil, nil)

var policyGetResource* = Call_PolicyGetResource_564446(name: "policyGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyGetResource_564447, base: "",
    url: url_PolicyGetResource_564448, schemes: {Scheme.Https})
type
  Call_PolicyPatchResource_564487 = ref object of OpenApiRestCall_563548
proc url_PolicyPatchResource_564489(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyPatchResource_564488(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modify properties of policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564490 = path.getOrDefault("labName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "labName", valid_564490
  var valid_564491 = path.getOrDefault("name")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "name", valid_564491
  var valid_564492 = path.getOrDefault("policySetName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "policySetName", valid_564492
  var valid_564493 = path.getOrDefault("subscriptionId")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "subscriptionId", valid_564493
  var valid_564494 = path.getOrDefault("resourceGroupName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "resourceGroupName", valid_564494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564495 = query.getOrDefault("api-version")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564495 != nil:
    section.add "api-version", valid_564495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564497: Call_PolicyPatchResource_564487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of policies.
  ## 
  let valid = call_564497.validator(path, query, header, formData, body)
  let scheme = call_564497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564497.url(scheme.get, call_564497.host, call_564497.base,
                         call_564497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564497, url, valid)

proc call*(call_564498: Call_PolicyPatchResource_564487; labName: string;
          policy: JsonNode; name: string; policySetName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyPatchResource
  ## Modify properties of policies.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   policy: JObject (required)
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564499 = newJObject()
  var query_564500 = newJObject()
  var body_564501 = newJObject()
  add(path_564499, "labName", newJString(labName))
  add(query_564500, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564501 = policy
  add(path_564499, "name", newJString(name))
  add(path_564499, "policySetName", newJString(policySetName))
  add(path_564499, "subscriptionId", newJString(subscriptionId))
  add(path_564499, "resourceGroupName", newJString(resourceGroupName))
  result = call_564498.call(path_564499, query_564500, nil, nil, body_564501)

var policyPatchResource* = Call_PolicyPatchResource_564487(
    name: "policyPatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyPatchResource_564488, base: "",
    url: url_PolicyPatchResource_564489, schemes: {Scheme.Https})
type
  Call_PolicyDeleteResource_564474 = ref object of OpenApiRestCall_563548
proc url_PolicyDeleteResource_564476(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDeleteResource_564475(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564477 = path.getOrDefault("labName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "labName", valid_564477
  var valid_564478 = path.getOrDefault("name")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "name", valid_564478
  var valid_564479 = path.getOrDefault("policySetName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "policySetName", valid_564479
  var valid_564480 = path.getOrDefault("subscriptionId")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "subscriptionId", valid_564480
  var valid_564481 = path.getOrDefault("resourceGroupName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "resourceGroupName", valid_564481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564482 = query.getOrDefault("api-version")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564482 != nil:
    section.add "api-version", valid_564482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564483: Call_PolicyDeleteResource_564474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_PolicyDeleteResource_564474; labName: string;
          name: string; policySetName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyDeleteResource
  ## Delete policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  add(path_564485, "labName", newJString(labName))
  add(query_564486, "api-version", newJString(apiVersion))
  add(path_564485, "name", newJString(name))
  add(path_564485, "policySetName", newJString(policySetName))
  add(path_564485, "subscriptionId", newJString(subscriptionId))
  add(path_564485, "resourceGroupName", newJString(resourceGroupName))
  result = call_564484.call(path_564485, query_564486, nil, nil, nil)

var policyDeleteResource* = Call_PolicyDeleteResource_564474(
    name: "policyDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyDeleteResource_564475, base: "",
    url: url_PolicyDeleteResource_564476, schemes: {Scheme.Https})
type
  Call_ScheduleList_564502 = ref object of OpenApiRestCall_563548
proc url_ScheduleList_564504(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleList_564503(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564505 = path.getOrDefault("labName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "labName", valid_564505
  var valid_564506 = path.getOrDefault("subscriptionId")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "subscriptionId", valid_564506
  var valid_564507 = path.getOrDefault("resourceGroupName")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "resourceGroupName", valid_564507
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564508 = query.getOrDefault("$top")
  valid_564508 = validateParameter(valid_564508, JInt, required = false, default = nil)
  if valid_564508 != nil:
    section.add "$top", valid_564508
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  var valid_564510 = query.getOrDefault("$filter")
  valid_564510 = validateParameter(valid_564510, JString, required = false,
                                 default = nil)
  if valid_564510 != nil:
    section.add "$filter", valid_564510
  var valid_564511 = query.getOrDefault("$orderBy")
  valid_564511 = validateParameter(valid_564511, JString, required = false,
                                 default = nil)
  if valid_564511 != nil:
    section.add "$orderBy", valid_564511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564512: Call_ScheduleList_564502; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules.
  ## 
  let valid = call_564512.validator(path, query, header, formData, body)
  let scheme = call_564512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564512.url(scheme.get, call_564512.host, call_564512.base,
                         call_564512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564512, url, valid)

proc call*(call_564513: Call_ScheduleList_564502; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## scheduleList
  ## List schedules.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564514 = newJObject()
  var query_564515 = newJObject()
  add(path_564514, "labName", newJString(labName))
  add(query_564515, "$top", newJInt(Top))
  add(query_564515, "api-version", newJString(apiVersion))
  add(path_564514, "subscriptionId", newJString(subscriptionId))
  add(path_564514, "resourceGroupName", newJString(resourceGroupName))
  add(query_564515, "$filter", newJString(Filter))
  add(query_564515, "$orderBy", newJString(OrderBy))
  result = call_564513.call(path_564514, query_564515, nil, nil, nil)

var scheduleList* = Call_ScheduleList_564502(name: "scheduleList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_ScheduleList_564503, base: "", url: url_ScheduleList_564504,
    schemes: {Scheme.Https})
type
  Call_ScheduleCreateOrUpdateResource_564528 = ref object of OpenApiRestCall_563548
proc url_ScheduleCreateOrUpdateResource_564530(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleCreateOrUpdateResource_564529(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564531 = path.getOrDefault("labName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "labName", valid_564531
  var valid_564532 = path.getOrDefault("name")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "name", valid_564532
  var valid_564533 = path.getOrDefault("subscriptionId")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "subscriptionId", valid_564533
  var valid_564534 = path.getOrDefault("resourceGroupName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "resourceGroupName", valid_564534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564535 = query.getOrDefault("api-version")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564535 != nil:
    section.add "api-version", valid_564535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564537: Call_ScheduleCreateOrUpdateResource_564528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ## 
  let valid = call_564537.validator(path, query, header, formData, body)
  let scheme = call_564537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564537.url(scheme.get, call_564537.host, call_564537.base,
                         call_564537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564537, url, valid)

proc call*(call_564538: Call_ScheduleCreateOrUpdateResource_564528;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleCreateOrUpdateResource
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  var path_564539 = newJObject()
  var query_564540 = newJObject()
  var body_564541 = newJObject()
  add(path_564539, "labName", newJString(labName))
  add(query_564540, "api-version", newJString(apiVersion))
  add(path_564539, "name", newJString(name))
  add(path_564539, "subscriptionId", newJString(subscriptionId))
  add(path_564539, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_564541 = schedule
  result = call_564538.call(path_564539, query_564540, nil, nil, body_564541)

var scheduleCreateOrUpdateResource* = Call_ScheduleCreateOrUpdateResource_564528(
    name: "scheduleCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleCreateOrUpdateResource_564529, base: "",
    url: url_ScheduleCreateOrUpdateResource_564530, schemes: {Scheme.Https})
type
  Call_ScheduleGetResource_564516 = ref object of OpenApiRestCall_563548
proc url_ScheduleGetResource_564518(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleGetResource_564517(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564519 = path.getOrDefault("labName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "labName", valid_564519
  var valid_564520 = path.getOrDefault("name")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "name", valid_564520
  var valid_564521 = path.getOrDefault("subscriptionId")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "subscriptionId", valid_564521
  var valid_564522 = path.getOrDefault("resourceGroupName")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "resourceGroupName", valid_564522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564523 = query.getOrDefault("api-version")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564523 != nil:
    section.add "api-version", valid_564523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564524: Call_ScheduleGetResource_564516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_564524.validator(path, query, header, formData, body)
  let scheme = call_564524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564524.url(scheme.get, call_564524.host, call_564524.base,
                         call_564524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564524, url, valid)

proc call*(call_564525: Call_ScheduleGetResource_564516; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleGetResource
  ## Get schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564526 = newJObject()
  var query_564527 = newJObject()
  add(path_564526, "labName", newJString(labName))
  add(query_564527, "api-version", newJString(apiVersion))
  add(path_564526, "name", newJString(name))
  add(path_564526, "subscriptionId", newJString(subscriptionId))
  add(path_564526, "resourceGroupName", newJString(resourceGroupName))
  result = call_564525.call(path_564526, query_564527, nil, nil, nil)

var scheduleGetResource* = Call_ScheduleGetResource_564516(
    name: "scheduleGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleGetResource_564517, base: "",
    url: url_ScheduleGetResource_564518, schemes: {Scheme.Https})
type
  Call_SchedulePatchResource_564554 = ref object of OpenApiRestCall_563548
proc url_SchedulePatchResource_564556(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulePatchResource_564555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564557 = path.getOrDefault("labName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "labName", valid_564557
  var valid_564558 = path.getOrDefault("name")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "name", valid_564558
  var valid_564559 = path.getOrDefault("subscriptionId")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "subscriptionId", valid_564559
  var valid_564560 = path.getOrDefault("resourceGroupName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "resourceGroupName", valid_564560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564561 = query.getOrDefault("api-version")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564561 != nil:
    section.add "api-version", valid_564561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564563: Call_SchedulePatchResource_564554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_564563.validator(path, query, header, formData, body)
  let scheme = call_564563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564563.url(scheme.get, call_564563.host, call_564563.base,
                         call_564563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564563, url, valid)

proc call*(call_564564: Call_SchedulePatchResource_564554; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          schedule: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## schedulePatchResource
  ## Modify properties of schedules.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  var path_564565 = newJObject()
  var query_564566 = newJObject()
  var body_564567 = newJObject()
  add(path_564565, "labName", newJString(labName))
  add(query_564566, "api-version", newJString(apiVersion))
  add(path_564565, "name", newJString(name))
  add(path_564565, "subscriptionId", newJString(subscriptionId))
  add(path_564565, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_564567 = schedule
  result = call_564564.call(path_564565, query_564566, nil, nil, body_564567)

var schedulePatchResource* = Call_SchedulePatchResource_564554(
    name: "schedulePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulePatchResource_564555, base: "",
    url: url_SchedulePatchResource_564556, schemes: {Scheme.Https})
type
  Call_ScheduleDeleteResource_564542 = ref object of OpenApiRestCall_563548
proc url_ScheduleDeleteResource_564544(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleDeleteResource_564543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564545 = path.getOrDefault("labName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "labName", valid_564545
  var valid_564546 = path.getOrDefault("name")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "name", valid_564546
  var valid_564547 = path.getOrDefault("subscriptionId")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "subscriptionId", valid_564547
  var valid_564548 = path.getOrDefault("resourceGroupName")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "resourceGroupName", valid_564548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564549 = query.getOrDefault("api-version")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564549 != nil:
    section.add "api-version", valid_564549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564550: Call_ScheduleDeleteResource_564542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule. This operation can take a while to complete.
  ## 
  let valid = call_564550.validator(path, query, header, formData, body)
  let scheme = call_564550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564550.url(scheme.get, call_564550.host, call_564550.base,
                         call_564550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564550, url, valid)

proc call*(call_564551: Call_ScheduleDeleteResource_564542; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleDeleteResource
  ## Delete schedule. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564552 = newJObject()
  var query_564553 = newJObject()
  add(path_564552, "labName", newJString(labName))
  add(query_564553, "api-version", newJString(apiVersion))
  add(path_564552, "name", newJString(name))
  add(path_564552, "subscriptionId", newJString(subscriptionId))
  add(path_564552, "resourceGroupName", newJString(resourceGroupName))
  result = call_564551.call(path_564552, query_564553, nil, nil, nil)

var scheduleDeleteResource* = Call_ScheduleDeleteResource_564542(
    name: "scheduleDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleDeleteResource_564543, base: "",
    url: url_ScheduleDeleteResource_564544, schemes: {Scheme.Https})
type
  Call_ScheduleExecute_564568 = ref object of OpenApiRestCall_563548
proc url_ScheduleExecute_564570(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleExecute_564569(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564571 = path.getOrDefault("labName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "labName", valid_564571
  var valid_564572 = path.getOrDefault("name")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "name", valid_564572
  var valid_564573 = path.getOrDefault("subscriptionId")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "subscriptionId", valid_564573
  var valid_564574 = path.getOrDefault("resourceGroupName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "resourceGroupName", valid_564574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564575 = query.getOrDefault("api-version")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564575 != nil:
    section.add "api-version", valid_564575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564576: Call_ScheduleExecute_564568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_564576.validator(path, query, header, formData, body)
  let scheme = call_564576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564576.url(scheme.get, call_564576.host, call_564576.base,
                         call_564576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564576, url, valid)

proc call*(call_564577: Call_ScheduleExecute_564568; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564578 = newJObject()
  var query_564579 = newJObject()
  add(path_564578, "labName", newJString(labName))
  add(query_564579, "api-version", newJString(apiVersion))
  add(path_564578, "name", newJString(name))
  add(path_564578, "subscriptionId", newJString(subscriptionId))
  add(path_564578, "resourceGroupName", newJString(resourceGroupName))
  result = call_564577.call(path_564578, query_564579, nil, nil, nil)

var scheduleExecute* = Call_ScheduleExecute_564568(name: "scheduleExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_ScheduleExecute_564569, base: "", url: url_ScheduleExecute_564570,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineList_564580 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineList_564582(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineList_564581(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564583 = path.getOrDefault("labName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "labName", valid_564583
  var valid_564584 = path.getOrDefault("subscriptionId")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "subscriptionId", valid_564584
  var valid_564585 = path.getOrDefault("resourceGroupName")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "resourceGroupName", valid_564585
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564586 = query.getOrDefault("$top")
  valid_564586 = validateParameter(valid_564586, JInt, required = false, default = nil)
  if valid_564586 != nil:
    section.add "$top", valid_564586
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564587 = query.getOrDefault("api-version")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564587 != nil:
    section.add "api-version", valid_564587
  var valid_564588 = query.getOrDefault("$filter")
  valid_564588 = validateParameter(valid_564588, JString, required = false,
                                 default = nil)
  if valid_564588 != nil:
    section.add "$filter", valid_564588
  var valid_564589 = query.getOrDefault("$orderBy")
  valid_564589 = validateParameter(valid_564589, JString, required = false,
                                 default = nil)
  if valid_564589 != nil:
    section.add "$orderBy", valid_564589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564590: Call_VirtualMachineList_564580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines.
  ## 
  let valid = call_564590.validator(path, query, header, formData, body)
  let scheme = call_564590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564590.url(scheme.get, call_564590.host, call_564590.base,
                         call_564590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564590, url, valid)

proc call*(call_564591: Call_VirtualMachineList_564580; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## virtualMachineList
  ## List virtual machines.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564592 = newJObject()
  var query_564593 = newJObject()
  add(path_564592, "labName", newJString(labName))
  add(query_564593, "$top", newJInt(Top))
  add(query_564593, "api-version", newJString(apiVersion))
  add(path_564592, "subscriptionId", newJString(subscriptionId))
  add(path_564592, "resourceGroupName", newJString(resourceGroupName))
  add(query_564593, "$filter", newJString(Filter))
  add(query_564593, "$orderBy", newJString(OrderBy))
  result = call_564591.call(path_564592, query_564593, nil, nil, nil)

var virtualMachineList* = Call_VirtualMachineList_564580(
    name: "virtualMachineList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachineList_564581, base: "",
    url: url_VirtualMachineList_564582, schemes: {Scheme.Https})
type
  Call_VirtualMachineCreateOrUpdateResource_564606 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineCreateOrUpdateResource_564608(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineCreateOrUpdateResource_564607(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564609 = path.getOrDefault("labName")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "labName", valid_564609
  var valid_564610 = path.getOrDefault("name")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "name", valid_564610
  var valid_564611 = path.getOrDefault("subscriptionId")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "subscriptionId", valid_564611
  var valid_564612 = path.getOrDefault("resourceGroupName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "resourceGroupName", valid_564612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564613 = query.getOrDefault("api-version")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564613 != nil:
    section.add "api-version", valid_564613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564615: Call_VirtualMachineCreateOrUpdateResource_564606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ## 
  let valid = call_564615.validator(path, query, header, formData, body)
  let scheme = call_564615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564615.url(scheme.get, call_564615.host, call_564615.base,
                         call_564615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564615, url, valid)

proc call*(call_564616: Call_VirtualMachineCreateOrUpdateResource_564606;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineCreateOrUpdateResource
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labVirtualMachine: JObject (required)
  var path_564617 = newJObject()
  var query_564618 = newJObject()
  var body_564619 = newJObject()
  add(path_564617, "labName", newJString(labName))
  add(query_564618, "api-version", newJString(apiVersion))
  add(path_564617, "name", newJString(name))
  add(path_564617, "subscriptionId", newJString(subscriptionId))
  add(path_564617, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_564619 = labVirtualMachine
  result = call_564616.call(path_564617, query_564618, nil, nil, body_564619)

var virtualMachineCreateOrUpdateResource* = Call_VirtualMachineCreateOrUpdateResource_564606(
    name: "virtualMachineCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineCreateOrUpdateResource_564607, base: "",
    url: url_VirtualMachineCreateOrUpdateResource_564608, schemes: {Scheme.Https})
type
  Call_VirtualMachineGetResource_564594 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineGetResource_564596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineGetResource_564595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564597 = path.getOrDefault("labName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "labName", valid_564597
  var valid_564598 = path.getOrDefault("name")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "name", valid_564598
  var valid_564599 = path.getOrDefault("subscriptionId")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "subscriptionId", valid_564599
  var valid_564600 = path.getOrDefault("resourceGroupName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "resourceGroupName", valid_564600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564601 = query.getOrDefault("api-version")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564601 != nil:
    section.add "api-version", valid_564601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564602: Call_VirtualMachineGetResource_564594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_VirtualMachineGetResource_564594; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineGetResource
  ## Get virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564604 = newJObject()
  var query_564605 = newJObject()
  add(path_564604, "labName", newJString(labName))
  add(query_564605, "api-version", newJString(apiVersion))
  add(path_564604, "name", newJString(name))
  add(path_564604, "subscriptionId", newJString(subscriptionId))
  add(path_564604, "resourceGroupName", newJString(resourceGroupName))
  result = call_564603.call(path_564604, query_564605, nil, nil, nil)

var virtualMachineGetResource* = Call_VirtualMachineGetResource_564594(
    name: "virtualMachineGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineGetResource_564595, base: "",
    url: url_VirtualMachineGetResource_564596, schemes: {Scheme.Https})
type
  Call_VirtualMachinePatchResource_564632 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinePatchResource_564634(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinePatchResource_564633(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564635 = path.getOrDefault("labName")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "labName", valid_564635
  var valid_564636 = path.getOrDefault("name")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "name", valid_564636
  var valid_564637 = path.getOrDefault("subscriptionId")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "subscriptionId", valid_564637
  var valid_564638 = path.getOrDefault("resourceGroupName")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "resourceGroupName", valid_564638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564639 = query.getOrDefault("api-version")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564639 != nil:
    section.add "api-version", valid_564639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564641: Call_VirtualMachinePatchResource_564632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual machines.
  ## 
  let valid = call_564641.validator(path, query, header, formData, body)
  let scheme = call_564641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564641.url(scheme.get, call_564641.host, call_564641.base,
                         call_564641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564641, url, valid)

proc call*(call_564642: Call_VirtualMachinePatchResource_564632; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachinePatchResource
  ## Modify properties of virtual machines.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labVirtualMachine: JObject (required)
  var path_564643 = newJObject()
  var query_564644 = newJObject()
  var body_564645 = newJObject()
  add(path_564643, "labName", newJString(labName))
  add(query_564644, "api-version", newJString(apiVersion))
  add(path_564643, "name", newJString(name))
  add(path_564643, "subscriptionId", newJString(subscriptionId))
  add(path_564643, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_564645 = labVirtualMachine
  result = call_564642.call(path_564643, query_564644, nil, nil, body_564645)

var virtualMachinePatchResource* = Call_VirtualMachinePatchResource_564632(
    name: "virtualMachinePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinePatchResource_564633, base: "",
    url: url_VirtualMachinePatchResource_564634, schemes: {Scheme.Https})
type
  Call_VirtualMachineDeleteResource_564620 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineDeleteResource_564622(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineDeleteResource_564621(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564623 = path.getOrDefault("labName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "labName", valid_564623
  var valid_564624 = path.getOrDefault("name")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "name", valid_564624
  var valid_564625 = path.getOrDefault("subscriptionId")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "subscriptionId", valid_564625
  var valid_564626 = path.getOrDefault("resourceGroupName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "resourceGroupName", valid_564626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564627 = query.getOrDefault("api-version")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564627 != nil:
    section.add "api-version", valid_564627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564628: Call_VirtualMachineDeleteResource_564620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_564628.validator(path, query, header, formData, body)
  let scheme = call_564628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564628.url(scheme.get, call_564628.host, call_564628.base,
                         call_564628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564628, url, valid)

proc call*(call_564629: Call_VirtualMachineDeleteResource_564620; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineDeleteResource
  ## Delete virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564630 = newJObject()
  var query_564631 = newJObject()
  add(path_564630, "labName", newJString(labName))
  add(query_564631, "api-version", newJString(apiVersion))
  add(path_564630, "name", newJString(name))
  add(path_564630, "subscriptionId", newJString(subscriptionId))
  add(path_564630, "resourceGroupName", newJString(resourceGroupName))
  result = call_564629.call(path_564630, query_564631, nil, nil, nil)

var virtualMachineDeleteResource* = Call_VirtualMachineDeleteResource_564620(
    name: "virtualMachineDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineDeleteResource_564621, base: "",
    url: url_VirtualMachineDeleteResource_564622, schemes: {Scheme.Https})
type
  Call_VirtualMachineApplyArtifacts_564646 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineApplyArtifacts_564648(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/applyArtifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineApplyArtifacts_564647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564649 = path.getOrDefault("labName")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "labName", valid_564649
  var valid_564650 = path.getOrDefault("name")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "name", valid_564650
  var valid_564651 = path.getOrDefault("subscriptionId")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "subscriptionId", valid_564651
  var valid_564652 = path.getOrDefault("resourceGroupName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "resourceGroupName", valid_564652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564653 = query.getOrDefault("api-version")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564653 != nil:
    section.add "api-version", valid_564653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applyArtifactsRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564655: Call_VirtualMachineApplyArtifacts_564646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_564655.validator(path, query, header, formData, body)
  let scheme = call_564655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564655.url(scheme.get, call_564655.host, call_564655.base,
                         call_564655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564655, url, valid)

proc call*(call_564656: Call_VirtualMachineApplyArtifacts_564646; labName: string;
          applyArtifactsRequest: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineApplyArtifacts
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   applyArtifactsRequest: JObject (required)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564657 = newJObject()
  var query_564658 = newJObject()
  var body_564659 = newJObject()
  add(path_564657, "labName", newJString(labName))
  if applyArtifactsRequest != nil:
    body_564659 = applyArtifactsRequest
  add(query_564658, "api-version", newJString(apiVersion))
  add(path_564657, "name", newJString(name))
  add(path_564657, "subscriptionId", newJString(subscriptionId))
  add(path_564657, "resourceGroupName", newJString(resourceGroupName))
  result = call_564656.call(path_564657, query_564658, nil, nil, body_564659)

var virtualMachineApplyArtifacts* = Call_VirtualMachineApplyArtifacts_564646(
    name: "virtualMachineApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachineApplyArtifacts_564647, base: "",
    url: url_VirtualMachineApplyArtifacts_564648, schemes: {Scheme.Https})
type
  Call_VirtualMachineStart_564660 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineStart_564662(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineStart_564661(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Start a Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564663 = path.getOrDefault("labName")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "labName", valid_564663
  var valid_564664 = path.getOrDefault("name")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "name", valid_564664
  var valid_564665 = path.getOrDefault("subscriptionId")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "subscriptionId", valid_564665
  var valid_564666 = path.getOrDefault("resourceGroupName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "resourceGroupName", valid_564666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564667 = query.getOrDefault("api-version")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564667 != nil:
    section.add "api-version", valid_564667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564668: Call_VirtualMachineStart_564660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_564668.validator(path, query, header, formData, body)
  let scheme = call_564668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564668.url(scheme.get, call_564668.host, call_564668.base,
                         call_564668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564668, url, valid)

proc call*(call_564669: Call_VirtualMachineStart_564660; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineStart
  ## Start a Lab VM. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564670 = newJObject()
  var query_564671 = newJObject()
  add(path_564670, "labName", newJString(labName))
  add(query_564671, "api-version", newJString(apiVersion))
  add(path_564670, "name", newJString(name))
  add(path_564670, "subscriptionId", newJString(subscriptionId))
  add(path_564670, "resourceGroupName", newJString(resourceGroupName))
  result = call_564669.call(path_564670, query_564671, nil, nil, nil)

var virtualMachineStart* = Call_VirtualMachineStart_564660(
    name: "virtualMachineStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachineStart_564661, base: "",
    url: url_VirtualMachineStart_564662, schemes: {Scheme.Https})
type
  Call_VirtualMachineStop_564672 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineStop_564674(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineStop_564673(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stop a Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564675 = path.getOrDefault("labName")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = nil)
  if valid_564675 != nil:
    section.add "labName", valid_564675
  var valid_564676 = path.getOrDefault("name")
  valid_564676 = validateParameter(valid_564676, JString, required = true,
                                 default = nil)
  if valid_564676 != nil:
    section.add "name", valid_564676
  var valid_564677 = path.getOrDefault("subscriptionId")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "subscriptionId", valid_564677
  var valid_564678 = path.getOrDefault("resourceGroupName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "resourceGroupName", valid_564678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564679 = query.getOrDefault("api-version")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564679 != nil:
    section.add "api-version", valid_564679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564680: Call_VirtualMachineStop_564672; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_564680.validator(path, query, header, formData, body)
  let scheme = call_564680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564680.url(scheme.get, call_564680.host, call_564680.base,
                         call_564680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564680, url, valid)

proc call*(call_564681: Call_VirtualMachineStop_564672; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineStop
  ## Stop a Lab VM. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564682 = newJObject()
  var query_564683 = newJObject()
  add(path_564682, "labName", newJString(labName))
  add(query_564683, "api-version", newJString(apiVersion))
  add(path_564682, "name", newJString(name))
  add(path_564682, "subscriptionId", newJString(subscriptionId))
  add(path_564682, "resourceGroupName", newJString(resourceGroupName))
  result = call_564681.call(path_564682, query_564683, nil, nil, nil)

var virtualMachineStop* = Call_VirtualMachineStop_564672(
    name: "virtualMachineStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachineStop_564673, base: "",
    url: url_VirtualMachineStop_564674, schemes: {Scheme.Https})
type
  Call_VirtualNetworkList_564684 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworkList_564686(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkList_564685(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564687 = path.getOrDefault("labName")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "labName", valid_564687
  var valid_564688 = path.getOrDefault("subscriptionId")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "subscriptionId", valid_564688
  var valid_564689 = path.getOrDefault("resourceGroupName")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "resourceGroupName", valid_564689
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  ##   $orderBy: JString
  section = newJObject()
  var valid_564690 = query.getOrDefault("$top")
  valid_564690 = validateParameter(valid_564690, JInt, required = false, default = nil)
  if valid_564690 != nil:
    section.add "$top", valid_564690
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564691 = query.getOrDefault("api-version")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564691 != nil:
    section.add "api-version", valid_564691
  var valid_564692 = query.getOrDefault("$filter")
  valid_564692 = validateParameter(valid_564692, JString, required = false,
                                 default = nil)
  if valid_564692 != nil:
    section.add "$filter", valid_564692
  var valid_564693 = query.getOrDefault("$orderBy")
  valid_564693 = validateParameter(valid_564693, JString, required = false,
                                 default = nil)
  if valid_564693 != nil:
    section.add "$orderBy", valid_564693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564694: Call_VirtualNetworkList_564684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks.
  ## 
  let valid = call_564694.validator(path, query, header, formData, body)
  let scheme = call_564694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564694.url(scheme.get, call_564694.host, call_564694.base,
                         call_564694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564694, url, valid)

proc call*(call_564695: Call_VirtualNetworkList_564684; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2015-05-21-preview"; Filter: string = "";
          OrderBy: string = ""): Recallable =
  ## virtualNetworkList
  ## List virtual networks.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   OrderBy: string
  var path_564696 = newJObject()
  var query_564697 = newJObject()
  add(path_564696, "labName", newJString(labName))
  add(query_564697, "$top", newJInt(Top))
  add(query_564697, "api-version", newJString(apiVersion))
  add(path_564696, "subscriptionId", newJString(subscriptionId))
  add(path_564696, "resourceGroupName", newJString(resourceGroupName))
  add(query_564697, "$filter", newJString(Filter))
  add(query_564697, "$orderBy", newJString(OrderBy))
  result = call_564695.call(path_564696, query_564697, nil, nil, nil)

var virtualNetworkList* = Call_VirtualNetworkList_564684(
    name: "virtualNetworkList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworkList_564685, base: "",
    url: url_VirtualNetworkList_564686, schemes: {Scheme.Https})
type
  Call_VirtualNetworkCreateOrUpdateResource_564710 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworkCreateOrUpdateResource_564712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkCreateOrUpdateResource_564711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564713 = path.getOrDefault("labName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "labName", valid_564713
  var valid_564714 = path.getOrDefault("name")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "name", valid_564714
  var valid_564715 = path.getOrDefault("subscriptionId")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "subscriptionId", valid_564715
  var valid_564716 = path.getOrDefault("resourceGroupName")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "resourceGroupName", valid_564716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564717 = query.getOrDefault("api-version")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564717 != nil:
    section.add "api-version", valid_564717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564719: Call_VirtualNetworkCreateOrUpdateResource_564710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_564719.validator(path, query, header, formData, body)
  let scheme = call_564719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564719.url(scheme.get, call_564719.host, call_564719.base,
                         call_564719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564719, url, valid)

proc call*(call_564720: Call_VirtualNetworkCreateOrUpdateResource_564710;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkCreateOrUpdateResource
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetwork: JObject (required)
  var path_564721 = newJObject()
  var query_564722 = newJObject()
  var body_564723 = newJObject()
  add(path_564721, "labName", newJString(labName))
  add(query_564722, "api-version", newJString(apiVersion))
  add(path_564721, "name", newJString(name))
  add(path_564721, "subscriptionId", newJString(subscriptionId))
  add(path_564721, "resourceGroupName", newJString(resourceGroupName))
  if virtualNetwork != nil:
    body_564723 = virtualNetwork
  result = call_564720.call(path_564721, query_564722, nil, nil, body_564723)

var virtualNetworkCreateOrUpdateResource* = Call_VirtualNetworkCreateOrUpdateResource_564710(
    name: "virtualNetworkCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkCreateOrUpdateResource_564711, base: "",
    url: url_VirtualNetworkCreateOrUpdateResource_564712, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGetResource_564698 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworkGetResource_564700(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGetResource_564699(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564701 = path.getOrDefault("labName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "labName", valid_564701
  var valid_564702 = path.getOrDefault("name")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "name", valid_564702
  var valid_564703 = path.getOrDefault("subscriptionId")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "subscriptionId", valid_564703
  var valid_564704 = path.getOrDefault("resourceGroupName")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "resourceGroupName", valid_564704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564705 = query.getOrDefault("api-version")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564705 != nil:
    section.add "api-version", valid_564705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564706: Call_VirtualNetworkGetResource_564698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_564706.validator(path, query, header, formData, body)
  let scheme = call_564706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564706.url(scheme.get, call_564706.host, call_564706.base,
                         call_564706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564706, url, valid)

proc call*(call_564707: Call_VirtualNetworkGetResource_564698; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkGetResource
  ## Get virtual network.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564708 = newJObject()
  var query_564709 = newJObject()
  add(path_564708, "labName", newJString(labName))
  add(query_564709, "api-version", newJString(apiVersion))
  add(path_564708, "name", newJString(name))
  add(path_564708, "subscriptionId", newJString(subscriptionId))
  add(path_564708, "resourceGroupName", newJString(resourceGroupName))
  result = call_564707.call(path_564708, query_564709, nil, nil, nil)

var virtualNetworkGetResource* = Call_VirtualNetworkGetResource_564698(
    name: "virtualNetworkGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkGetResource_564699, base: "",
    url: url_VirtualNetworkGetResource_564700, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPatchResource_564736 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworkPatchResource_564738(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPatchResource_564737(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564739 = path.getOrDefault("labName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "labName", valid_564739
  var valid_564740 = path.getOrDefault("name")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "name", valid_564740
  var valid_564741 = path.getOrDefault("subscriptionId")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "subscriptionId", valid_564741
  var valid_564742 = path.getOrDefault("resourceGroupName")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "resourceGroupName", valid_564742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564743 = query.getOrDefault("api-version")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564743 != nil:
    section.add "api-version", valid_564743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564745: Call_VirtualNetworkPatchResource_564736; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual networks.
  ## 
  let valid = call_564745.validator(path, query, header, formData, body)
  let scheme = call_564745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564745.url(scheme.get, call_564745.host, call_564745.base,
                         call_564745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564745, url, valid)

proc call*(call_564746: Call_VirtualNetworkPatchResource_564736; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          virtualNetwork: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkPatchResource
  ## Modify properties of virtual networks.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetwork: JObject (required)
  var path_564747 = newJObject()
  var query_564748 = newJObject()
  var body_564749 = newJObject()
  add(path_564747, "labName", newJString(labName))
  add(query_564748, "api-version", newJString(apiVersion))
  add(path_564747, "name", newJString(name))
  add(path_564747, "subscriptionId", newJString(subscriptionId))
  add(path_564747, "resourceGroupName", newJString(resourceGroupName))
  if virtualNetwork != nil:
    body_564749 = virtualNetwork
  result = call_564746.call(path_564747, query_564748, nil, nil, body_564749)

var virtualNetworkPatchResource* = Call_VirtualNetworkPatchResource_564736(
    name: "virtualNetworkPatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkPatchResource_564737, base: "",
    url: url_VirtualNetworkPatchResource_564738, schemes: {Scheme.Https})
type
  Call_VirtualNetworkDeleteResource_564724 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworkDeleteResource_564726(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkDeleteResource_564725(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564727 = path.getOrDefault("labName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "labName", valid_564727
  var valid_564728 = path.getOrDefault("name")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "name", valid_564728
  var valid_564729 = path.getOrDefault("subscriptionId")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "subscriptionId", valid_564729
  var valid_564730 = path.getOrDefault("resourceGroupName")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "resourceGroupName", valid_564730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564731 = query.getOrDefault("api-version")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564731 != nil:
    section.add "api-version", valid_564731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564732: Call_VirtualNetworkDeleteResource_564724; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_VirtualNetworkDeleteResource_564724; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkDeleteResource
  ## Delete virtual network. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564734 = newJObject()
  var query_564735 = newJObject()
  add(path_564734, "labName", newJString(labName))
  add(query_564735, "api-version", newJString(apiVersion))
  add(path_564734, "name", newJString(name))
  add(path_564734, "subscriptionId", newJString(subscriptionId))
  add(path_564734, "resourceGroupName", newJString(resourceGroupName))
  result = call_564733.call(path_564734, query_564735, nil, nil, nil)

var virtualNetworkDeleteResource* = Call_VirtualNetworkDeleteResource_564724(
    name: "virtualNetworkDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkDeleteResource_564725, base: "",
    url: url_VirtualNetworkDeleteResource_564726, schemes: {Scheme.Https})
type
  Call_LabCreateOrUpdateResource_564761 = ref object of OpenApiRestCall_563548
proc url_LabCreateOrUpdateResource_564763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabCreateOrUpdateResource_564762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564764 = path.getOrDefault("name")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "name", valid_564764
  var valid_564765 = path.getOrDefault("subscriptionId")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "subscriptionId", valid_564765
  var valid_564766 = path.getOrDefault("resourceGroupName")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "resourceGroupName", valid_564766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564767 = query.getOrDefault("api-version")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564767 != nil:
    section.add "api-version", valid_564767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564769: Call_LabCreateOrUpdateResource_564761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ## 
  let valid = call_564769.validator(path, query, header, formData, body)
  let scheme = call_564769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564769.url(scheme.get, call_564769.host, call_564769.base,
                         call_564769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564769, url, valid)

proc call*(call_564770: Call_LabCreateOrUpdateResource_564761; lab: JsonNode;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labCreateOrUpdateResource
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ##   lab: JObject (required)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564771 = newJObject()
  var query_564772 = newJObject()
  var body_564773 = newJObject()
  if lab != nil:
    body_564773 = lab
  add(query_564772, "api-version", newJString(apiVersion))
  add(path_564771, "name", newJString(name))
  add(path_564771, "subscriptionId", newJString(subscriptionId))
  add(path_564771, "resourceGroupName", newJString(resourceGroupName))
  result = call_564770.call(path_564771, query_564772, nil, nil, body_564773)

var labCreateOrUpdateResource* = Call_LabCreateOrUpdateResource_564761(
    name: "labCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabCreateOrUpdateResource_564762, base: "",
    url: url_LabCreateOrUpdateResource_564763, schemes: {Scheme.Https})
type
  Call_LabGetResource_564750 = ref object of OpenApiRestCall_563548
proc url_LabGetResource_564752(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabGetResource_564751(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564753 = path.getOrDefault("name")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "name", valid_564753
  var valid_564754 = path.getOrDefault("subscriptionId")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "subscriptionId", valid_564754
  var valid_564755 = path.getOrDefault("resourceGroupName")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "resourceGroupName", valid_564755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564756 = query.getOrDefault("api-version")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564756 != nil:
    section.add "api-version", valid_564756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564757: Call_LabGetResource_564750; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_564757.validator(path, query, header, formData, body)
  let scheme = call_564757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564757.url(scheme.get, call_564757.host, call_564757.base,
                         call_564757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564757, url, valid)

proc call*(call_564758: Call_LabGetResource_564750; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labGetResource
  ## Get lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564759 = newJObject()
  var query_564760 = newJObject()
  add(query_564760, "api-version", newJString(apiVersion))
  add(path_564759, "name", newJString(name))
  add(path_564759, "subscriptionId", newJString(subscriptionId))
  add(path_564759, "resourceGroupName", newJString(resourceGroupName))
  result = call_564758.call(path_564759, query_564760, nil, nil, nil)

var labGetResource* = Call_LabGetResource_564750(name: "labGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabGetResource_564751, base: "", url: url_LabGetResource_564752,
    schemes: {Scheme.Https})
type
  Call_LabPatchResource_564785 = ref object of OpenApiRestCall_563548
proc url_LabPatchResource_564787(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabPatchResource_564786(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564788 = path.getOrDefault("name")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "name", valid_564788
  var valid_564789 = path.getOrDefault("subscriptionId")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "subscriptionId", valid_564789
  var valid_564790 = path.getOrDefault("resourceGroupName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "resourceGroupName", valid_564790
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564791 = query.getOrDefault("api-version")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564791 != nil:
    section.add "api-version", valid_564791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564793: Call_LabPatchResource_564785; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_564793.validator(path, query, header, formData, body)
  let scheme = call_564793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564793.url(scheme.get, call_564793.host, call_564793.base,
                         call_564793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564793, url, valid)

proc call*(call_564794: Call_LabPatchResource_564785; lab: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labPatchResource
  ## Modify properties of labs.
  ##   lab: JObject (required)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564795 = newJObject()
  var query_564796 = newJObject()
  var body_564797 = newJObject()
  if lab != nil:
    body_564797 = lab
  add(query_564796, "api-version", newJString(apiVersion))
  add(path_564795, "name", newJString(name))
  add(path_564795, "subscriptionId", newJString(subscriptionId))
  add(path_564795, "resourceGroupName", newJString(resourceGroupName))
  result = call_564794.call(path_564795, query_564796, nil, nil, body_564797)

var labPatchResource* = Call_LabPatchResource_564785(name: "labPatchResource",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabPatchResource_564786, base: "",
    url: url_LabPatchResource_564787, schemes: {Scheme.Https})
type
  Call_LabDeleteResource_564774 = ref object of OpenApiRestCall_563548
proc url_LabDeleteResource_564776(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabDeleteResource_564775(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564777 = path.getOrDefault("name")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "name", valid_564777
  var valid_564778 = path.getOrDefault("subscriptionId")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "subscriptionId", valid_564778
  var valid_564779 = path.getOrDefault("resourceGroupName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "resourceGroupName", valid_564779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564780 = query.getOrDefault("api-version")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564780 != nil:
    section.add "api-version", valid_564780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564781: Call_LabDeleteResource_564774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_564781.validator(path, query, header, formData, body)
  let scheme = call_564781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564781.url(scheme.get, call_564781.host, call_564781.base,
                         call_564781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564781, url, valid)

proc call*(call_564782: Call_LabDeleteResource_564774; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labDeleteResource
  ## Delete lab. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564783 = newJObject()
  var query_564784 = newJObject()
  add(query_564784, "api-version", newJString(apiVersion))
  add(path_564783, "name", newJString(name))
  add(path_564783, "subscriptionId", newJString(subscriptionId))
  add(path_564783, "resourceGroupName", newJString(resourceGroupName))
  result = call_564782.call(path_564783, query_564784, nil, nil, nil)

var labDeleteResource* = Call_LabDeleteResource_564774(name: "labDeleteResource",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabDeleteResource_564775, base: "",
    url: url_LabDeleteResource_564776, schemes: {Scheme.Https})
type
  Call_LabCreateEnvironment_564798 = ref object of OpenApiRestCall_563548
proc url_LabCreateEnvironment_564800(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/createEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabCreateEnvironment_564799(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564801 = path.getOrDefault("name")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "name", valid_564801
  var valid_564802 = path.getOrDefault("subscriptionId")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "subscriptionId", valid_564802
  var valid_564803 = path.getOrDefault("resourceGroupName")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "resourceGroupName", valid_564803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564804 = query.getOrDefault("api-version")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564804 != nil:
    section.add "api-version", valid_564804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564806: Call_LabCreateEnvironment_564798; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ## 
  let valid = call_564806.validator(path, query, header, formData, body)
  let scheme = call_564806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564806.url(scheme.get, call_564806.host, call_564806.base,
                         call_564806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564806, url, valid)

proc call*(call_564807: Call_LabCreateEnvironment_564798; name: string;
          subscriptionId: string; resourceGroupName: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labCreateEnvironment
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labVirtualMachine: JObject (required)
  var path_564808 = newJObject()
  var query_564809 = newJObject()
  var body_564810 = newJObject()
  add(query_564809, "api-version", newJString(apiVersion))
  add(path_564808, "name", newJString(name))
  add(path_564808, "subscriptionId", newJString(subscriptionId))
  add(path_564808, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_564810 = labVirtualMachine
  result = call_564807.call(path_564808, query_564809, nil, nil, body_564810)

var labCreateEnvironment* = Call_LabCreateEnvironment_564798(
    name: "labCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabCreateEnvironment_564799, base: "",
    url: url_LabCreateEnvironment_564800, schemes: {Scheme.Https})
type
  Call_LabGenerateUploadUri_564811 = ref object of OpenApiRestCall_563548
proc url_LabGenerateUploadUri_564813(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateUploadUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabGenerateUploadUri_564812(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564814 = path.getOrDefault("name")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "name", valid_564814
  var valid_564815 = path.getOrDefault("subscriptionId")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "subscriptionId", valid_564815
  var valid_564816 = path.getOrDefault("resourceGroupName")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "resourceGroupName", valid_564816
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564817 = query.getOrDefault("api-version")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564817 != nil:
    section.add "api-version", valid_564817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateUploadUriParameter: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564819: Call_LabGenerateUploadUri_564811; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_564819.validator(path, query, header, formData, body)
  let scheme = call_564819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564819.url(scheme.get, call_564819.host, call_564819.base,
                         call_564819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564819, url, valid)

proc call*(call_564820: Call_LabGenerateUploadUri_564811; name: string;
          subscriptionId: string; resourceGroupName: string;
          generateUploadUriParameter: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labGenerateUploadUri
  ## Generate a URI for uploading custom disk images to a Lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   generateUploadUriParameter: JObject (required)
  var path_564821 = newJObject()
  var query_564822 = newJObject()
  var body_564823 = newJObject()
  add(query_564822, "api-version", newJString(apiVersion))
  add(path_564821, "name", newJString(name))
  add(path_564821, "subscriptionId", newJString(subscriptionId))
  add(path_564821, "resourceGroupName", newJString(resourceGroupName))
  if generateUploadUriParameter != nil:
    body_564823 = generateUploadUriParameter
  result = call_564820.call(path_564821, query_564822, nil, nil, body_564823)

var labGenerateUploadUri* = Call_LabGenerateUploadUri_564811(
    name: "labGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabGenerateUploadUri_564812, base: "",
    url: url_LabGenerateUploadUri_564813, schemes: {Scheme.Https})
type
  Call_LabListVhds_564824 = ref object of OpenApiRestCall_563548
proc url_LabListVhds_564826(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listVhds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabListVhds_564825(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List disk images available for custom image creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564827 = path.getOrDefault("name")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "name", valid_564827
  var valid_564828 = path.getOrDefault("subscriptionId")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "subscriptionId", valid_564828
  var valid_564829 = path.getOrDefault("resourceGroupName")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "resourceGroupName", valid_564829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564830 = query.getOrDefault("api-version")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_564830 != nil:
    section.add "api-version", valid_564830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564831: Call_LabListVhds_564824; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_564831.validator(path, query, header, formData, body)
  let scheme = call_564831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564831.url(scheme.get, call_564831.host, call_564831.base,
                         call_564831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564831, url, valid)

proc call*(call_564832: Call_LabListVhds_564824; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labListVhds
  ## List disk images available for custom image creation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564833 = newJObject()
  var query_564834 = newJObject()
  add(query_564834, "api-version", newJString(apiVersion))
  add(path_564833, "name", newJString(name))
  add(path_564833, "subscriptionId", newJString(subscriptionId))
  add(path_564833, "resourceGroupName", newJString(resourceGroupName))
  result = call_564832.call(path_564833, query_564834, nil, nil, nil)

var labListVhds* = Call_LabListVhds_564824(name: "labListVhds",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
                                        validator: validate_LabListVhds_564825,
                                        base: "", url: url_LabListVhds_564826,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
