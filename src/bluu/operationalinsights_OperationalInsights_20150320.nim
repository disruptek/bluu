
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Log Analytics
## version: 2015-03-20
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Log Analytics API reference for LinkTargets, StorageInsightConfigs and SavedSearches.
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "operationalinsights-OperationalInsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available OperationalInsights Rest API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available OperationalInsights Rest API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available OperationalInsights Rest API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.OperationalInsights/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_WorkspacesListLinkTargets_568176 = ref object of OpenApiRestCall_567658
proc url_WorkspacesListLinkTargets_568178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/linkTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListLinkTargets_568177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of workspaces which the current user has administrator privileges and are not associated with an Azure Subscription. The subscriptionId parameter in the Url is ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_WorkspacesListLinkTargets_568176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of workspaces which the current user has administrator privileges and are not associated with an Azure Subscription. The subscriptionId parameter in the Url is ignored.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_WorkspacesListLinkTargets_568176; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workspacesListLinkTargets
  ## Get a list of workspaces which the current user has administrator privileges and are not associated with an Azure Subscription. The subscriptionId parameter in the Url is ignored.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var workspacesListLinkTargets* = Call_WorkspacesListLinkTargets_568176(
    name: "workspacesListLinkTargets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.OperationalInsights/linkTargets",
    validator: validate_WorkspacesListLinkTargets_568177, base: "",
    url: url_WorkspacesListLinkTargets_568178, schemes: {Scheme.Https})
type
  Call_WorkspacesGetPurgeStatus_568199 = ref object of OpenApiRestCall_567658
proc url_WorkspacesGetPurgeStatus_568201(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "purgeId" in path, "`purgeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "purgeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGetPurgeStatus_568200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets status of an ongoing purge operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   purgeId: JString (required)
  ##          : In a purge status request, this is the Id of the operation the status of which is returned.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568202 = path.getOrDefault("resourceGroupName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "resourceGroupName", valid_568202
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  var valid_568204 = path.getOrDefault("purgeId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "purgeId", valid_568204
  var valid_568205 = path.getOrDefault("workspaceName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "workspaceName", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_WorkspacesGetPurgeStatus_568199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets status of an ongoing purge operation.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_WorkspacesGetPurgeStatus_568199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          purgeId: string; workspaceName: string): Recallable =
  ## workspacesGetPurgeStatus
  ## Gets status of an ongoing purge operation.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   purgeId: string (required)
  ##          : In a purge status request, this is the Id of the operation the status of which is returned.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(path_568209, "resourceGroupName", newJString(resourceGroupName))
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  add(path_568209, "purgeId", newJString(purgeId))
  add(path_568209, "workspaceName", newJString(workspaceName))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var workspacesGetPurgeStatus* = Call_WorkspacesGetPurgeStatus_568199(
    name: "workspacesGetPurgeStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/operations/{purgeId}",
    validator: validate_WorkspacesGetPurgeStatus_568200, base: "",
    url: url_WorkspacesGetPurgeStatus_568201, schemes: {Scheme.Https})
type
  Call_WorkspacesPurge_568211 = ref object of OpenApiRestCall_567658
proc url_WorkspacesPurge_568213(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesPurge_568212(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Purges data in an Log Analytics workspace by a set of user-defined filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
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
  var valid_568233 = path.getOrDefault("workspaceName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "workspaceName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Describes the body of a request to purge data in a single table of an Log Analytics Workspace
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_WorkspacesPurge_568211; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Purges data in an Log Analytics workspace by a set of user-defined filters.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_WorkspacesPurge_568211; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; body: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesPurge
  ## Purges data in an Log Analytics workspace by a set of user-defined filters.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   body: JObject (required)
  ##       : Describes the body of a request to purge data in a single table of an Log Analytics Workspace
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  var body_568240 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568240 = body
  add(path_568238, "workspaceName", newJString(workspaceName))
  result = call_568237.call(path_568238, query_568239, nil, nil, body_568240)

var workspacesPurge* = Call_WorkspacesPurge_568211(name: "workspacesPurge",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/purge",
    validator: validate_WorkspacesPurge_568212, base: "", url: url_WorkspacesPurge_568213,
    schemes: {Scheme.Https})
type
  Call_WorkspacesDeleteGateways_568241 = ref object of OpenApiRestCall_567658
proc url_WorkspacesDeleteGateways_568243(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "gatewayId" in path, "`gatewayId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/gateways/"),
               (kind: VariableSegment, value: "gatewayId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDeleteGateways_568242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Log Analytics gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   gatewayId: JString (required)
  ##            : The Log Analytics gateway Id.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568244 = path.getOrDefault("resourceGroupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceGroupName", valid_568244
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  var valid_568246 = path.getOrDefault("gatewayId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "gatewayId", valid_568246
  var valid_568247 = path.getOrDefault("workspaceName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "workspaceName", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_WorkspacesDeleteGateways_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Log Analytics gateway.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_WorkspacesDeleteGateways_568241;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          gatewayId: string; workspaceName: string): Recallable =
  ## workspacesDeleteGateways
  ## Delete a Log Analytics gateway.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   gatewayId: string (required)
  ##            : The Log Analytics gateway Id.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "gatewayId", newJString(gatewayId))
  add(path_568251, "workspaceName", newJString(workspaceName))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var workspacesDeleteGateways* = Call_WorkspacesDeleteGateways_568241(
    name: "workspacesDeleteGateways", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/gateways/{gatewayId}",
    validator: validate_WorkspacesDeleteGateways_568242, base: "",
    url: url_WorkspacesDeleteGateways_568243, schemes: {Scheme.Https})
type
  Call_WorkspacesListKeys_568253 = ref object of OpenApiRestCall_567658
proc url_WorkspacesListKeys_568255(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListKeys_568254(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  var valid_568258 = path.getOrDefault("workspaceName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "workspaceName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_WorkspacesListKeys_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_WorkspacesListKeys_568253; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesListKeys
  ## Gets the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  add(path_568262, "workspaceName", newJString(workspaceName))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var workspacesListKeys* = Call_WorkspacesListKeys_568253(
    name: "workspacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/listKeys",
    validator: validate_WorkspacesListKeys_568254, base: "",
    url: url_WorkspacesListKeys_568255, schemes: {Scheme.Https})
type
  Call_WorkspacesRegenerateSharedKeys_568264 = ref object of OpenApiRestCall_567658
proc url_WorkspacesRegenerateSharedKeys_568266(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/regenerateSharedKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesRegenerateSharedKeys_568265(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  var valid_568269 = path.getOrDefault("workspaceName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "workspaceName", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_WorkspacesRegenerateSharedKeys_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_WorkspacesRegenerateSharedKeys_568264;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesRegenerateSharedKeys
  ## Regenerates the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(path_568273, "workspaceName", newJString(workspaceName))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var workspacesRegenerateSharedKeys* = Call_WorkspacesRegenerateSharedKeys_568264(
    name: "workspacesRegenerateSharedKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/regenerateSharedKey",
    validator: validate_WorkspacesRegenerateSharedKeys_568265, base: "",
    url: url_WorkspacesRegenerateSharedKeys_568266, schemes: {Scheme.Https})
type
  Call_SavedSearchesListByWorkspace_568275 = ref object of OpenApiRestCall_567658
proc url_SavedSearchesListByWorkspace_568277(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/savedSearches")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SavedSearchesListByWorkspace_568276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the saved searches for a given Log Analytics Workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  var valid_568280 = path.getOrDefault("workspaceName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "workspaceName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_SavedSearchesListByWorkspace_568275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the saved searches for a given Log Analytics Workspace
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_SavedSearchesListByWorkspace_568275;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## savedSearchesListByWorkspace
  ## Gets the saved searches for a given Log Analytics Workspace
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(path_568284, "workspaceName", newJString(workspaceName))
  result = call_568283.call(path_568284, query_568285, nil, nil, nil)

var savedSearchesListByWorkspace* = Call_SavedSearchesListByWorkspace_568275(
    name: "savedSearchesListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches",
    validator: validate_SavedSearchesListByWorkspace_568276, base: "",
    url: url_SavedSearchesListByWorkspace_568277, schemes: {Scheme.Https})
type
  Call_SavedSearchesCreateOrUpdate_568298 = ref object of OpenApiRestCall_567658
proc url_SavedSearchesCreateOrUpdate_568300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "savedSearchId" in path, "`savedSearchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/savedSearches/"),
               (kind: VariableSegment, value: "savedSearchId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SavedSearchesCreateOrUpdate_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a saved search for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("savedSearchId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "savedSearchId", valid_568303
  var valid_568304 = path.getOrDefault("workspaceName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "workspaceName", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to save a search.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_SavedSearchesCreateOrUpdate_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a saved search for a given workspace.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_SavedSearchesCreateOrUpdate_568298;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          savedSearchId: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## savedSearchesCreateOrUpdate
  ## Creates or updates a saved search for a given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   parameters: JObject (required)
  ##             : The parameters required to save a search.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  var body_568311 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  add(path_568309, "savedSearchId", newJString(savedSearchId))
  if parameters != nil:
    body_568311 = parameters
  add(path_568309, "workspaceName", newJString(workspaceName))
  result = call_568308.call(path_568309, query_568310, nil, nil, body_568311)

var savedSearchesCreateOrUpdate* = Call_SavedSearchesCreateOrUpdate_568298(
    name: "savedSearchesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}",
    validator: validate_SavedSearchesCreateOrUpdate_568299, base: "",
    url: url_SavedSearchesCreateOrUpdate_568300, schemes: {Scheme.Https})
type
  Call_SavedSearchesGet_568286 = ref object of OpenApiRestCall_567658
proc url_SavedSearchesGet_568288(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "savedSearchId" in path, "`savedSearchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/savedSearches/"),
               (kind: VariableSegment, value: "savedSearchId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SavedSearchesGet_568287(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified saved search for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568289 = path.getOrDefault("resourceGroupName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "resourceGroupName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("savedSearchId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "savedSearchId", valid_568291
  var valid_568292 = path.getOrDefault("workspaceName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "workspaceName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_SavedSearchesGet_568286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified saved search for a given workspace.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_SavedSearchesGet_568286; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; savedSearchId: string;
          workspaceName: string): Recallable =
  ## savedSearchesGet
  ## Gets the specified saved search for a given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "savedSearchId", newJString(savedSearchId))
  add(path_568296, "workspaceName", newJString(workspaceName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var savedSearchesGet* = Call_SavedSearchesGet_568286(name: "savedSearchesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}",
    validator: validate_SavedSearchesGet_568287, base: "",
    url: url_SavedSearchesGet_568288, schemes: {Scheme.Https})
type
  Call_SavedSearchesDelete_568312 = ref object of OpenApiRestCall_567658
proc url_SavedSearchesDelete_568314(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "savedSearchId" in path, "`savedSearchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/savedSearches/"),
               (kind: VariableSegment, value: "savedSearchId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SavedSearchesDelete_568313(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified saved search in a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568315 = path.getOrDefault("resourceGroupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceGroupName", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  var valid_568317 = path.getOrDefault("savedSearchId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "savedSearchId", valid_568317
  var valid_568318 = path.getOrDefault("workspaceName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "workspaceName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_SavedSearchesDelete_568312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified saved search in a given workspace.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_SavedSearchesDelete_568312; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; savedSearchId: string;
          workspaceName: string): Recallable =
  ## savedSearchesDelete
  ## Deletes the specified saved search in a given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "savedSearchId", newJString(savedSearchId))
  add(path_568322, "workspaceName", newJString(workspaceName))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var savedSearchesDelete* = Call_SavedSearchesDelete_568312(
    name: "savedSearchesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}",
    validator: validate_SavedSearchesDelete_568313, base: "",
    url: url_SavedSearchesDelete_568314, schemes: {Scheme.Https})
type
  Call_SavedSearchesGetResults_568324 = ref object of OpenApiRestCall_567658
proc url_SavedSearchesGetResults_568326(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "savedSearchId" in path, "`savedSearchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/savedSearches/"),
               (kind: VariableSegment, value: "savedSearchId"),
               (kind: ConstantSegment, value: "/results")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SavedSearchesGetResults_568325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the results from a saved search for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("savedSearchId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "savedSearchId", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("workspaceName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "workspaceName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_SavedSearchesGetResults_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the results from a saved search for a given workspace.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_SavedSearchesGetResults_568324;
          resourceGroupName: string; apiVersion: string; savedSearchId: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## savedSearchesGetResults
  ## Gets the results from a saved search for a given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "savedSearchId", newJString(savedSearchId))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "workspaceName", newJString(workspaceName))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var savedSearchesGetResults* = Call_SavedSearchesGetResults_568324(
    name: "savedSearchesGetResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}/results",
    validator: validate_SavedSearchesGetResults_568325, base: "",
    url: url_SavedSearchesGetResults_568326, schemes: {Scheme.Https})
type
  Call_WorkspacesGetSchema_568336 = ref object of OpenApiRestCall_567658
proc url_WorkspacesGetSchema_568338(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/schema")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGetSchema_568337(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the schema for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568339 = path.getOrDefault("resourceGroupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "resourceGroupName", valid_568339
  var valid_568340 = path.getOrDefault("subscriptionId")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "subscriptionId", valid_568340
  var valid_568341 = path.getOrDefault("workspaceName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "workspaceName", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_WorkspacesGetSchema_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the schema for a given workspace.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_WorkspacesGetSchema_568336; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGetSchema
  ## Gets the schema for a given workspace.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  add(path_568345, "workspaceName", newJString(workspaceName))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var workspacesGetSchema* = Call_WorkspacesGetSchema_568336(
    name: "workspacesGetSchema", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/schema",
    validator: validate_WorkspacesGetSchema_568337, base: "",
    url: url_WorkspacesGetSchema_568338, schemes: {Scheme.Https})
type
  Call_WorkspacesGetSearchResults_568347 = ref object of OpenApiRestCall_567658
proc url_WorkspacesGetSearchResults_568349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGetSearchResults_568348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit a search for a given workspace. The response will contain an id to track the search. User can use the id to poll the search status and get the full search result later if the search takes long time to finish. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  var valid_568352 = path.getOrDefault("workspaceName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "workspaceName", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to execute a search query.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_WorkspacesGetSearchResults_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a search for a given workspace. The response will contain an id to track the search. User can use the id to poll the search status and get the full search result later if the search takes long time to finish. 
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_WorkspacesGetSearchResults_568347;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## workspacesGetSearchResults
  ## Submit a search for a given workspace. The response will contain an id to track the search. User can use the id to poll the search status and get the full search result later if the search takes long time to finish. 
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters required to execute a search query.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  var body_568359 = newJObject()
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568359 = parameters
  add(path_568357, "workspaceName", newJString(workspaceName))
  result = call_568356.call(path_568357, query_568358, nil, nil, body_568359)

var workspacesGetSearchResults* = Call_WorkspacesGetSearchResults_568347(
    name: "workspacesGetSearchResults", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/search",
    validator: validate_WorkspacesGetSearchResults_568348, base: "",
    url: url_WorkspacesGetSearchResults_568349, schemes: {Scheme.Https})
type
  Call_WorkspacesUpdateSearchResults_568360 = ref object of OpenApiRestCall_567658
proc url_WorkspacesUpdateSearchResults_568362(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/search/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdateSearchResults_568361(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets updated search results for a given search query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   id: JString (required)
  ##     : The id of the search that will have results updated. You can get the id from the response of the GetResults call.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  var valid_568365 = path.getOrDefault("id")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "id", valid_568365
  var valid_568366 = path.getOrDefault("workspaceName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "workspaceName", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_WorkspacesUpdateSearchResults_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets updated search results for a given search query.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_WorkspacesUpdateSearchResults_568360;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          id: string; workspaceName: string): Recallable =
  ## workspacesUpdateSearchResults
  ## Gets updated search results for a given search query.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   id: string (required)
  ##     : The id of the search that will have results updated. You can get the id from the response of the GetResults call.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(path_568370, "id", newJString(id))
  add(path_568370, "workspaceName", newJString(workspaceName))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var workspacesUpdateSearchResults* = Call_WorkspacesUpdateSearchResults_568360(
    name: "workspacesUpdateSearchResults", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/search/{id}",
    validator: validate_WorkspacesUpdateSearchResults_568361, base: "",
    url: url_WorkspacesUpdateSearchResults_568362, schemes: {Scheme.Https})
type
  Call_StorageInsightsListByWorkspace_568372 = ref object of OpenApiRestCall_567658
proc url_StorageInsightsListByWorkspace_568374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/storageInsightConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageInsightsListByWorkspace_568373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage insight instances within a workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("workspaceName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "workspaceName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_StorageInsightsListByWorkspace_568372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the storage insight instances within a workspace
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_StorageInsightsListByWorkspace_568372;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## storageInsightsListByWorkspace
  ## Lists the storage insight instances within a workspace
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "workspaceName", newJString(workspaceName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var storageInsightsListByWorkspace* = Call_StorageInsightsListByWorkspace_568372(
    name: "storageInsightsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs",
    validator: validate_StorageInsightsListByWorkspace_568373, base: "",
    url: url_StorageInsightsListByWorkspace_568374, schemes: {Scheme.Https})
type
  Call_StorageInsightsCreateOrUpdate_568395 = ref object of OpenApiRestCall_567658
proc url_StorageInsightsCreateOrUpdate_568397(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "storageInsightName" in path,
        "`storageInsightName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/storageInsightConfigs/"),
               (kind: VariableSegment, value: "storageInsightName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageInsightsCreateOrUpdate_568396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a storage insight.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   storageInsightName: JString (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568398 = path.getOrDefault("resourceGroupName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "resourceGroupName", valid_568398
  var valid_568399 = path.getOrDefault("storageInsightName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "storageInsightName", valid_568399
  var valid_568400 = path.getOrDefault("subscriptionId")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "subscriptionId", valid_568400
  var valid_568401 = path.getOrDefault("workspaceName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "workspaceName", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to create or update a storage insight.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_StorageInsightsCreateOrUpdate_568395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a storage insight.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_StorageInsightsCreateOrUpdate_568395;
          resourceGroupName: string; apiVersion: string; storageInsightName: string;
          subscriptionId: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## storageInsightsCreateOrUpdate
  ## Create or update a storage insight.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   storageInsightName: string (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters required to create or update a storage insight.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  var body_568408 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "storageInsightName", newJString(storageInsightName))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568408 = parameters
  add(path_568406, "workspaceName", newJString(workspaceName))
  result = call_568405.call(path_568406, query_568407, nil, nil, body_568408)

var storageInsightsCreateOrUpdate* = Call_StorageInsightsCreateOrUpdate_568395(
    name: "storageInsightsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs/{storageInsightName}",
    validator: validate_StorageInsightsCreateOrUpdate_568396, base: "",
    url: url_StorageInsightsCreateOrUpdate_568397, schemes: {Scheme.Https})
type
  Call_StorageInsightsGet_568383 = ref object of OpenApiRestCall_567658
proc url_StorageInsightsGet_568385(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "storageInsightName" in path,
        "`storageInsightName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/storageInsightConfigs/"),
               (kind: VariableSegment, value: "storageInsightName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageInsightsGet_568384(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a storage insight instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   storageInsightName: JString (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("storageInsightName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "storageInsightName", valid_568387
  var valid_568388 = path.getOrDefault("subscriptionId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "subscriptionId", valid_568388
  var valid_568389 = path.getOrDefault("workspaceName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "workspaceName", valid_568389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568390 = query.getOrDefault("api-version")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "api-version", valid_568390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_StorageInsightsGet_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a storage insight instance.
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_StorageInsightsGet_568383; resourceGroupName: string;
          apiVersion: string; storageInsightName: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## storageInsightsGet
  ## Gets a storage insight instance.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   storageInsightName: string (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  add(path_568393, "resourceGroupName", newJString(resourceGroupName))
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "storageInsightName", newJString(storageInsightName))
  add(path_568393, "subscriptionId", newJString(subscriptionId))
  add(path_568393, "workspaceName", newJString(workspaceName))
  result = call_568392.call(path_568393, query_568394, nil, nil, nil)

var storageInsightsGet* = Call_StorageInsightsGet_568383(
    name: "storageInsightsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs/{storageInsightName}",
    validator: validate_StorageInsightsGet_568384, base: "",
    url: url_StorageInsightsGet_568385, schemes: {Scheme.Https})
type
  Call_StorageInsightsDelete_568409 = ref object of OpenApiRestCall_567658
proc url_StorageInsightsDelete_568411(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "storageInsightName" in path,
        "`storageInsightName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/storageInsightConfigs/"),
               (kind: VariableSegment, value: "storageInsightName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageInsightsDelete_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a storageInsightsConfigs resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   storageInsightName: JString (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("storageInsightName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "storageInsightName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  var valid_568415 = path.getOrDefault("workspaceName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "workspaceName", valid_568415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568416 = query.getOrDefault("api-version")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "api-version", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_StorageInsightsDelete_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storageInsightsConfigs resource
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_StorageInsightsDelete_568409;
          resourceGroupName: string; apiVersion: string; storageInsightName: string;
          subscriptionId: string; workspaceName: string): Recallable =
  ## storageInsightsDelete
  ## Deletes a storageInsightsConfigs resource
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   storageInsightName: string (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "storageInsightName", newJString(storageInsightName))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(path_568419, "workspaceName", newJString(workspaceName))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var storageInsightsDelete* = Call_StorageInsightsDelete_568409(
    name: "storageInsightsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs/{storageInsightName}",
    validator: validate_StorageInsightsDelete_568410, base: "",
    url: url_StorageInsightsDelete_568411, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
