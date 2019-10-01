
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567650 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567650](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567650): Option[Scheme] {.used.} =
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
  macServiceName = "devtestlabs-DTL"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LabListBySubscription_567872 = ref object of OpenApiRestCall_567650
proc url_LabListBySubscription_567874(protocol: Scheme; host: string; base: string;
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

proc validate_LabListBySubscription_567873(path: JsonNode; query: JsonNode;
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
  var valid_568048 = path.getOrDefault("subscriptionId")
  valid_568048 = validateParameter(valid_568048, JString, required = true,
                                 default = nil)
  if valid_568048 != nil:
    section.add "subscriptionId", valid_568048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568062 = query.getOrDefault("api-version")
  valid_568062 = validateParameter(valid_568062, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568062 != nil:
    section.add "api-version", valid_568062
  var valid_568063 = query.getOrDefault("$top")
  valid_568063 = validateParameter(valid_568063, JInt, required = false, default = nil)
  if valid_568063 != nil:
    section.add "$top", valid_568063
  var valid_568064 = query.getOrDefault("$orderBy")
  valid_568064 = validateParameter(valid_568064, JString, required = false,
                                 default = nil)
  if valid_568064 != nil:
    section.add "$orderBy", valid_568064
  var valid_568065 = query.getOrDefault("$filter")
  valid_568065 = validateParameter(valid_568065, JString, required = false,
                                 default = nil)
  if valid_568065 != nil:
    section.add "$filter", valid_568065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568088: Call_LabListBySubscription_567872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs.
  ## 
  let valid = call_568088.validator(path, query, header, formData, body)
  let scheme = call_568088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568088.url(scheme.get, call_568088.host, call_568088.base,
                         call_568088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568088, url, valid)

proc call*(call_568159: Call_LabListBySubscription_567872; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## labListBySubscription
  ## List labs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568160 = newJObject()
  var query_568162 = newJObject()
  add(query_568162, "api-version", newJString(apiVersion))
  add(path_568160, "subscriptionId", newJString(subscriptionId))
  add(query_568162, "$top", newJInt(Top))
  add(query_568162, "$orderBy", newJString(OrderBy))
  add(query_568162, "$filter", newJString(Filter))
  result = call_568159.call(path_568160, query_568162, nil, nil, nil)

var labListBySubscription* = Call_LabListBySubscription_567872(
    name: "labListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabListBySubscription_567873, base: "",
    url: url_LabListBySubscription_567874, schemes: {Scheme.Https})
type
  Call_LabListByResourceGroup_568201 = ref object of OpenApiRestCall_567650
proc url_LabListByResourceGroup_568203(protocol: Scheme; host: string; base: string;
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

proc validate_LabListByResourceGroup_568202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568204 = path.getOrDefault("resourceGroupName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "resourceGroupName", valid_568204
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  var valid_568207 = query.getOrDefault("$top")
  valid_568207 = validateParameter(valid_568207, JInt, required = false, default = nil)
  if valid_568207 != nil:
    section.add "$top", valid_568207
  var valid_568208 = query.getOrDefault("$orderBy")
  valid_568208 = validateParameter(valid_568208, JString, required = false,
                                 default = nil)
  if valid_568208 != nil:
    section.add "$orderBy", valid_568208
  var valid_568209 = query.getOrDefault("$filter")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "$filter", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_LabListByResourceGroup_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_LabListByResourceGroup_568201;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## labListByResourceGroup
  ## List labs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(query_568213, "$top", newJInt(Top))
  add(query_568213, "$orderBy", newJString(OrderBy))
  add(query_568213, "$filter", newJString(Filter))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var labListByResourceGroup* = Call_LabListByResourceGroup_568201(
    name: "labListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabListByResourceGroup_568202, base: "",
    url: url_LabListByResourceGroup_568203, schemes: {Scheme.Https})
type
  Call_ArtifactSourceList_568214 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourceList_568216(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourceList_568215(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  var valid_568219 = path.getOrDefault("labName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "labName", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  var valid_568221 = query.getOrDefault("$top")
  valid_568221 = validateParameter(valid_568221, JInt, required = false, default = nil)
  if valid_568221 != nil:
    section.add "$top", valid_568221
  var valid_568222 = query.getOrDefault("$orderBy")
  valid_568222 = validateParameter(valid_568222, JString, required = false,
                                 default = nil)
  if valid_568222 != nil:
    section.add "$orderBy", valid_568222
  var valid_568223 = query.getOrDefault("$filter")
  valid_568223 = validateParameter(valid_568223, JString, required = false,
                                 default = nil)
  if valid_568223 != nil:
    section.add "$filter", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_ArtifactSourceList_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_ArtifactSourceList_568214; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## artifactSourceList
  ## List artifact sources.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  add(query_568227, "$top", newJInt(Top))
  add(query_568227, "$orderBy", newJString(OrderBy))
  add(path_568226, "labName", newJString(labName))
  add(query_568227, "$filter", newJString(Filter))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var artifactSourceList* = Call_ArtifactSourceList_568214(
    name: "artifactSourceList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourceList_568215, base: "",
    url: url_ArtifactSourceList_568216, schemes: {Scheme.Https})
type
  Call_ArtifactList_568228 = ref object of OpenApiRestCall_567650
proc url_ArtifactList_568230(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactList_568229(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("artifactSourceName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "artifactSourceName", valid_568233
  var valid_568234 = path.getOrDefault("labName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "labName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  var valid_568236 = query.getOrDefault("$top")
  valid_568236 = validateParameter(valid_568236, JInt, required = false, default = nil)
  if valid_568236 != nil:
    section.add "$top", valid_568236
  var valid_568237 = query.getOrDefault("$orderBy")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "$orderBy", valid_568237
  var valid_568238 = query.getOrDefault("$filter")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$filter", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ArtifactList_568228; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ArtifactList_568228; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## artifactList
  ## List artifacts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(query_568242, "$top", newJInt(Top))
  add(query_568242, "$orderBy", newJString(OrderBy))
  add(path_568241, "artifactSourceName", newJString(artifactSourceName))
  add(path_568241, "labName", newJString(labName))
  add(query_568242, "$filter", newJString(Filter))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var artifactList* = Call_ArtifactList_568228(name: "artifactList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactList_568229, base: "", url: url_ArtifactList_568230,
    schemes: {Scheme.Https})
type
  Call_ArtifactGetResource_568243 = ref object of OpenApiRestCall_567650
proc url_ArtifactGetResource_568245(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactGetResource_568244(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("name")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "name", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  var valid_568249 = path.getOrDefault("artifactSourceName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "artifactSourceName", valid_568249
  var valid_568250 = path.getOrDefault("labName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "labName", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_ArtifactGetResource_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_ArtifactGetResource_568243; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactGetResource
  ## Get artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "name", newJString(name))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  add(path_568254, "artifactSourceName", newJString(artifactSourceName))
  add(path_568254, "labName", newJString(labName))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var artifactGetResource* = Call_ArtifactGetResource_568243(
    name: "artifactGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactGetResource_568244, base: "",
    url: url_ArtifactGetResource_568245, schemes: {Scheme.Https})
type
  Call_ArtifactGenerateArmTemplate_568256 = ref object of OpenApiRestCall_567650
proc url_ArtifactGenerateArmTemplate_568258(protocol: Scheme; host: string;
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

proc validate_ArtifactGenerateArmTemplate_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("name")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "name", valid_568260
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  var valid_568262 = path.getOrDefault("artifactSourceName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "artifactSourceName", valid_568262
  var valid_568263 = path.getOrDefault("labName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "labName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568264 != nil:
    section.add "api-version", valid_568264
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

proc call*(call_568266: Call_ArtifactGenerateArmTemplate_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_ArtifactGenerateArmTemplate_568256;
          resourceGroupName: string; name: string; subscriptionId: string;
          artifactSourceName: string; labName: string;
          generateArmTemplateRequest: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactGenerateArmTemplate
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   generateArmTemplateRequest: JObject (required)
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  var body_568270 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "name", newJString(name))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "artifactSourceName", newJString(artifactSourceName))
  add(path_568268, "labName", newJString(labName))
  if generateArmTemplateRequest != nil:
    body_568270 = generateArmTemplateRequest
  result = call_568267.call(path_568268, query_568269, nil, nil, body_568270)

var artifactGenerateArmTemplate* = Call_ArtifactGenerateArmTemplate_568256(
    name: "artifactGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactGenerateArmTemplate_568257, base: "",
    url: url_ArtifactGenerateArmTemplate_568258, schemes: {Scheme.Https})
type
  Call_ArtifactSourceCreateOrUpdateResource_568283 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourceCreateOrUpdateResource_568285(protocol: Scheme;
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

proc validate_ArtifactSourceCreateOrUpdateResource_568284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("name")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "name", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("labName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "labName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568290 != nil:
    section.add "api-version", valid_568290
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

proc call*(call_568292: Call_ArtifactSourceCreateOrUpdateResource_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_ArtifactSourceCreateOrUpdateResource_568283;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceCreateOrUpdateResource
  ## Create or replace an existing artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  var body_568296 = newJObject()
  add(path_568294, "resourceGroupName", newJString(resourceGroupName))
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "name", newJString(name))
  if artifactSource != nil:
    body_568296 = artifactSource
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  add(path_568294, "labName", newJString(labName))
  result = call_568293.call(path_568294, query_568295, nil, nil, body_568296)

var artifactSourceCreateOrUpdateResource* = Call_ArtifactSourceCreateOrUpdateResource_568283(
    name: "artifactSourceCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceCreateOrUpdateResource_568284, base: "",
    url: url_ArtifactSourceCreateOrUpdateResource_568285, schemes: {Scheme.Https})
type
  Call_ArtifactSourceGetResource_568271 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourceGetResource_568273(protocol: Scheme; host: string;
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

proc validate_ArtifactSourceGetResource_568272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("name")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "name", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  var valid_568277 = path.getOrDefault("labName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "labName", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_ArtifactSourceGetResource_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_ArtifactSourceGetResource_568271;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceGetResource
  ## Get artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "name", newJString(name))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  add(path_568281, "labName", newJString(labName))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var artifactSourceGetResource* = Call_ArtifactSourceGetResource_568271(
    name: "artifactSourceGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceGetResource_568272, base: "",
    url: url_ArtifactSourceGetResource_568273, schemes: {Scheme.Https})
type
  Call_ArtifactSourcePatchResource_568309 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourcePatchResource_568311(protocol: Scheme; host: string;
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

proc validate_ArtifactSourcePatchResource_568310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568312 = path.getOrDefault("resourceGroupName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "resourceGroupName", valid_568312
  var valid_568313 = path.getOrDefault("name")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "name", valid_568313
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  var valid_568315 = path.getOrDefault("labName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "labName", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568316 != nil:
    section.add "api-version", valid_568316
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

proc call*(call_568318: Call_ArtifactSourcePatchResource_568309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of artifact sources.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_ArtifactSourcePatchResource_568309;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourcePatchResource
  ## Modify properties of artifact sources.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  var body_568322 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "name", newJString(name))
  if artifactSource != nil:
    body_568322 = artifactSource
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  add(path_568320, "labName", newJString(labName))
  result = call_568319.call(path_568320, query_568321, nil, nil, body_568322)

var artifactSourcePatchResource* = Call_ArtifactSourcePatchResource_568309(
    name: "artifactSourcePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcePatchResource_568310, base: "",
    url: url_ArtifactSourcePatchResource_568311, schemes: {Scheme.Https})
type
  Call_ArtifactSourceDeleteResource_568297 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourceDeleteResource_568299(protocol: Scheme; host: string;
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

proc validate_ArtifactSourceDeleteResource_568298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("name")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "name", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("labName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "labName", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_ArtifactSourceDeleteResource_568297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_ArtifactSourceDeleteResource_568297;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceDeleteResource
  ## Delete artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "name", newJString(name))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  add(path_568307, "labName", newJString(labName))
  result = call_568306.call(path_568307, query_568308, nil, nil, nil)

var artifactSourceDeleteResource* = Call_ArtifactSourceDeleteResource_568297(
    name: "artifactSourceDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceDeleteResource_568298, base: "",
    url: url_ArtifactSourceDeleteResource_568299, schemes: {Scheme.Https})
type
  Call_CostInsightList_568323 = ref object of OpenApiRestCall_567650
proc url_CostInsightList_568325(protocol: Scheme; host: string; base: string;
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

proc validate_CostInsightList_568324(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List cost insights.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  var valid_568328 = path.getOrDefault("labName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "labName", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  var valid_568330 = query.getOrDefault("$top")
  valid_568330 = validateParameter(valid_568330, JInt, required = false, default = nil)
  if valid_568330 != nil:
    section.add "$top", valid_568330
  var valid_568331 = query.getOrDefault("$orderBy")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "$orderBy", valid_568331
  var valid_568332 = query.getOrDefault("$filter")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "$filter", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_CostInsightList_568323; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cost insights.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_CostInsightList_568323; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## costInsightList
  ## List cost insights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  add(query_568336, "$top", newJInt(Top))
  add(query_568336, "$orderBy", newJString(OrderBy))
  add(path_568335, "labName", newJString(labName))
  add(query_568336, "$filter", newJString(Filter))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var costInsightList* = Call_CostInsightList_568323(name: "costInsightList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights",
    validator: validate_CostInsightList_568324, base: "", url: url_CostInsightList_568325,
    schemes: {Scheme.Https})
type
  Call_CostInsightGetResource_568337 = ref object of OpenApiRestCall_567650
proc url_CostInsightGetResource_568339(protocol: Scheme; host: string; base: string;
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

proc validate_CostInsightGetResource_568338(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost insight.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("name")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "name", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  var valid_568343 = path.getOrDefault("labName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "labName", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568344 = query.getOrDefault("api-version")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568344 != nil:
    section.add "api-version", valid_568344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568345: Call_CostInsightGetResource_568337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost insight.
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_CostInsightGetResource_568337;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costInsightGetResource
  ## Get cost insight.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "name", newJString(name))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  add(path_568347, "labName", newJString(labName))
  result = call_568346.call(path_568347, query_568348, nil, nil, nil)

var costInsightGetResource* = Call_CostInsightGetResource_568337(
    name: "costInsightGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights/{name}",
    validator: validate_CostInsightGetResource_568338, base: "",
    url: url_CostInsightGetResource_568339, schemes: {Scheme.Https})
type
  Call_CostInsightRefreshData_568349 = ref object of OpenApiRestCall_567650
proc url_CostInsightRefreshData_568351(protocol: Scheme; host: string; base: string;
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

proc validate_CostInsightRefreshData_568350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568352 = path.getOrDefault("resourceGroupName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "resourceGroupName", valid_568352
  var valid_568353 = path.getOrDefault("name")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "name", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  var valid_568355 = path.getOrDefault("labName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "labName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_CostInsightRefreshData_568349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_CostInsightRefreshData_568349;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costInsightRefreshData
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "name", newJString(name))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  add(path_568359, "labName", newJString(labName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var costInsightRefreshData* = Call_CostInsightRefreshData_568349(
    name: "costInsightRefreshData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights/{name}/refreshData",
    validator: validate_CostInsightRefreshData_568350, base: "",
    url: url_CostInsightRefreshData_568351, schemes: {Scheme.Https})
type
  Call_CostList_568361 = ref object of OpenApiRestCall_567650
proc url_CostList_568363(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CostList_568362(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List costs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  var valid_568366 = path.getOrDefault("labName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "labName", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  var valid_568368 = query.getOrDefault("$top")
  valid_568368 = validateParameter(valid_568368, JInt, required = false, default = nil)
  if valid_568368 != nil:
    section.add "$top", valid_568368
  var valid_568369 = query.getOrDefault("$orderBy")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = nil)
  if valid_568369 != nil:
    section.add "$orderBy", valid_568369
  var valid_568370 = query.getOrDefault("$filter")
  valid_568370 = validateParameter(valid_568370, JString, required = false,
                                 default = nil)
  if valid_568370 != nil:
    section.add "$filter", valid_568370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568371: Call_CostList_568361; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List costs.
  ## 
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_CostList_568361; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## costList
  ## List costs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  add(path_568373, "resourceGroupName", newJString(resourceGroupName))
  add(query_568374, "api-version", newJString(apiVersion))
  add(path_568373, "subscriptionId", newJString(subscriptionId))
  add(query_568374, "$top", newJInt(Top))
  add(query_568374, "$orderBy", newJString(OrderBy))
  add(path_568373, "labName", newJString(labName))
  add(query_568374, "$filter", newJString(Filter))
  result = call_568372.call(path_568373, query_568374, nil, nil, nil)

var costList* = Call_CostList_568361(name: "costList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs",
                                  validator: validate_CostList_568362, base: "",
                                  url: url_CostList_568363,
                                  schemes: {Scheme.Https})
type
  Call_CostGetResource_568375 = ref object of OpenApiRestCall_567650
proc url_CostGetResource_568377(protocol: Scheme; host: string; base: string;
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

proc validate_CostGetResource_568376(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("name")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "name", valid_568379
  var valid_568380 = path.getOrDefault("subscriptionId")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "subscriptionId", valid_568380
  var valid_568381 = path.getOrDefault("labName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "labName", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_CostGetResource_568375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_CostGetResource_568375; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costGetResource
  ## Get cost.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "name", newJString(name))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  add(path_568385, "labName", newJString(labName))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var costGetResource* = Call_CostGetResource_568375(name: "costGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostGetResource_568376, base: "", url: url_CostGetResource_568377,
    schemes: {Scheme.Https})
type
  Call_CostRefreshData_568387 = ref object of OpenApiRestCall_567650
proc url_CostRefreshData_568389(protocol: Scheme; host: string; base: string;
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

proc validate_CostRefreshData_568388(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("name")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "name", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  var valid_568393 = path.getOrDefault("labName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "labName", valid_568393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568394 = query.getOrDefault("api-version")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568394 != nil:
    section.add "api-version", valid_568394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568395: Call_CostRefreshData_568387; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ## 
  let valid = call_568395.validator(path, query, header, formData, body)
  let scheme = call_568395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568395.url(scheme.get, call_568395.host, call_568395.base,
                         call_568395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568395, url, valid)

proc call*(call_568396: Call_CostRefreshData_568387; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costRefreshData
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568397 = newJObject()
  var query_568398 = newJObject()
  add(path_568397, "resourceGroupName", newJString(resourceGroupName))
  add(query_568398, "api-version", newJString(apiVersion))
  add(path_568397, "name", newJString(name))
  add(path_568397, "subscriptionId", newJString(subscriptionId))
  add(path_568397, "labName", newJString(labName))
  result = call_568396.call(path_568397, query_568398, nil, nil, nil)

var costRefreshData* = Call_CostRefreshData_568387(name: "costRefreshData",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}/refreshData",
    validator: validate_CostRefreshData_568388, base: "", url: url_CostRefreshData_568389,
    schemes: {Scheme.Https})
type
  Call_CustomImageList_568399 = ref object of OpenApiRestCall_567650
proc url_CustomImageList_568401(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImageList_568400(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List custom images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568402 = path.getOrDefault("resourceGroupName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "resourceGroupName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
  var valid_568404 = path.getOrDefault("labName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "labName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  var valid_568406 = query.getOrDefault("$top")
  valid_568406 = validateParameter(valid_568406, JInt, required = false, default = nil)
  if valid_568406 != nil:
    section.add "$top", valid_568406
  var valid_568407 = query.getOrDefault("$orderBy")
  valid_568407 = validateParameter(valid_568407, JString, required = false,
                                 default = nil)
  if valid_568407 != nil:
    section.add "$orderBy", valid_568407
  var valid_568408 = query.getOrDefault("$filter")
  valid_568408 = validateParameter(valid_568408, JString, required = false,
                                 default = nil)
  if valid_568408 != nil:
    section.add "$filter", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_CustomImageList_568399; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images.
  ## 
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_CustomImageList_568399; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## customImageList
  ## List custom images.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568411 = newJObject()
  var query_568412 = newJObject()
  add(path_568411, "resourceGroupName", newJString(resourceGroupName))
  add(query_568412, "api-version", newJString(apiVersion))
  add(path_568411, "subscriptionId", newJString(subscriptionId))
  add(query_568412, "$top", newJInt(Top))
  add(query_568412, "$orderBy", newJString(OrderBy))
  add(path_568411, "labName", newJString(labName))
  add(query_568412, "$filter", newJString(Filter))
  result = call_568410.call(path_568411, query_568412, nil, nil, nil)

var customImageList* = Call_CustomImageList_568399(name: "customImageList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImageList_568400, base: "", url: url_CustomImageList_568401,
    schemes: {Scheme.Https})
type
  Call_CustomImageCreateOrUpdateResource_568425 = ref object of OpenApiRestCall_567650
proc url_CustomImageCreateOrUpdateResource_568427(protocol: Scheme; host: string;
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

proc validate_CustomImageCreateOrUpdateResource_568426(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568428 = path.getOrDefault("resourceGroupName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "resourceGroupName", valid_568428
  var valid_568429 = path.getOrDefault("name")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "name", valid_568429
  var valid_568430 = path.getOrDefault("subscriptionId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "subscriptionId", valid_568430
  var valid_568431 = path.getOrDefault("labName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "labName", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568432 != nil:
    section.add "api-version", valid_568432
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

proc call*(call_568434: Call_CustomImageCreateOrUpdateResource_568425;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_CustomImageCreateOrUpdateResource_568425;
          resourceGroupName: string; name: string; subscriptionId: string;
          customImage: JsonNode; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageCreateOrUpdateResource
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   customImage: JObject (required)
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  var body_568438 = newJObject()
  add(path_568436, "resourceGroupName", newJString(resourceGroupName))
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "name", newJString(name))
  add(path_568436, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_568438 = customImage
  add(path_568436, "labName", newJString(labName))
  result = call_568435.call(path_568436, query_568437, nil, nil, body_568438)

var customImageCreateOrUpdateResource* = Call_CustomImageCreateOrUpdateResource_568425(
    name: "customImageCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageCreateOrUpdateResource_568426, base: "",
    url: url_CustomImageCreateOrUpdateResource_568427, schemes: {Scheme.Https})
type
  Call_CustomImageGetResource_568413 = ref object of OpenApiRestCall_567650
proc url_CustomImageGetResource_568415(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImageGetResource_568414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get custom image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568416 = path.getOrDefault("resourceGroupName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "resourceGroupName", valid_568416
  var valid_568417 = path.getOrDefault("name")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "name", valid_568417
  var valid_568418 = path.getOrDefault("subscriptionId")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "subscriptionId", valid_568418
  var valid_568419 = path.getOrDefault("labName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "labName", valid_568419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568420 = query.getOrDefault("api-version")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568420 != nil:
    section.add "api-version", valid_568420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_CustomImageGetResource_568413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_CustomImageGetResource_568413;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageGetResource
  ## Get custom image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "name", newJString(name))
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  add(path_568423, "labName", newJString(labName))
  result = call_568422.call(path_568423, query_568424, nil, nil, nil)

var customImageGetResource* = Call_CustomImageGetResource_568413(
    name: "customImageGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageGetResource_568414, base: "",
    url: url_CustomImageGetResource_568415, schemes: {Scheme.Https})
type
  Call_CustomImageDeleteResource_568439 = ref object of OpenApiRestCall_567650
proc url_CustomImageDeleteResource_568441(protocol: Scheme; host: string;
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

proc validate_CustomImageDeleteResource_568440(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568442 = path.getOrDefault("resourceGroupName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "resourceGroupName", valid_568442
  var valid_568443 = path.getOrDefault("name")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "name", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  var valid_568445 = path.getOrDefault("labName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "labName", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568446 != nil:
    section.add "api-version", valid_568446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_CustomImageDeleteResource_568439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_CustomImageDeleteResource_568439;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageDeleteResource
  ## Delete custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "name", newJString(name))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  add(path_568449, "labName", newJString(labName))
  result = call_568448.call(path_568449, query_568450, nil, nil, nil)

var customImageDeleteResource* = Call_CustomImageDeleteResource_568439(
    name: "customImageDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageDeleteResource_568440, base: "",
    url: url_CustomImageDeleteResource_568441, schemes: {Scheme.Https})
type
  Call_FormulaList_568451 = ref object of OpenApiRestCall_567650
proc url_FormulaList_568453(protocol: Scheme; host: string; base: string;
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

proc validate_FormulaList_568452(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List formulas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568454 = path.getOrDefault("resourceGroupName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "resourceGroupName", valid_568454
  var valid_568455 = path.getOrDefault("subscriptionId")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "subscriptionId", valid_568455
  var valid_568456 = path.getOrDefault("labName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "labName", valid_568456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568457 = query.getOrDefault("api-version")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568457 != nil:
    section.add "api-version", valid_568457
  var valid_568458 = query.getOrDefault("$top")
  valid_568458 = validateParameter(valid_568458, JInt, required = false, default = nil)
  if valid_568458 != nil:
    section.add "$top", valid_568458
  var valid_568459 = query.getOrDefault("$orderBy")
  valid_568459 = validateParameter(valid_568459, JString, required = false,
                                 default = nil)
  if valid_568459 != nil:
    section.add "$orderBy", valid_568459
  var valid_568460 = query.getOrDefault("$filter")
  valid_568460 = validateParameter(valid_568460, JString, required = false,
                                 default = nil)
  if valid_568460 != nil:
    section.add "$filter", valid_568460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_FormulaList_568451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas.
  ## 
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_FormulaList_568451; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## formulaList
  ## List formulas.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  add(path_568463, "resourceGroupName", newJString(resourceGroupName))
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "subscriptionId", newJString(subscriptionId))
  add(query_568464, "$top", newJInt(Top))
  add(query_568464, "$orderBy", newJString(OrderBy))
  add(path_568463, "labName", newJString(labName))
  add(query_568464, "$filter", newJString(Filter))
  result = call_568462.call(path_568463, query_568464, nil, nil, nil)

var formulaList* = Call_FormulaList_568451(name: "formulaList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
                                        validator: validate_FormulaList_568452,
                                        base: "", url: url_FormulaList_568453,
                                        schemes: {Scheme.Https})
type
  Call_FormulaCreateOrUpdateResource_568477 = ref object of OpenApiRestCall_567650
proc url_FormulaCreateOrUpdateResource_568479(protocol: Scheme; host: string;
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

proc validate_FormulaCreateOrUpdateResource_568478(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568480 = path.getOrDefault("resourceGroupName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "resourceGroupName", valid_568480
  var valid_568481 = path.getOrDefault("name")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "name", valid_568481
  var valid_568482 = path.getOrDefault("subscriptionId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "subscriptionId", valid_568482
  var valid_568483 = path.getOrDefault("labName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "labName", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568484 = query.getOrDefault("api-version")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568484 != nil:
    section.add "api-version", valid_568484
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

proc call*(call_568486: Call_FormulaCreateOrUpdateResource_568477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_FormulaCreateOrUpdateResource_568477;
          resourceGroupName: string; formula: JsonNode; name: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaCreateOrUpdateResource
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  var body_568490 = newJObject()
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_568490 = formula
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "name", newJString(name))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  add(path_568488, "labName", newJString(labName))
  result = call_568487.call(path_568488, query_568489, nil, nil, body_568490)

var formulaCreateOrUpdateResource* = Call_FormulaCreateOrUpdateResource_568477(
    name: "formulaCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaCreateOrUpdateResource_568478, base: "",
    url: url_FormulaCreateOrUpdateResource_568479, schemes: {Scheme.Https})
type
  Call_FormulaGetResource_568465 = ref object of OpenApiRestCall_567650
proc url_FormulaGetResource_568467(protocol: Scheme; host: string; base: string;
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

proc validate_FormulaGetResource_568466(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568468 = path.getOrDefault("resourceGroupName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "resourceGroupName", valid_568468
  var valid_568469 = path.getOrDefault("name")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "name", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("labName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "labName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568473: Call_FormulaGetResource_568465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_568473.validator(path, query, header, formData, body)
  let scheme = call_568473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568473.url(scheme.get, call_568473.host, call_568473.base,
                         call_568473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568473, url, valid)

proc call*(call_568474: Call_FormulaGetResource_568465; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaGetResource
  ## Get formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568475 = newJObject()
  var query_568476 = newJObject()
  add(path_568475, "resourceGroupName", newJString(resourceGroupName))
  add(query_568476, "api-version", newJString(apiVersion))
  add(path_568475, "name", newJString(name))
  add(path_568475, "subscriptionId", newJString(subscriptionId))
  add(path_568475, "labName", newJString(labName))
  result = call_568474.call(path_568475, query_568476, nil, nil, nil)

var formulaGetResource* = Call_FormulaGetResource_568465(
    name: "formulaGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaGetResource_568466, base: "",
    url: url_FormulaGetResource_568467, schemes: {Scheme.Https})
type
  Call_FormulaDeleteResource_568491 = ref object of OpenApiRestCall_567650
proc url_FormulaDeleteResource_568493(protocol: Scheme; host: string; base: string;
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

proc validate_FormulaDeleteResource_568492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("name")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "name", valid_568495
  var valid_568496 = path.getOrDefault("subscriptionId")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "subscriptionId", valid_568496
  var valid_568497 = path.getOrDefault("labName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "labName", valid_568497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568498 = query.getOrDefault("api-version")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568498 != nil:
    section.add "api-version", valid_568498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568499: Call_FormulaDeleteResource_568491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_568499.validator(path, query, header, formData, body)
  let scheme = call_568499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568499.url(scheme.get, call_568499.host, call_568499.base,
                         call_568499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568499, url, valid)

proc call*(call_568500: Call_FormulaDeleteResource_568491;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaDeleteResource
  ## Delete formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568501 = newJObject()
  var query_568502 = newJObject()
  add(path_568501, "resourceGroupName", newJString(resourceGroupName))
  add(query_568502, "api-version", newJString(apiVersion))
  add(path_568501, "name", newJString(name))
  add(path_568501, "subscriptionId", newJString(subscriptionId))
  add(path_568501, "labName", newJString(labName))
  result = call_568500.call(path_568501, query_568502, nil, nil, nil)

var formulaDeleteResource* = Call_FormulaDeleteResource_568491(
    name: "formulaDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaDeleteResource_568492, base: "",
    url: url_FormulaDeleteResource_568493, schemes: {Scheme.Https})
type
  Call_GalleryImageList_568503 = ref object of OpenApiRestCall_567650
proc url_GalleryImageList_568505(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImageList_568504(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List gallery images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568506 = path.getOrDefault("resourceGroupName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "resourceGroupName", valid_568506
  var valid_568507 = path.getOrDefault("subscriptionId")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "subscriptionId", valid_568507
  var valid_568508 = path.getOrDefault("labName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "labName", valid_568508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568509 = query.getOrDefault("api-version")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568509 != nil:
    section.add "api-version", valid_568509
  var valid_568510 = query.getOrDefault("$top")
  valid_568510 = validateParameter(valid_568510, JInt, required = false, default = nil)
  if valid_568510 != nil:
    section.add "$top", valid_568510
  var valid_568511 = query.getOrDefault("$orderBy")
  valid_568511 = validateParameter(valid_568511, JString, required = false,
                                 default = nil)
  if valid_568511 != nil:
    section.add "$orderBy", valid_568511
  var valid_568512 = query.getOrDefault("$filter")
  valid_568512 = validateParameter(valid_568512, JString, required = false,
                                 default = nil)
  if valid_568512 != nil:
    section.add "$filter", valid_568512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568513: Call_GalleryImageList_568503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images.
  ## 
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_GalleryImageList_568503; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## galleryImageList
  ## List gallery images.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568515 = newJObject()
  var query_568516 = newJObject()
  add(path_568515, "resourceGroupName", newJString(resourceGroupName))
  add(query_568516, "api-version", newJString(apiVersion))
  add(path_568515, "subscriptionId", newJString(subscriptionId))
  add(query_568516, "$top", newJInt(Top))
  add(query_568516, "$orderBy", newJString(OrderBy))
  add(path_568515, "labName", newJString(labName))
  add(query_568516, "$filter", newJString(Filter))
  result = call_568514.call(path_568515, query_568516, nil, nil, nil)

var galleryImageList* = Call_GalleryImageList_568503(name: "galleryImageList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImageList_568504, base: "",
    url: url_GalleryImageList_568505, schemes: {Scheme.Https})
type
  Call_PolicySetEvaluatePolicies_568517 = ref object of OpenApiRestCall_567650
proc url_PolicySetEvaluatePolicies_568519(protocol: Scheme; host: string;
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

proc validate_PolicySetEvaluatePolicies_568518(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Evaluates Lab Policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568520 = path.getOrDefault("resourceGroupName")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "resourceGroupName", valid_568520
  var valid_568521 = path.getOrDefault("name")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "name", valid_568521
  var valid_568522 = path.getOrDefault("subscriptionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "subscriptionId", valid_568522
  var valid_568523 = path.getOrDefault("labName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "labName", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568524 != nil:
    section.add "api-version", valid_568524
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

proc call*(call_568526: Call_PolicySetEvaluatePolicies_568517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates Lab Policy.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_PolicySetEvaluatePolicies_568517;
          resourceGroupName: string; name: string; subscriptionId: string;
          evaluatePoliciesRequest: JsonNode; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policySetEvaluatePolicies
  ## Evaluates Lab Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   evaluatePoliciesRequest: JObject (required)
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  var body_568530 = newJObject()
  add(path_568528, "resourceGroupName", newJString(resourceGroupName))
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "name", newJString(name))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  if evaluatePoliciesRequest != nil:
    body_568530 = evaluatePoliciesRequest
  add(path_568528, "labName", newJString(labName))
  result = call_568527.call(path_568528, query_568529, nil, nil, body_568530)

var policySetEvaluatePolicies* = Call_PolicySetEvaluatePolicies_568517(
    name: "policySetEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetEvaluatePolicies_568518, base: "",
    url: url_PolicySetEvaluatePolicies_568519, schemes: {Scheme.Https})
type
  Call_PolicyList_568531 = ref object of OpenApiRestCall_567650
proc url_PolicyList_568533(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PolicyList_568532(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568534 = path.getOrDefault("resourceGroupName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "resourceGroupName", valid_568534
  var valid_568535 = path.getOrDefault("subscriptionId")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "subscriptionId", valid_568535
  var valid_568536 = path.getOrDefault("policySetName")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "policySetName", valid_568536
  var valid_568537 = path.getOrDefault("labName")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "labName", valid_568537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568538 = query.getOrDefault("api-version")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568538 != nil:
    section.add "api-version", valid_568538
  var valid_568539 = query.getOrDefault("$top")
  valid_568539 = validateParameter(valid_568539, JInt, required = false, default = nil)
  if valid_568539 != nil:
    section.add "$top", valid_568539
  var valid_568540 = query.getOrDefault("$orderBy")
  valid_568540 = validateParameter(valid_568540, JString, required = false,
                                 default = nil)
  if valid_568540 != nil:
    section.add "$orderBy", valid_568540
  var valid_568541 = query.getOrDefault("$filter")
  valid_568541 = validateParameter(valid_568541, JString, required = false,
                                 default = nil)
  if valid_568541 != nil:
    section.add "$filter", valid_568541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568542: Call_PolicyList_568531; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies.
  ## 
  let valid = call_568542.validator(path, query, header, formData, body)
  let scheme = call_568542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568542.url(scheme.get, call_568542.host, call_568542.base,
                         call_568542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568542, url, valid)

proc call*(call_568543: Call_PolicyList_568531; resourceGroupName: string;
          subscriptionId: string; policySetName: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## policyList
  ## List policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568544 = newJObject()
  var query_568545 = newJObject()
  add(path_568544, "resourceGroupName", newJString(resourceGroupName))
  add(query_568545, "api-version", newJString(apiVersion))
  add(path_568544, "subscriptionId", newJString(subscriptionId))
  add(query_568545, "$top", newJInt(Top))
  add(query_568545, "$orderBy", newJString(OrderBy))
  add(path_568544, "policySetName", newJString(policySetName))
  add(path_568544, "labName", newJString(labName))
  add(query_568545, "$filter", newJString(Filter))
  result = call_568543.call(path_568544, query_568545, nil, nil, nil)

var policyList* = Call_PolicyList_568531(name: "policyList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
                                      validator: validate_PolicyList_568532,
                                      base: "", url: url_PolicyList_568533,
                                      schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdateResource_568559 = ref object of OpenApiRestCall_567650
proc url_PolicyCreateOrUpdateResource_568561(protocol: Scheme; host: string;
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

proc validate_PolicyCreateOrUpdateResource_568560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("name")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "name", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  var valid_568565 = path.getOrDefault("policySetName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "policySetName", valid_568565
  var valid_568566 = path.getOrDefault("labName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "labName", valid_568566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568567 = query.getOrDefault("api-version")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568567 != nil:
    section.add "api-version", valid_568567
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

proc call*(call_568569: Call_PolicyCreateOrUpdateResource_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_PolicyCreateOrUpdateResource_568559;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string; policy: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyCreateOrUpdateResource
  ## Create or replace an existing policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  var body_568573 = newJObject()
  add(path_568571, "resourceGroupName", newJString(resourceGroupName))
  add(query_568572, "api-version", newJString(apiVersion))
  add(path_568571, "name", newJString(name))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  add(path_568571, "policySetName", newJString(policySetName))
  add(path_568571, "labName", newJString(labName))
  if policy != nil:
    body_568573 = policy
  result = call_568570.call(path_568571, query_568572, nil, nil, body_568573)

var policyCreateOrUpdateResource* = Call_PolicyCreateOrUpdateResource_568559(
    name: "policyCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyCreateOrUpdateResource_568560, base: "",
    url: url_PolicyCreateOrUpdateResource_568561, schemes: {Scheme.Https})
type
  Call_PolicyGetResource_568546 = ref object of OpenApiRestCall_567650
proc url_PolicyGetResource_568548(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyGetResource_568547(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568549 = path.getOrDefault("resourceGroupName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "resourceGroupName", valid_568549
  var valid_568550 = path.getOrDefault("name")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "name", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  var valid_568552 = path.getOrDefault("policySetName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "policySetName", valid_568552
  var valid_568553 = path.getOrDefault("labName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "labName", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_PolicyGetResource_568546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_PolicyGetResource_568546; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyGetResource
  ## Get policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "name", newJString(name))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  add(path_568557, "policySetName", newJString(policySetName))
  add(path_568557, "labName", newJString(labName))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var policyGetResource* = Call_PolicyGetResource_568546(name: "policyGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyGetResource_568547, base: "",
    url: url_PolicyGetResource_568548, schemes: {Scheme.Https})
type
  Call_PolicyPatchResource_568587 = ref object of OpenApiRestCall_567650
proc url_PolicyPatchResource_568589(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyPatchResource_568588(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modify properties of policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568590 = path.getOrDefault("resourceGroupName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "resourceGroupName", valid_568590
  var valid_568591 = path.getOrDefault("name")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "name", valid_568591
  var valid_568592 = path.getOrDefault("subscriptionId")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "subscriptionId", valid_568592
  var valid_568593 = path.getOrDefault("policySetName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "policySetName", valid_568593
  var valid_568594 = path.getOrDefault("labName")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "labName", valid_568594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568595 = query.getOrDefault("api-version")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568595 != nil:
    section.add "api-version", valid_568595
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

proc call*(call_568597: Call_PolicyPatchResource_568587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of policies.
  ## 
  let valid = call_568597.validator(path, query, header, formData, body)
  let scheme = call_568597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568597.url(scheme.get, call_568597.host, call_568597.base,
                         call_568597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568597, url, valid)

proc call*(call_568598: Call_PolicyPatchResource_568587; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; policy: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyPatchResource
  ## Modify properties of policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  var path_568599 = newJObject()
  var query_568600 = newJObject()
  var body_568601 = newJObject()
  add(path_568599, "resourceGroupName", newJString(resourceGroupName))
  add(query_568600, "api-version", newJString(apiVersion))
  add(path_568599, "name", newJString(name))
  add(path_568599, "subscriptionId", newJString(subscriptionId))
  add(path_568599, "policySetName", newJString(policySetName))
  add(path_568599, "labName", newJString(labName))
  if policy != nil:
    body_568601 = policy
  result = call_568598.call(path_568599, query_568600, nil, nil, body_568601)

var policyPatchResource* = Call_PolicyPatchResource_568587(
    name: "policyPatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyPatchResource_568588, base: "",
    url: url_PolicyPatchResource_568589, schemes: {Scheme.Https})
type
  Call_PolicyDeleteResource_568574 = ref object of OpenApiRestCall_567650
proc url_PolicyDeleteResource_568576(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDeleteResource_568575(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("name")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "name", valid_568578
  var valid_568579 = path.getOrDefault("subscriptionId")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "subscriptionId", valid_568579
  var valid_568580 = path.getOrDefault("policySetName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "policySetName", valid_568580
  var valid_568581 = path.getOrDefault("labName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "labName", valid_568581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568582 = query.getOrDefault("api-version")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568582 != nil:
    section.add "api-version", valid_568582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_PolicyDeleteResource_568574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_PolicyDeleteResource_568574;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyDeleteResource
  ## Delete policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "name", newJString(name))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  add(path_568585, "policySetName", newJString(policySetName))
  add(path_568585, "labName", newJString(labName))
  result = call_568584.call(path_568585, query_568586, nil, nil, nil)

var policyDeleteResource* = Call_PolicyDeleteResource_568574(
    name: "policyDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyDeleteResource_568575, base: "",
    url: url_PolicyDeleteResource_568576, schemes: {Scheme.Https})
type
  Call_ScheduleList_568602 = ref object of OpenApiRestCall_567650
proc url_ScheduleList_568604(protocol: Scheme; host: string; base: string;
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

proc validate_ScheduleList_568603(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568605 = path.getOrDefault("resourceGroupName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "resourceGroupName", valid_568605
  var valid_568606 = path.getOrDefault("subscriptionId")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "subscriptionId", valid_568606
  var valid_568607 = path.getOrDefault("labName")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "labName", valid_568607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568608 = query.getOrDefault("api-version")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568608 != nil:
    section.add "api-version", valid_568608
  var valid_568609 = query.getOrDefault("$top")
  valid_568609 = validateParameter(valid_568609, JInt, required = false, default = nil)
  if valid_568609 != nil:
    section.add "$top", valid_568609
  var valid_568610 = query.getOrDefault("$orderBy")
  valid_568610 = validateParameter(valid_568610, JString, required = false,
                                 default = nil)
  if valid_568610 != nil:
    section.add "$orderBy", valid_568610
  var valid_568611 = query.getOrDefault("$filter")
  valid_568611 = validateParameter(valid_568611, JString, required = false,
                                 default = nil)
  if valid_568611 != nil:
    section.add "$filter", valid_568611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568612: Call_ScheduleList_568602; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules.
  ## 
  let valid = call_568612.validator(path, query, header, formData, body)
  let scheme = call_568612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568612.url(scheme.get, call_568612.host, call_568612.base,
                         call_568612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568612, url, valid)

proc call*(call_568613: Call_ScheduleList_568602; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## scheduleList
  ## List schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568614 = newJObject()
  var query_568615 = newJObject()
  add(path_568614, "resourceGroupName", newJString(resourceGroupName))
  add(query_568615, "api-version", newJString(apiVersion))
  add(path_568614, "subscriptionId", newJString(subscriptionId))
  add(query_568615, "$top", newJInt(Top))
  add(query_568615, "$orderBy", newJString(OrderBy))
  add(path_568614, "labName", newJString(labName))
  add(query_568615, "$filter", newJString(Filter))
  result = call_568613.call(path_568614, query_568615, nil, nil, nil)

var scheduleList* = Call_ScheduleList_568602(name: "scheduleList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_ScheduleList_568603, base: "", url: url_ScheduleList_568604,
    schemes: {Scheme.Https})
type
  Call_ScheduleCreateOrUpdateResource_568628 = ref object of OpenApiRestCall_567650
proc url_ScheduleCreateOrUpdateResource_568630(protocol: Scheme; host: string;
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

proc validate_ScheduleCreateOrUpdateResource_568629(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568631 = path.getOrDefault("resourceGroupName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "resourceGroupName", valid_568631
  var valid_568632 = path.getOrDefault("name")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "name", valid_568632
  var valid_568633 = path.getOrDefault("subscriptionId")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "subscriptionId", valid_568633
  var valid_568634 = path.getOrDefault("labName")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "labName", valid_568634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568635 != nil:
    section.add "api-version", valid_568635
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

proc call*(call_568637: Call_ScheduleCreateOrUpdateResource_568628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ## 
  let valid = call_568637.validator(path, query, header, formData, body)
  let scheme = call_568637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568637.url(scheme.get, call_568637.host, call_568637.base,
                         call_568637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568637, url, valid)

proc call*(call_568638: Call_ScheduleCreateOrUpdateResource_568628;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleCreateOrUpdateResource
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  var path_568639 = newJObject()
  var query_568640 = newJObject()
  var body_568641 = newJObject()
  add(path_568639, "resourceGroupName", newJString(resourceGroupName))
  add(query_568640, "api-version", newJString(apiVersion))
  add(path_568639, "name", newJString(name))
  add(path_568639, "subscriptionId", newJString(subscriptionId))
  add(path_568639, "labName", newJString(labName))
  if schedule != nil:
    body_568641 = schedule
  result = call_568638.call(path_568639, query_568640, nil, nil, body_568641)

var scheduleCreateOrUpdateResource* = Call_ScheduleCreateOrUpdateResource_568628(
    name: "scheduleCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleCreateOrUpdateResource_568629, base: "",
    url: url_ScheduleCreateOrUpdateResource_568630, schemes: {Scheme.Https})
type
  Call_ScheduleGetResource_568616 = ref object of OpenApiRestCall_567650
proc url_ScheduleGetResource_568618(protocol: Scheme; host: string; base: string;
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

proc validate_ScheduleGetResource_568617(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568619 = path.getOrDefault("resourceGroupName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "resourceGroupName", valid_568619
  var valid_568620 = path.getOrDefault("name")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "name", valid_568620
  var valid_568621 = path.getOrDefault("subscriptionId")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "subscriptionId", valid_568621
  var valid_568622 = path.getOrDefault("labName")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "labName", valid_568622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568623 = query.getOrDefault("api-version")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568623 != nil:
    section.add "api-version", valid_568623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568624: Call_ScheduleGetResource_568616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_568624.validator(path, query, header, formData, body)
  let scheme = call_568624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568624.url(scheme.get, call_568624.host, call_568624.base,
                         call_568624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568624, url, valid)

proc call*(call_568625: Call_ScheduleGetResource_568616; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleGetResource
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568626 = newJObject()
  var query_568627 = newJObject()
  add(path_568626, "resourceGroupName", newJString(resourceGroupName))
  add(query_568627, "api-version", newJString(apiVersion))
  add(path_568626, "name", newJString(name))
  add(path_568626, "subscriptionId", newJString(subscriptionId))
  add(path_568626, "labName", newJString(labName))
  result = call_568625.call(path_568626, query_568627, nil, nil, nil)

var scheduleGetResource* = Call_ScheduleGetResource_568616(
    name: "scheduleGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleGetResource_568617, base: "",
    url: url_ScheduleGetResource_568618, schemes: {Scheme.Https})
type
  Call_SchedulePatchResource_568654 = ref object of OpenApiRestCall_567650
proc url_SchedulePatchResource_568656(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulePatchResource_568655(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568657 = path.getOrDefault("resourceGroupName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "resourceGroupName", valid_568657
  var valid_568658 = path.getOrDefault("name")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "name", valid_568658
  var valid_568659 = path.getOrDefault("subscriptionId")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "subscriptionId", valid_568659
  var valid_568660 = path.getOrDefault("labName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "labName", valid_568660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568661 = query.getOrDefault("api-version")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568661 != nil:
    section.add "api-version", valid_568661
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

proc call*(call_568663: Call_SchedulePatchResource_568654; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_568663.validator(path, query, header, formData, body)
  let scheme = call_568663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568663.url(scheme.get, call_568663.host, call_568663.base,
                         call_568663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568663, url, valid)

proc call*(call_568664: Call_SchedulePatchResource_568654;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## schedulePatchResource
  ## Modify properties of schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  var path_568665 = newJObject()
  var query_568666 = newJObject()
  var body_568667 = newJObject()
  add(path_568665, "resourceGroupName", newJString(resourceGroupName))
  add(query_568666, "api-version", newJString(apiVersion))
  add(path_568665, "name", newJString(name))
  add(path_568665, "subscriptionId", newJString(subscriptionId))
  add(path_568665, "labName", newJString(labName))
  if schedule != nil:
    body_568667 = schedule
  result = call_568664.call(path_568665, query_568666, nil, nil, body_568667)

var schedulePatchResource* = Call_SchedulePatchResource_568654(
    name: "schedulePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulePatchResource_568655, base: "",
    url: url_SchedulePatchResource_568656, schemes: {Scheme.Https})
type
  Call_ScheduleDeleteResource_568642 = ref object of OpenApiRestCall_567650
proc url_ScheduleDeleteResource_568644(protocol: Scheme; host: string; base: string;
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

proc validate_ScheduleDeleteResource_568643(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568645 = path.getOrDefault("resourceGroupName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "resourceGroupName", valid_568645
  var valid_568646 = path.getOrDefault("name")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "name", valid_568646
  var valid_568647 = path.getOrDefault("subscriptionId")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "subscriptionId", valid_568647
  var valid_568648 = path.getOrDefault("labName")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "labName", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568650: Call_ScheduleDeleteResource_568642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule. This operation can take a while to complete.
  ## 
  let valid = call_568650.validator(path, query, header, formData, body)
  let scheme = call_568650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568650.url(scheme.get, call_568650.host, call_568650.base,
                         call_568650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568650, url, valid)

proc call*(call_568651: Call_ScheduleDeleteResource_568642;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleDeleteResource
  ## Delete schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568652 = newJObject()
  var query_568653 = newJObject()
  add(path_568652, "resourceGroupName", newJString(resourceGroupName))
  add(query_568653, "api-version", newJString(apiVersion))
  add(path_568652, "name", newJString(name))
  add(path_568652, "subscriptionId", newJString(subscriptionId))
  add(path_568652, "labName", newJString(labName))
  result = call_568651.call(path_568652, query_568653, nil, nil, nil)

var scheduleDeleteResource* = Call_ScheduleDeleteResource_568642(
    name: "scheduleDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleDeleteResource_568643, base: "",
    url: url_ScheduleDeleteResource_568644, schemes: {Scheme.Https})
type
  Call_ScheduleExecute_568668 = ref object of OpenApiRestCall_567650
proc url_ScheduleExecute_568670(protocol: Scheme; host: string; base: string;
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

proc validate_ScheduleExecute_568669(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568671 = path.getOrDefault("resourceGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "resourceGroupName", valid_568671
  var valid_568672 = path.getOrDefault("name")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "name", valid_568672
  var valid_568673 = path.getOrDefault("subscriptionId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "subscriptionId", valid_568673
  var valid_568674 = path.getOrDefault("labName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "labName", valid_568674
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568675 = query.getOrDefault("api-version")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568675 != nil:
    section.add "api-version", valid_568675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568676: Call_ScheduleExecute_568668; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_568676.validator(path, query, header, formData, body)
  let scheme = call_568676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568676.url(scheme.get, call_568676.host, call_568676.base,
                         call_568676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568676, url, valid)

proc call*(call_568677: Call_ScheduleExecute_568668; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568678 = newJObject()
  var query_568679 = newJObject()
  add(path_568678, "resourceGroupName", newJString(resourceGroupName))
  add(query_568679, "api-version", newJString(apiVersion))
  add(path_568678, "name", newJString(name))
  add(path_568678, "subscriptionId", newJString(subscriptionId))
  add(path_568678, "labName", newJString(labName))
  result = call_568677.call(path_568678, query_568679, nil, nil, nil)

var scheduleExecute* = Call_ScheduleExecute_568668(name: "scheduleExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_ScheduleExecute_568669, base: "", url: url_ScheduleExecute_568670,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineList_568680 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineList_568682(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineList_568681(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568683 = path.getOrDefault("resourceGroupName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "resourceGroupName", valid_568683
  var valid_568684 = path.getOrDefault("subscriptionId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "subscriptionId", valid_568684
  var valid_568685 = path.getOrDefault("labName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "labName", valid_568685
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568686 = query.getOrDefault("api-version")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568686 != nil:
    section.add "api-version", valid_568686
  var valid_568687 = query.getOrDefault("$top")
  valid_568687 = validateParameter(valid_568687, JInt, required = false, default = nil)
  if valid_568687 != nil:
    section.add "$top", valid_568687
  var valid_568688 = query.getOrDefault("$orderBy")
  valid_568688 = validateParameter(valid_568688, JString, required = false,
                                 default = nil)
  if valid_568688 != nil:
    section.add "$orderBy", valid_568688
  var valid_568689 = query.getOrDefault("$filter")
  valid_568689 = validateParameter(valid_568689, JString, required = false,
                                 default = nil)
  if valid_568689 != nil:
    section.add "$filter", valid_568689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568690: Call_VirtualMachineList_568680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines.
  ## 
  let valid = call_568690.validator(path, query, header, formData, body)
  let scheme = call_568690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568690.url(scheme.get, call_568690.host, call_568690.base,
                         call_568690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568690, url, valid)

proc call*(call_568691: Call_VirtualMachineList_568680; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## virtualMachineList
  ## List virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568692 = newJObject()
  var query_568693 = newJObject()
  add(path_568692, "resourceGroupName", newJString(resourceGroupName))
  add(query_568693, "api-version", newJString(apiVersion))
  add(path_568692, "subscriptionId", newJString(subscriptionId))
  add(query_568693, "$top", newJInt(Top))
  add(query_568693, "$orderBy", newJString(OrderBy))
  add(path_568692, "labName", newJString(labName))
  add(query_568693, "$filter", newJString(Filter))
  result = call_568691.call(path_568692, query_568693, nil, nil, nil)

var virtualMachineList* = Call_VirtualMachineList_568680(
    name: "virtualMachineList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachineList_568681, base: "",
    url: url_VirtualMachineList_568682, schemes: {Scheme.Https})
type
  Call_VirtualMachineCreateOrUpdateResource_568706 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineCreateOrUpdateResource_568708(protocol: Scheme;
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

proc validate_VirtualMachineCreateOrUpdateResource_568707(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568709 = path.getOrDefault("resourceGroupName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "resourceGroupName", valid_568709
  var valid_568710 = path.getOrDefault("name")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "name", valid_568710
  var valid_568711 = path.getOrDefault("subscriptionId")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "subscriptionId", valid_568711
  var valid_568712 = path.getOrDefault("labName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "labName", valid_568712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568713 = query.getOrDefault("api-version")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568713 != nil:
    section.add "api-version", valid_568713
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

proc call*(call_568715: Call_VirtualMachineCreateOrUpdateResource_568706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ## 
  let valid = call_568715.validator(path, query, header, formData, body)
  let scheme = call_568715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568715.url(scheme.get, call_568715.host, call_568715.base,
                         call_568715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568715, url, valid)

proc call*(call_568716: Call_VirtualMachineCreateOrUpdateResource_568706;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineCreateOrUpdateResource
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  var path_568717 = newJObject()
  var query_568718 = newJObject()
  var body_568719 = newJObject()
  add(path_568717, "resourceGroupName", newJString(resourceGroupName))
  add(query_568718, "api-version", newJString(apiVersion))
  add(path_568717, "name", newJString(name))
  add(path_568717, "subscriptionId", newJString(subscriptionId))
  add(path_568717, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_568719 = labVirtualMachine
  result = call_568716.call(path_568717, query_568718, nil, nil, body_568719)

var virtualMachineCreateOrUpdateResource* = Call_VirtualMachineCreateOrUpdateResource_568706(
    name: "virtualMachineCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineCreateOrUpdateResource_568707, base: "",
    url: url_VirtualMachineCreateOrUpdateResource_568708, schemes: {Scheme.Https})
type
  Call_VirtualMachineGetResource_568694 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineGetResource_568696(protocol: Scheme; host: string;
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

proc validate_VirtualMachineGetResource_568695(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568697 = path.getOrDefault("resourceGroupName")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "resourceGroupName", valid_568697
  var valid_568698 = path.getOrDefault("name")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "name", valid_568698
  var valid_568699 = path.getOrDefault("subscriptionId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "subscriptionId", valid_568699
  var valid_568700 = path.getOrDefault("labName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "labName", valid_568700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568701 = query.getOrDefault("api-version")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568701 != nil:
    section.add "api-version", valid_568701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_VirtualMachineGetResource_568694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_VirtualMachineGetResource_568694;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineGetResource
  ## Get virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568704 = newJObject()
  var query_568705 = newJObject()
  add(path_568704, "resourceGroupName", newJString(resourceGroupName))
  add(query_568705, "api-version", newJString(apiVersion))
  add(path_568704, "name", newJString(name))
  add(path_568704, "subscriptionId", newJString(subscriptionId))
  add(path_568704, "labName", newJString(labName))
  result = call_568703.call(path_568704, query_568705, nil, nil, nil)

var virtualMachineGetResource* = Call_VirtualMachineGetResource_568694(
    name: "virtualMachineGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineGetResource_568695, base: "",
    url: url_VirtualMachineGetResource_568696, schemes: {Scheme.Https})
type
  Call_VirtualMachinePatchResource_568732 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinePatchResource_568734(protocol: Scheme; host: string;
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

proc validate_VirtualMachinePatchResource_568733(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568735 = path.getOrDefault("resourceGroupName")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "resourceGroupName", valid_568735
  var valid_568736 = path.getOrDefault("name")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "name", valid_568736
  var valid_568737 = path.getOrDefault("subscriptionId")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "subscriptionId", valid_568737
  var valid_568738 = path.getOrDefault("labName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "labName", valid_568738
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568739 = query.getOrDefault("api-version")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568739 != nil:
    section.add "api-version", valid_568739
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

proc call*(call_568741: Call_VirtualMachinePatchResource_568732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual machines.
  ## 
  let valid = call_568741.validator(path, query, header, formData, body)
  let scheme = call_568741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568741.url(scheme.get, call_568741.host, call_568741.base,
                         call_568741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568741, url, valid)

proc call*(call_568742: Call_VirtualMachinePatchResource_568732;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachinePatchResource
  ## Modify properties of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  var path_568743 = newJObject()
  var query_568744 = newJObject()
  var body_568745 = newJObject()
  add(path_568743, "resourceGroupName", newJString(resourceGroupName))
  add(query_568744, "api-version", newJString(apiVersion))
  add(path_568743, "name", newJString(name))
  add(path_568743, "subscriptionId", newJString(subscriptionId))
  add(path_568743, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_568745 = labVirtualMachine
  result = call_568742.call(path_568743, query_568744, nil, nil, body_568745)

var virtualMachinePatchResource* = Call_VirtualMachinePatchResource_568732(
    name: "virtualMachinePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinePatchResource_568733, base: "",
    url: url_VirtualMachinePatchResource_568734, schemes: {Scheme.Https})
type
  Call_VirtualMachineDeleteResource_568720 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineDeleteResource_568722(protocol: Scheme; host: string;
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

proc validate_VirtualMachineDeleteResource_568721(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568723 = path.getOrDefault("resourceGroupName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "resourceGroupName", valid_568723
  var valid_568724 = path.getOrDefault("name")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "name", valid_568724
  var valid_568725 = path.getOrDefault("subscriptionId")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "subscriptionId", valid_568725
  var valid_568726 = path.getOrDefault("labName")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "labName", valid_568726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568727 = query.getOrDefault("api-version")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568727 != nil:
    section.add "api-version", valid_568727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568728: Call_VirtualMachineDeleteResource_568720; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_568728.validator(path, query, header, formData, body)
  let scheme = call_568728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568728.url(scheme.get, call_568728.host, call_568728.base,
                         call_568728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568728, url, valid)

proc call*(call_568729: Call_VirtualMachineDeleteResource_568720;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineDeleteResource
  ## Delete virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568730 = newJObject()
  var query_568731 = newJObject()
  add(path_568730, "resourceGroupName", newJString(resourceGroupName))
  add(query_568731, "api-version", newJString(apiVersion))
  add(path_568730, "name", newJString(name))
  add(path_568730, "subscriptionId", newJString(subscriptionId))
  add(path_568730, "labName", newJString(labName))
  result = call_568729.call(path_568730, query_568731, nil, nil, nil)

var virtualMachineDeleteResource* = Call_VirtualMachineDeleteResource_568720(
    name: "virtualMachineDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineDeleteResource_568721, base: "",
    url: url_VirtualMachineDeleteResource_568722, schemes: {Scheme.Https})
type
  Call_VirtualMachineApplyArtifacts_568746 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineApplyArtifacts_568748(protocol: Scheme; host: string;
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

proc validate_VirtualMachineApplyArtifacts_568747(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568749 = path.getOrDefault("resourceGroupName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "resourceGroupName", valid_568749
  var valid_568750 = path.getOrDefault("name")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "name", valid_568750
  var valid_568751 = path.getOrDefault("subscriptionId")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "subscriptionId", valid_568751
  var valid_568752 = path.getOrDefault("labName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "labName", valid_568752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568753 = query.getOrDefault("api-version")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568753 != nil:
    section.add "api-version", valid_568753
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

proc call*(call_568755: Call_VirtualMachineApplyArtifacts_568746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_568755.validator(path, query, header, formData, body)
  let scheme = call_568755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568755.url(scheme.get, call_568755.host, call_568755.base,
                         call_568755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568755, url, valid)

proc call*(call_568756: Call_VirtualMachineApplyArtifacts_568746;
          resourceGroupName: string; name: string; subscriptionId: string;
          applyArtifactsRequest: JsonNode; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineApplyArtifacts
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   applyArtifactsRequest: JObject (required)
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568757 = newJObject()
  var query_568758 = newJObject()
  var body_568759 = newJObject()
  add(path_568757, "resourceGroupName", newJString(resourceGroupName))
  add(query_568758, "api-version", newJString(apiVersion))
  add(path_568757, "name", newJString(name))
  add(path_568757, "subscriptionId", newJString(subscriptionId))
  if applyArtifactsRequest != nil:
    body_568759 = applyArtifactsRequest
  add(path_568757, "labName", newJString(labName))
  result = call_568756.call(path_568757, query_568758, nil, nil, body_568759)

var virtualMachineApplyArtifacts* = Call_VirtualMachineApplyArtifacts_568746(
    name: "virtualMachineApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachineApplyArtifacts_568747, base: "",
    url: url_VirtualMachineApplyArtifacts_568748, schemes: {Scheme.Https})
type
  Call_VirtualMachineStart_568760 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineStart_568762(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineStart_568761(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Start a Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568763 = path.getOrDefault("resourceGroupName")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "resourceGroupName", valid_568763
  var valid_568764 = path.getOrDefault("name")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "name", valid_568764
  var valid_568765 = path.getOrDefault("subscriptionId")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "subscriptionId", valid_568765
  var valid_568766 = path.getOrDefault("labName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "labName", valid_568766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568767 = query.getOrDefault("api-version")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568767 != nil:
    section.add "api-version", valid_568767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568768: Call_VirtualMachineStart_568760; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_568768.validator(path, query, header, formData, body)
  let scheme = call_568768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568768.url(scheme.get, call_568768.host, call_568768.base,
                         call_568768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568768, url, valid)

proc call*(call_568769: Call_VirtualMachineStart_568760; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineStart
  ## Start a Lab VM. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568770 = newJObject()
  var query_568771 = newJObject()
  add(path_568770, "resourceGroupName", newJString(resourceGroupName))
  add(query_568771, "api-version", newJString(apiVersion))
  add(path_568770, "name", newJString(name))
  add(path_568770, "subscriptionId", newJString(subscriptionId))
  add(path_568770, "labName", newJString(labName))
  result = call_568769.call(path_568770, query_568771, nil, nil, nil)

var virtualMachineStart* = Call_VirtualMachineStart_568760(
    name: "virtualMachineStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachineStart_568761, base: "",
    url: url_VirtualMachineStart_568762, schemes: {Scheme.Https})
type
  Call_VirtualMachineStop_568772 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineStop_568774(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineStop_568773(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stop a Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568775 = path.getOrDefault("resourceGroupName")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "resourceGroupName", valid_568775
  var valid_568776 = path.getOrDefault("name")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "name", valid_568776
  var valid_568777 = path.getOrDefault("subscriptionId")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "subscriptionId", valid_568777
  var valid_568778 = path.getOrDefault("labName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "labName", valid_568778
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568779 = query.getOrDefault("api-version")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568779 != nil:
    section.add "api-version", valid_568779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568780: Call_VirtualMachineStop_568772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_568780.validator(path, query, header, formData, body)
  let scheme = call_568780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568780.url(scheme.get, call_568780.host, call_568780.base,
                         call_568780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568780, url, valid)

proc call*(call_568781: Call_VirtualMachineStop_568772; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineStop
  ## Stop a Lab VM. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568782 = newJObject()
  var query_568783 = newJObject()
  add(path_568782, "resourceGroupName", newJString(resourceGroupName))
  add(query_568783, "api-version", newJString(apiVersion))
  add(path_568782, "name", newJString(name))
  add(path_568782, "subscriptionId", newJString(subscriptionId))
  add(path_568782, "labName", newJString(labName))
  result = call_568781.call(path_568782, query_568783, nil, nil, nil)

var virtualMachineStop* = Call_VirtualMachineStop_568772(
    name: "virtualMachineStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachineStop_568773, base: "",
    url: url_VirtualMachineStop_568774, schemes: {Scheme.Https})
type
  Call_VirtualNetworkList_568784 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkList_568786(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkList_568785(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568787 = path.getOrDefault("resourceGroupName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "resourceGroupName", valid_568787
  var valid_568788 = path.getOrDefault("subscriptionId")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "subscriptionId", valid_568788
  var valid_568789 = path.getOrDefault("labName")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "labName", valid_568789
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568790 = query.getOrDefault("api-version")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568790 != nil:
    section.add "api-version", valid_568790
  var valid_568791 = query.getOrDefault("$top")
  valid_568791 = validateParameter(valid_568791, JInt, required = false, default = nil)
  if valid_568791 != nil:
    section.add "$top", valid_568791
  var valid_568792 = query.getOrDefault("$orderBy")
  valid_568792 = validateParameter(valid_568792, JString, required = false,
                                 default = nil)
  if valid_568792 != nil:
    section.add "$orderBy", valid_568792
  var valid_568793 = query.getOrDefault("$filter")
  valid_568793 = validateParameter(valid_568793, JString, required = false,
                                 default = nil)
  if valid_568793 != nil:
    section.add "$filter", valid_568793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568794: Call_VirtualNetworkList_568784; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks.
  ## 
  let valid = call_568794.validator(path, query, header, formData, body)
  let scheme = call_568794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568794.url(scheme.get, call_568794.host, call_568794.base,
                         call_568794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568794, url, valid)

proc call*(call_568795: Call_VirtualNetworkList_568784; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## virtualNetworkList
  ## List virtual networks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568796 = newJObject()
  var query_568797 = newJObject()
  add(path_568796, "resourceGroupName", newJString(resourceGroupName))
  add(query_568797, "api-version", newJString(apiVersion))
  add(path_568796, "subscriptionId", newJString(subscriptionId))
  add(query_568797, "$top", newJInt(Top))
  add(query_568797, "$orderBy", newJString(OrderBy))
  add(path_568796, "labName", newJString(labName))
  add(query_568797, "$filter", newJString(Filter))
  result = call_568795.call(path_568796, query_568797, nil, nil, nil)

var virtualNetworkList* = Call_VirtualNetworkList_568784(
    name: "virtualNetworkList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworkList_568785, base: "",
    url: url_VirtualNetworkList_568786, schemes: {Scheme.Https})
type
  Call_VirtualNetworkCreateOrUpdateResource_568810 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkCreateOrUpdateResource_568812(protocol: Scheme;
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

proc validate_VirtualNetworkCreateOrUpdateResource_568811(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568813 = path.getOrDefault("resourceGroupName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "resourceGroupName", valid_568813
  var valid_568814 = path.getOrDefault("name")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "name", valid_568814
  var valid_568815 = path.getOrDefault("subscriptionId")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "subscriptionId", valid_568815
  var valid_568816 = path.getOrDefault("labName")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "labName", valid_568816
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568817 = query.getOrDefault("api-version")
  valid_568817 = validateParameter(valid_568817, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568817 != nil:
    section.add "api-version", valid_568817
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

proc call*(call_568819: Call_VirtualNetworkCreateOrUpdateResource_568810;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_568819.validator(path, query, header, formData, body)
  let scheme = call_568819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568819.url(scheme.get, call_568819.host, call_568819.base,
                         call_568819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568819, url, valid)

proc call*(call_568820: Call_VirtualNetworkCreateOrUpdateResource_568810;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkCreateOrUpdateResource
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  var path_568821 = newJObject()
  var query_568822 = newJObject()
  var body_568823 = newJObject()
  add(path_568821, "resourceGroupName", newJString(resourceGroupName))
  add(query_568822, "api-version", newJString(apiVersion))
  add(path_568821, "name", newJString(name))
  add(path_568821, "subscriptionId", newJString(subscriptionId))
  add(path_568821, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_568823 = virtualNetwork
  result = call_568820.call(path_568821, query_568822, nil, nil, body_568823)

var virtualNetworkCreateOrUpdateResource* = Call_VirtualNetworkCreateOrUpdateResource_568810(
    name: "virtualNetworkCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkCreateOrUpdateResource_568811, base: "",
    url: url_VirtualNetworkCreateOrUpdateResource_568812, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGetResource_568798 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGetResource_568800(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGetResource_568799(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568801 = path.getOrDefault("resourceGroupName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "resourceGroupName", valid_568801
  var valid_568802 = path.getOrDefault("name")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "name", valid_568802
  var valid_568803 = path.getOrDefault("subscriptionId")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "subscriptionId", valid_568803
  var valid_568804 = path.getOrDefault("labName")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "labName", valid_568804
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568805 = query.getOrDefault("api-version")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568805 != nil:
    section.add "api-version", valid_568805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568806: Call_VirtualNetworkGetResource_568798; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_568806.validator(path, query, header, formData, body)
  let scheme = call_568806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568806.url(scheme.get, call_568806.host, call_568806.base,
                         call_568806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568806, url, valid)

proc call*(call_568807: Call_VirtualNetworkGetResource_568798;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkGetResource
  ## Get virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568808 = newJObject()
  var query_568809 = newJObject()
  add(path_568808, "resourceGroupName", newJString(resourceGroupName))
  add(query_568809, "api-version", newJString(apiVersion))
  add(path_568808, "name", newJString(name))
  add(path_568808, "subscriptionId", newJString(subscriptionId))
  add(path_568808, "labName", newJString(labName))
  result = call_568807.call(path_568808, query_568809, nil, nil, nil)

var virtualNetworkGetResource* = Call_VirtualNetworkGetResource_568798(
    name: "virtualNetworkGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkGetResource_568799, base: "",
    url: url_VirtualNetworkGetResource_568800, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPatchResource_568836 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkPatchResource_568838(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPatchResource_568837(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568839 = path.getOrDefault("resourceGroupName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "resourceGroupName", valid_568839
  var valid_568840 = path.getOrDefault("name")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "name", valid_568840
  var valid_568841 = path.getOrDefault("subscriptionId")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "subscriptionId", valid_568841
  var valid_568842 = path.getOrDefault("labName")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "labName", valid_568842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568843 = query.getOrDefault("api-version")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568843 != nil:
    section.add "api-version", valid_568843
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

proc call*(call_568845: Call_VirtualNetworkPatchResource_568836; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual networks.
  ## 
  let valid = call_568845.validator(path, query, header, formData, body)
  let scheme = call_568845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568845.url(scheme.get, call_568845.host, call_568845.base,
                         call_568845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568845, url, valid)

proc call*(call_568846: Call_VirtualNetworkPatchResource_568836;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkPatchResource
  ## Modify properties of virtual networks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  var path_568847 = newJObject()
  var query_568848 = newJObject()
  var body_568849 = newJObject()
  add(path_568847, "resourceGroupName", newJString(resourceGroupName))
  add(query_568848, "api-version", newJString(apiVersion))
  add(path_568847, "name", newJString(name))
  add(path_568847, "subscriptionId", newJString(subscriptionId))
  add(path_568847, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_568849 = virtualNetwork
  result = call_568846.call(path_568847, query_568848, nil, nil, body_568849)

var virtualNetworkPatchResource* = Call_VirtualNetworkPatchResource_568836(
    name: "virtualNetworkPatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkPatchResource_568837, base: "",
    url: url_VirtualNetworkPatchResource_568838, schemes: {Scheme.Https})
type
  Call_VirtualNetworkDeleteResource_568824 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkDeleteResource_568826(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkDeleteResource_568825(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568827 = path.getOrDefault("resourceGroupName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "resourceGroupName", valid_568827
  var valid_568828 = path.getOrDefault("name")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "name", valid_568828
  var valid_568829 = path.getOrDefault("subscriptionId")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "subscriptionId", valid_568829
  var valid_568830 = path.getOrDefault("labName")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "labName", valid_568830
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568831 = query.getOrDefault("api-version")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568831 != nil:
    section.add "api-version", valid_568831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568832: Call_VirtualNetworkDeleteResource_568824; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_568832.validator(path, query, header, formData, body)
  let scheme = call_568832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568832.url(scheme.get, call_568832.host, call_568832.base,
                         call_568832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568832, url, valid)

proc call*(call_568833: Call_VirtualNetworkDeleteResource_568824;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkDeleteResource
  ## Delete virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568834 = newJObject()
  var query_568835 = newJObject()
  add(path_568834, "resourceGroupName", newJString(resourceGroupName))
  add(query_568835, "api-version", newJString(apiVersion))
  add(path_568834, "name", newJString(name))
  add(path_568834, "subscriptionId", newJString(subscriptionId))
  add(path_568834, "labName", newJString(labName))
  result = call_568833.call(path_568834, query_568835, nil, nil, nil)

var virtualNetworkDeleteResource* = Call_VirtualNetworkDeleteResource_568824(
    name: "virtualNetworkDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkDeleteResource_568825, base: "",
    url: url_VirtualNetworkDeleteResource_568826, schemes: {Scheme.Https})
type
  Call_LabCreateOrUpdateResource_568861 = ref object of OpenApiRestCall_567650
proc url_LabCreateOrUpdateResource_568863(protocol: Scheme; host: string;
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

proc validate_LabCreateOrUpdateResource_568862(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568864 = path.getOrDefault("resourceGroupName")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "resourceGroupName", valid_568864
  var valid_568865 = path.getOrDefault("name")
  valid_568865 = validateParameter(valid_568865, JString, required = true,
                                 default = nil)
  if valid_568865 != nil:
    section.add "name", valid_568865
  var valid_568866 = path.getOrDefault("subscriptionId")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "subscriptionId", valid_568866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568867 = query.getOrDefault("api-version")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568867 != nil:
    section.add "api-version", valid_568867
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

proc call*(call_568869: Call_LabCreateOrUpdateResource_568861; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ## 
  let valid = call_568869.validator(path, query, header, formData, body)
  let scheme = call_568869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568869.url(scheme.get, call_568869.host, call_568869.base,
                         call_568869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568869, url, valid)

proc call*(call_568870: Call_LabCreateOrUpdateResource_568861;
          resourceGroupName: string; name: string; subscriptionId: string;
          lab: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labCreateOrUpdateResource
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  var path_568871 = newJObject()
  var query_568872 = newJObject()
  var body_568873 = newJObject()
  add(path_568871, "resourceGroupName", newJString(resourceGroupName))
  add(query_568872, "api-version", newJString(apiVersion))
  add(path_568871, "name", newJString(name))
  add(path_568871, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_568873 = lab
  result = call_568870.call(path_568871, query_568872, nil, nil, body_568873)

var labCreateOrUpdateResource* = Call_LabCreateOrUpdateResource_568861(
    name: "labCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabCreateOrUpdateResource_568862, base: "",
    url: url_LabCreateOrUpdateResource_568863, schemes: {Scheme.Https})
type
  Call_LabGetResource_568850 = ref object of OpenApiRestCall_567650
proc url_LabGetResource_568852(protocol: Scheme; host: string; base: string;
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

proc validate_LabGetResource_568851(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568853 = path.getOrDefault("resourceGroupName")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "resourceGroupName", valid_568853
  var valid_568854 = path.getOrDefault("name")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "name", valid_568854
  var valid_568855 = path.getOrDefault("subscriptionId")
  valid_568855 = validateParameter(valid_568855, JString, required = true,
                                 default = nil)
  if valid_568855 != nil:
    section.add "subscriptionId", valid_568855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568856 = query.getOrDefault("api-version")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568856 != nil:
    section.add "api-version", valid_568856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568857: Call_LabGetResource_568850; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_568857.validator(path, query, header, formData, body)
  let scheme = call_568857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568857.url(scheme.get, call_568857.host, call_568857.base,
                         call_568857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568857, url, valid)

proc call*(call_568858: Call_LabGetResource_568850; resourceGroupName: string;
          name: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labGetResource
  ## Get lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568859 = newJObject()
  var query_568860 = newJObject()
  add(path_568859, "resourceGroupName", newJString(resourceGroupName))
  add(query_568860, "api-version", newJString(apiVersion))
  add(path_568859, "name", newJString(name))
  add(path_568859, "subscriptionId", newJString(subscriptionId))
  result = call_568858.call(path_568859, query_568860, nil, nil, nil)

var labGetResource* = Call_LabGetResource_568850(name: "labGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabGetResource_568851, base: "", url: url_LabGetResource_568852,
    schemes: {Scheme.Https})
type
  Call_LabPatchResource_568885 = ref object of OpenApiRestCall_567650
proc url_LabPatchResource_568887(protocol: Scheme; host: string; base: string;
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

proc validate_LabPatchResource_568886(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568888 = path.getOrDefault("resourceGroupName")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "resourceGroupName", valid_568888
  var valid_568889 = path.getOrDefault("name")
  valid_568889 = validateParameter(valid_568889, JString, required = true,
                                 default = nil)
  if valid_568889 != nil:
    section.add "name", valid_568889
  var valid_568890 = path.getOrDefault("subscriptionId")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "subscriptionId", valid_568890
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568891 = query.getOrDefault("api-version")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568891 != nil:
    section.add "api-version", valid_568891
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

proc call*(call_568893: Call_LabPatchResource_568885; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_568893.validator(path, query, header, formData, body)
  let scheme = call_568893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568893.url(scheme.get, call_568893.host, call_568893.base,
                         call_568893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568893, url, valid)

proc call*(call_568894: Call_LabPatchResource_568885; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labPatchResource
  ## Modify properties of labs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  var path_568895 = newJObject()
  var query_568896 = newJObject()
  var body_568897 = newJObject()
  add(path_568895, "resourceGroupName", newJString(resourceGroupName))
  add(query_568896, "api-version", newJString(apiVersion))
  add(path_568895, "name", newJString(name))
  add(path_568895, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_568897 = lab
  result = call_568894.call(path_568895, query_568896, nil, nil, body_568897)

var labPatchResource* = Call_LabPatchResource_568885(name: "labPatchResource",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabPatchResource_568886, base: "",
    url: url_LabPatchResource_568887, schemes: {Scheme.Https})
type
  Call_LabDeleteResource_568874 = ref object of OpenApiRestCall_567650
proc url_LabDeleteResource_568876(protocol: Scheme; host: string; base: string;
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

proc validate_LabDeleteResource_568875(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568877 = path.getOrDefault("resourceGroupName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "resourceGroupName", valid_568877
  var valid_568878 = path.getOrDefault("name")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "name", valid_568878
  var valid_568879 = path.getOrDefault("subscriptionId")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "subscriptionId", valid_568879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568880 = query.getOrDefault("api-version")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568880 != nil:
    section.add "api-version", valid_568880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568881: Call_LabDeleteResource_568874; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_568881.validator(path, query, header, formData, body)
  let scheme = call_568881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568881.url(scheme.get, call_568881.host, call_568881.base,
                         call_568881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568881, url, valid)

proc call*(call_568882: Call_LabDeleteResource_568874; resourceGroupName: string;
          name: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labDeleteResource
  ## Delete lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568883 = newJObject()
  var query_568884 = newJObject()
  add(path_568883, "resourceGroupName", newJString(resourceGroupName))
  add(query_568884, "api-version", newJString(apiVersion))
  add(path_568883, "name", newJString(name))
  add(path_568883, "subscriptionId", newJString(subscriptionId))
  result = call_568882.call(path_568883, query_568884, nil, nil, nil)

var labDeleteResource* = Call_LabDeleteResource_568874(name: "labDeleteResource",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabDeleteResource_568875, base: "",
    url: url_LabDeleteResource_568876, schemes: {Scheme.Https})
type
  Call_LabCreateEnvironment_568898 = ref object of OpenApiRestCall_567650
proc url_LabCreateEnvironment_568900(protocol: Scheme; host: string; base: string;
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

proc validate_LabCreateEnvironment_568899(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568901 = path.getOrDefault("resourceGroupName")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "resourceGroupName", valid_568901
  var valid_568902 = path.getOrDefault("name")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "name", valid_568902
  var valid_568903 = path.getOrDefault("subscriptionId")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "subscriptionId", valid_568903
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568904 = query.getOrDefault("api-version")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568904 != nil:
    section.add "api-version", valid_568904
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

proc call*(call_568906: Call_LabCreateEnvironment_568898; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ## 
  let valid = call_568906.validator(path, query, header, formData, body)
  let scheme = call_568906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568906.url(scheme.get, call_568906.host, call_568906.base,
                         call_568906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568906, url, valid)

proc call*(call_568907: Call_LabCreateEnvironment_568898;
          resourceGroupName: string; name: string; subscriptionId: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labCreateEnvironment
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labVirtualMachine: JObject (required)
  var path_568908 = newJObject()
  var query_568909 = newJObject()
  var body_568910 = newJObject()
  add(path_568908, "resourceGroupName", newJString(resourceGroupName))
  add(query_568909, "api-version", newJString(apiVersion))
  add(path_568908, "name", newJString(name))
  add(path_568908, "subscriptionId", newJString(subscriptionId))
  if labVirtualMachine != nil:
    body_568910 = labVirtualMachine
  result = call_568907.call(path_568908, query_568909, nil, nil, body_568910)

var labCreateEnvironment* = Call_LabCreateEnvironment_568898(
    name: "labCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabCreateEnvironment_568899, base: "",
    url: url_LabCreateEnvironment_568900, schemes: {Scheme.Https})
type
  Call_LabGenerateUploadUri_568911 = ref object of OpenApiRestCall_567650
proc url_LabGenerateUploadUri_568913(protocol: Scheme; host: string; base: string;
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

proc validate_LabGenerateUploadUri_568912(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568914 = path.getOrDefault("resourceGroupName")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "resourceGroupName", valid_568914
  var valid_568915 = path.getOrDefault("name")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "name", valid_568915
  var valid_568916 = path.getOrDefault("subscriptionId")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "subscriptionId", valid_568916
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568917 = query.getOrDefault("api-version")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568917 != nil:
    section.add "api-version", valid_568917
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

proc call*(call_568919: Call_LabGenerateUploadUri_568911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_568919.validator(path, query, header, formData, body)
  let scheme = call_568919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568919.url(scheme.get, call_568919.host, call_568919.base,
                         call_568919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568919, url, valid)

proc call*(call_568920: Call_LabGenerateUploadUri_568911;
          resourceGroupName: string; name: string; subscriptionId: string;
          generateUploadUriParameter: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labGenerateUploadUri
  ## Generate a URI for uploading custom disk images to a Lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   generateUploadUriParameter: JObject (required)
  var path_568921 = newJObject()
  var query_568922 = newJObject()
  var body_568923 = newJObject()
  add(path_568921, "resourceGroupName", newJString(resourceGroupName))
  add(query_568922, "api-version", newJString(apiVersion))
  add(path_568921, "name", newJString(name))
  add(path_568921, "subscriptionId", newJString(subscriptionId))
  if generateUploadUriParameter != nil:
    body_568923 = generateUploadUriParameter
  result = call_568920.call(path_568921, query_568922, nil, nil, body_568923)

var labGenerateUploadUri* = Call_LabGenerateUploadUri_568911(
    name: "labGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabGenerateUploadUri_568912, base: "",
    url: url_LabGenerateUploadUri_568913, schemes: {Scheme.Https})
type
  Call_LabListVhds_568924 = ref object of OpenApiRestCall_567650
proc url_LabListVhds_568926(protocol: Scheme; host: string; base: string;
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

proc validate_LabListVhds_568925(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List disk images available for custom image creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568927 = path.getOrDefault("resourceGroupName")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "resourceGroupName", valid_568927
  var valid_568928 = path.getOrDefault("name")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "name", valid_568928
  var valid_568929 = path.getOrDefault("subscriptionId")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "subscriptionId", valid_568929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568930 = query.getOrDefault("api-version")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_568930 != nil:
    section.add "api-version", valid_568930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568931: Call_LabListVhds_568924; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_568931.validator(path, query, header, formData, body)
  let scheme = call_568931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568931.url(scheme.get, call_568931.host, call_568931.base,
                         call_568931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568931, url, valid)

proc call*(call_568932: Call_LabListVhds_568924; resourceGroupName: string;
          name: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labListVhds
  ## List disk images available for custom image creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568933 = newJObject()
  var query_568934 = newJObject()
  add(path_568933, "resourceGroupName", newJString(resourceGroupName))
  add(query_568934, "api-version", newJString(apiVersion))
  add(path_568933, "name", newJString(name))
  add(path_568933, "subscriptionId", newJString(subscriptionId))
  result = call_568932.call(path_568933, query_568934, nil, nil, nil)

var labListVhds* = Call_LabListVhds_568924(name: "labListVhds",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
                                        validator: validate_LabListVhds_568925,
                                        base: "", url: url_LabListVhds_568926,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
