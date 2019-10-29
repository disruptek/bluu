
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "operationalinsights-OperationalInsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
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
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available OperationalInsights Rest API operations.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available OperationalInsights Rest API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.OperationalInsights/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_WorkspacesListLinkTargets_564076 = ref object of OpenApiRestCall_563556
proc url_WorkspacesListLinkTargets_564078(protocol: Scheme; host: string;
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

proc validate_WorkspacesListLinkTargets_564077(path: JsonNode; query: JsonNode;
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
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_WorkspacesListLinkTargets_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of workspaces which the current user has administrator privileges and are not associated with an Azure Subscription. The subscriptionId parameter in the Url is ignored.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_WorkspacesListLinkTargets_564076; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workspacesListLinkTargets
  ## Get a list of workspaces which the current user has administrator privileges and are not associated with an Azure Subscription. The subscriptionId parameter in the Url is ignored.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var workspacesListLinkTargets* = Call_WorkspacesListLinkTargets_564076(
    name: "workspacesListLinkTargets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.OperationalInsights/linkTargets",
    validator: validate_WorkspacesListLinkTargets_564077, base: "",
    url: url_WorkspacesListLinkTargets_564078, schemes: {Scheme.Https})
type
  Call_WorkspacesGetPurgeStatus_564099 = ref object of OpenApiRestCall_563556
proc url_WorkspacesGetPurgeStatus_564101(protocol: Scheme; host: string;
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

proc validate_WorkspacesGetPurgeStatus_564100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets status of an ongoing purge operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  ##   purgeId: JString (required)
  ##          : In a purge status request, this is the Id of the operation the status of which is returned.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  var valid_564104 = path.getOrDefault("workspaceName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "workspaceName", valid_564104
  var valid_564105 = path.getOrDefault("purgeId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "purgeId", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_WorkspacesGetPurgeStatus_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets status of an ongoing purge operation.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_WorkspacesGetPurgeStatus_564099; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string;
          purgeId: string): Recallable =
  ## workspacesGetPurgeStatus
  ## Gets status of an ongoing purge operation.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  ##   purgeId: string (required)
  ##          : In a purge status request, this is the Id of the operation the status of which is returned.
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  add(path_564109, "resourceGroupName", newJString(resourceGroupName))
  add(path_564109, "workspaceName", newJString(workspaceName))
  add(path_564109, "purgeId", newJString(purgeId))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var workspacesGetPurgeStatus* = Call_WorkspacesGetPurgeStatus_564099(
    name: "workspacesGetPurgeStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/operations/{purgeId}",
    validator: validate_WorkspacesGetPurgeStatus_564100, base: "",
    url: url_WorkspacesGetPurgeStatus_564101, schemes: {Scheme.Https})
type
  Call_WorkspacesPurge_564111 = ref object of OpenApiRestCall_563556
proc url_WorkspacesPurge_564113(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspacesPurge_564112(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Purges data in an Log Analytics workspace by a set of user-defined filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  var valid_564133 = path.getOrDefault("workspaceName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "workspaceName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
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

proc call*(call_564136: Call_WorkspacesPurge_564111; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Purges data in an Log Analytics workspace by a set of user-defined filters.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_WorkspacesPurge_564111; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; body: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesPurge
  ## Purges data in an Log Analytics workspace by a set of user-defined filters.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   body: JObject (required)
  ##       : Describes the body of a request to purge data in a single table of an Log Analytics Workspace
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  var body_564140 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "subscriptionId", newJString(subscriptionId))
  add(path_564138, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564140 = body
  add(path_564138, "workspaceName", newJString(workspaceName))
  result = call_564137.call(path_564138, query_564139, nil, nil, body_564140)

var workspacesPurge* = Call_WorkspacesPurge_564111(name: "workspacesPurge",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/purge",
    validator: validate_WorkspacesPurge_564112, base: "", url: url_WorkspacesPurge_564113,
    schemes: {Scheme.Https})
type
  Call_WorkspacesDeleteGateways_564141 = ref object of OpenApiRestCall_563556
proc url_WorkspacesDeleteGateways_564143(protocol: Scheme; host: string;
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

proc validate_WorkspacesDeleteGateways_564142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Log Analytics gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayId: JString (required)
  ##            : The Log Analytics gateway Id.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `gatewayId` field"
  var valid_564144 = path.getOrDefault("gatewayId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "gatewayId", valid_564144
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  var valid_564147 = path.getOrDefault("workspaceName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "workspaceName", valid_564147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_564149: Call_WorkspacesDeleteGateways_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Log Analytics gateway.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_WorkspacesDeleteGateways_564141; apiVersion: string;
          gatewayId: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## workspacesDeleteGateways
  ## Delete a Log Analytics gateway.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   gatewayId: string (required)
  ##            : The Log Analytics gateway Id.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "gatewayId", newJString(gatewayId))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(path_564151, "workspaceName", newJString(workspaceName))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var workspacesDeleteGateways* = Call_WorkspacesDeleteGateways_564141(
    name: "workspacesDeleteGateways", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/gateways/{gatewayId}",
    validator: validate_WorkspacesDeleteGateways_564142, base: "",
    url: url_WorkspacesDeleteGateways_564143, schemes: {Scheme.Https})
type
  Call_WorkspacesListKeys_564153 = ref object of OpenApiRestCall_563556
proc url_WorkspacesListKeys_564155(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspacesListKeys_564154(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  var valid_564158 = path.getOrDefault("workspaceName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "workspaceName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_564160: Call_WorkspacesListKeys_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_WorkspacesListKeys_564153; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## workspacesListKeys
  ## Gets the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  add(path_564162, "workspaceName", newJString(workspaceName))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var workspacesListKeys* = Call_WorkspacesListKeys_564153(
    name: "workspacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/listKeys",
    validator: validate_WorkspacesListKeys_564154, base: "",
    url: url_WorkspacesListKeys_564155, schemes: {Scheme.Https})
type
  Call_WorkspacesRegenerateSharedKeys_564164 = ref object of OpenApiRestCall_563556
proc url_WorkspacesRegenerateSharedKeys_564166(protocol: Scheme; host: string;
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

proc validate_WorkspacesRegenerateSharedKeys_564165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  var valid_564169 = path.getOrDefault("workspaceName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "workspaceName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_WorkspacesRegenerateSharedKeys_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_WorkspacesRegenerateSharedKeys_564164;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## workspacesRegenerateSharedKeys
  ## Regenerates the shared keys for a Log Analytics Workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  add(path_564173, "workspaceName", newJString(workspaceName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var workspacesRegenerateSharedKeys* = Call_WorkspacesRegenerateSharedKeys_564164(
    name: "workspacesRegenerateSharedKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/regenerateSharedKey",
    validator: validate_WorkspacesRegenerateSharedKeys_564165, base: "",
    url: url_WorkspacesRegenerateSharedKeys_564166, schemes: {Scheme.Https})
type
  Call_SavedSearchesListByWorkspace_564175 = ref object of OpenApiRestCall_563556
proc url_SavedSearchesListByWorkspace_564177(protocol: Scheme; host: string;
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

proc validate_SavedSearchesListByWorkspace_564176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the saved searches for a given Log Analytics Workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  var valid_564180 = path.getOrDefault("workspaceName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "workspaceName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_SavedSearchesListByWorkspace_564175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the saved searches for a given Log Analytics Workspace
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_SavedSearchesListByWorkspace_564175;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## savedSearchesListByWorkspace
  ## Gets the saved searches for a given Log Analytics Workspace
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  add(path_564184, "workspaceName", newJString(workspaceName))
  result = call_564183.call(path_564184, query_564185, nil, nil, nil)

var savedSearchesListByWorkspace* = Call_SavedSearchesListByWorkspace_564175(
    name: "savedSearchesListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches",
    validator: validate_SavedSearchesListByWorkspace_564176, base: "",
    url: url_SavedSearchesListByWorkspace_564177, schemes: {Scheme.Https})
type
  Call_SavedSearchesCreateOrUpdate_564198 = ref object of OpenApiRestCall_563556
proc url_SavedSearchesCreateOrUpdate_564200(protocol: Scheme; host: string;
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

proc validate_SavedSearchesCreateOrUpdate_564199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a saved search for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564201 = path.getOrDefault("subscriptionId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "subscriptionId", valid_564201
  var valid_564202 = path.getOrDefault("savedSearchId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "savedSearchId", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  var valid_564204 = path.getOrDefault("workspaceName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "workspaceName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "api-version", valid_564205
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

proc call*(call_564207: Call_SavedSearchesCreateOrUpdate_564198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a saved search for a given workspace.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_SavedSearchesCreateOrUpdate_564198;
          apiVersion: string; subscriptionId: string; savedSearchId: string;
          resourceGroupName: string; workspaceName: string; parameters: JsonNode): Recallable =
  ## savedSearchesCreateOrUpdate
  ## Creates or updates a saved search for a given workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  ##   parameters: JObject (required)
  ##             : The parameters required to save a search.
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  var body_564211 = newJObject()
  add(query_564210, "api-version", newJString(apiVersion))
  add(path_564209, "subscriptionId", newJString(subscriptionId))
  add(path_564209, "savedSearchId", newJString(savedSearchId))
  add(path_564209, "resourceGroupName", newJString(resourceGroupName))
  add(path_564209, "workspaceName", newJString(workspaceName))
  if parameters != nil:
    body_564211 = parameters
  result = call_564208.call(path_564209, query_564210, nil, nil, body_564211)

var savedSearchesCreateOrUpdate* = Call_SavedSearchesCreateOrUpdate_564198(
    name: "savedSearchesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}",
    validator: validate_SavedSearchesCreateOrUpdate_564199, base: "",
    url: url_SavedSearchesCreateOrUpdate_564200, schemes: {Scheme.Https})
type
  Call_SavedSearchesGet_564186 = ref object of OpenApiRestCall_563556
proc url_SavedSearchesGet_564188(protocol: Scheme; host: string; base: string;
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

proc validate_SavedSearchesGet_564187(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified saved search for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("savedSearchId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "savedSearchId", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  var valid_564192 = path.getOrDefault("workspaceName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "workspaceName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564194: Call_SavedSearchesGet_564186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified saved search for a given workspace.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_SavedSearchesGet_564186; apiVersion: string;
          subscriptionId: string; savedSearchId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## savedSearchesGet
  ## Gets the specified saved search for a given workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "savedSearchId", newJString(savedSearchId))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  add(path_564196, "workspaceName", newJString(workspaceName))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var savedSearchesGet* = Call_SavedSearchesGet_564186(name: "savedSearchesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}",
    validator: validate_SavedSearchesGet_564187, base: "",
    url: url_SavedSearchesGet_564188, schemes: {Scheme.Https})
type
  Call_SavedSearchesDelete_564212 = ref object of OpenApiRestCall_563556
proc url_SavedSearchesDelete_564214(protocol: Scheme; host: string; base: string;
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

proc validate_SavedSearchesDelete_564213(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified saved search in a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564215 = path.getOrDefault("subscriptionId")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "subscriptionId", valid_564215
  var valid_564216 = path.getOrDefault("savedSearchId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "savedSearchId", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  var valid_564218 = path.getOrDefault("workspaceName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "workspaceName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_SavedSearchesDelete_564212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified saved search in a given workspace.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_SavedSearchesDelete_564212; apiVersion: string;
          subscriptionId: string; savedSearchId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## savedSearchesDelete
  ## Deletes the specified saved search in a given workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "savedSearchId", newJString(savedSearchId))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(path_564222, "workspaceName", newJString(workspaceName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var savedSearchesDelete* = Call_SavedSearchesDelete_564212(
    name: "savedSearchesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}",
    validator: validate_SavedSearchesDelete_564213, base: "",
    url: url_SavedSearchesDelete_564214, schemes: {Scheme.Https})
type
  Call_SavedSearchesGetResults_564224 = ref object of OpenApiRestCall_563556
proc url_SavedSearchesGetResults_564226(protocol: Scheme; host: string; base: string;
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

proc validate_SavedSearchesGetResults_564225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the results from a saved search for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedSearchId: JString (required)
  ##                : The id of the saved search.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedSearchId` field"
  var valid_564227 = path.getOrDefault("savedSearchId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "savedSearchId", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("workspaceName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "workspaceName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_SavedSearchesGetResults_564224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the results from a saved search for a given workspace.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_SavedSearchesGetResults_564224; apiVersion: string;
          savedSearchId: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## savedSearchesGetResults
  ## Gets the results from a saved search for a given workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   savedSearchId: string (required)
  ##                : The id of the saved search.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "savedSearchId", newJString(savedSearchId))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "resourceGroupName", newJString(resourceGroupName))
  add(path_564234, "workspaceName", newJString(workspaceName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var savedSearchesGetResults* = Call_SavedSearchesGetResults_564224(
    name: "savedSearchesGetResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/savedSearches/{savedSearchId}/results",
    validator: validate_SavedSearchesGetResults_564225, base: "",
    url: url_SavedSearchesGetResults_564226, schemes: {Scheme.Https})
type
  Call_WorkspacesGetSchema_564236 = ref object of OpenApiRestCall_563556
proc url_WorkspacesGetSchema_564238(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspacesGetSchema_564237(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the schema for a given workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("resourceGroupName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "resourceGroupName", valid_564240
  var valid_564241 = path.getOrDefault("workspaceName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "workspaceName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_WorkspacesGetSchema_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the schema for a given workspace.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_WorkspacesGetSchema_564236; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## workspacesGetSchema
  ## Gets the schema for a given workspace.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "resourceGroupName", newJString(resourceGroupName))
  add(path_564245, "workspaceName", newJString(workspaceName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var workspacesGetSchema* = Call_WorkspacesGetSchema_564236(
    name: "workspacesGetSchema", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/schema",
    validator: validate_WorkspacesGetSchema_564237, base: "",
    url: url_WorkspacesGetSchema_564238, schemes: {Scheme.Https})
type
  Call_WorkspacesGetSearchResults_564247 = ref object of OpenApiRestCall_563556
proc url_WorkspacesGetSearchResults_564249(protocol: Scheme; host: string;
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

proc validate_WorkspacesGetSearchResults_564248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit a search for a given workspace. The response will contain an id to track the search. User can use the id to poll the search status and get the full search result later if the search takes long time to finish. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  var valid_564252 = path.getOrDefault("workspaceName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "workspaceName", valid_564252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564253 = query.getOrDefault("api-version")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "api-version", valid_564253
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

proc call*(call_564255: Call_WorkspacesGetSearchResults_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a search for a given workspace. The response will contain an id to track the search. User can use the id to poll the search status and get the full search result later if the search takes long time to finish. 
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_WorkspacesGetSearchResults_564247; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string;
          parameters: JsonNode): Recallable =
  ## workspacesGetSearchResults
  ## Submit a search for a given workspace. The response will contain an id to track the search. User can use the id to poll the search status and get the full search result later if the search takes long time to finish. 
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  ##   parameters: JObject (required)
  ##             : The parameters required to execute a search query.
  var path_564257 = newJObject()
  var query_564258 = newJObject()
  var body_564259 = newJObject()
  add(query_564258, "api-version", newJString(apiVersion))
  add(path_564257, "subscriptionId", newJString(subscriptionId))
  add(path_564257, "resourceGroupName", newJString(resourceGroupName))
  add(path_564257, "workspaceName", newJString(workspaceName))
  if parameters != nil:
    body_564259 = parameters
  result = call_564256.call(path_564257, query_564258, nil, nil, body_564259)

var workspacesGetSearchResults* = Call_WorkspacesGetSearchResults_564247(
    name: "workspacesGetSearchResults", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/search",
    validator: validate_WorkspacesGetSearchResults_564248, base: "",
    url: url_WorkspacesGetSearchResults_564249, schemes: {Scheme.Https})
type
  Call_WorkspacesUpdateSearchResults_564260 = ref object of OpenApiRestCall_563556
proc url_WorkspacesUpdateSearchResults_564262(protocol: Scheme; host: string;
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

proc validate_WorkspacesUpdateSearchResults_564261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets updated search results for a given search query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id of the search that will have results updated. You can get the id from the response of the GetResults call.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564263 = path.getOrDefault("id")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "id", valid_564263
  var valid_564264 = path.getOrDefault("subscriptionId")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "subscriptionId", valid_564264
  var valid_564265 = path.getOrDefault("resourceGroupName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "resourceGroupName", valid_564265
  var valid_564266 = path.getOrDefault("workspaceName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "workspaceName", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564268: Call_WorkspacesUpdateSearchResults_564260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets updated search results for a given search query.
  ## 
  let valid = call_564268.validator(path, query, header, formData, body)
  let scheme = call_564268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564268.url(scheme.get, call_564268.host, call_564268.base,
                         call_564268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564268, url, valid)

proc call*(call_564269: Call_WorkspacesUpdateSearchResults_564260;
          apiVersion: string; id: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## workspacesUpdateSearchResults
  ## Gets updated search results for a given search query.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   id: string (required)
  ##     : The id of the search that will have results updated. You can get the id from the response of the GetResults call.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564270 = newJObject()
  var query_564271 = newJObject()
  add(query_564271, "api-version", newJString(apiVersion))
  add(path_564270, "id", newJString(id))
  add(path_564270, "subscriptionId", newJString(subscriptionId))
  add(path_564270, "resourceGroupName", newJString(resourceGroupName))
  add(path_564270, "workspaceName", newJString(workspaceName))
  result = call_564269.call(path_564270, query_564271, nil, nil, nil)

var workspacesUpdateSearchResults* = Call_WorkspacesUpdateSearchResults_564260(
    name: "workspacesUpdateSearchResults", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/search/{id}",
    validator: validate_WorkspacesUpdateSearchResults_564261, base: "",
    url: url_WorkspacesUpdateSearchResults_564262, schemes: {Scheme.Https})
type
  Call_StorageInsightsListByWorkspace_564272 = ref object of OpenApiRestCall_563556
proc url_StorageInsightsListByWorkspace_564274(protocol: Scheme; host: string;
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

proc validate_StorageInsightsListByWorkspace_564273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage insight instances within a workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("resourceGroupName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceGroupName", valid_564276
  var valid_564277 = path.getOrDefault("workspaceName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "workspaceName", valid_564277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564279: Call_StorageInsightsListByWorkspace_564272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the storage insight instances within a workspace
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_StorageInsightsListByWorkspace_564272;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## storageInsightsListByWorkspace
  ## Lists the storage insight instances within a workspace
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  add(path_564281, "workspaceName", newJString(workspaceName))
  result = call_564280.call(path_564281, query_564282, nil, nil, nil)

var storageInsightsListByWorkspace* = Call_StorageInsightsListByWorkspace_564272(
    name: "storageInsightsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs",
    validator: validate_StorageInsightsListByWorkspace_564273, base: "",
    url: url_StorageInsightsListByWorkspace_564274, schemes: {Scheme.Https})
type
  Call_StorageInsightsCreateOrUpdate_564295 = ref object of OpenApiRestCall_563556
proc url_StorageInsightsCreateOrUpdate_564297(protocol: Scheme; host: string;
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

proc validate_StorageInsightsCreateOrUpdate_564296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a storage insight.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageInsightName: JString (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageInsightName` field"
  var valid_564298 = path.getOrDefault("storageInsightName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "storageInsightName", valid_564298
  var valid_564299 = path.getOrDefault("subscriptionId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "subscriptionId", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
  var valid_564301 = path.getOrDefault("workspaceName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "workspaceName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
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

proc call*(call_564304: Call_StorageInsightsCreateOrUpdate_564295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a storage insight.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_StorageInsightsCreateOrUpdate_564295;
          apiVersion: string; storageInsightName: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; parameters: JsonNode): Recallable =
  ## storageInsightsCreateOrUpdate
  ## Create or update a storage insight.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   storageInsightName: string (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  ##   parameters: JObject (required)
  ##             : The parameters required to create or update a storage insight.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  var body_564308 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "storageInsightName", newJString(storageInsightName))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  add(path_564306, "workspaceName", newJString(workspaceName))
  if parameters != nil:
    body_564308 = parameters
  result = call_564305.call(path_564306, query_564307, nil, nil, body_564308)

var storageInsightsCreateOrUpdate* = Call_StorageInsightsCreateOrUpdate_564295(
    name: "storageInsightsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs/{storageInsightName}",
    validator: validate_StorageInsightsCreateOrUpdate_564296, base: "",
    url: url_StorageInsightsCreateOrUpdate_564297, schemes: {Scheme.Https})
type
  Call_StorageInsightsGet_564283 = ref object of OpenApiRestCall_563556
proc url_StorageInsightsGet_564285(protocol: Scheme; host: string; base: string;
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

proc validate_StorageInsightsGet_564284(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a storage insight instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageInsightName: JString (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageInsightName` field"
  var valid_564286 = path.getOrDefault("storageInsightName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "storageInsightName", valid_564286
  var valid_564287 = path.getOrDefault("subscriptionId")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "subscriptionId", valid_564287
  var valid_564288 = path.getOrDefault("resourceGroupName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceGroupName", valid_564288
  var valid_564289 = path.getOrDefault("workspaceName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "workspaceName", valid_564289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564290 = query.getOrDefault("api-version")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "api-version", valid_564290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564291: Call_StorageInsightsGet_564283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a storage insight instance.
  ## 
  let valid = call_564291.validator(path, query, header, formData, body)
  let scheme = call_564291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564291.url(scheme.get, call_564291.host, call_564291.base,
                         call_564291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564291, url, valid)

proc call*(call_564292: Call_StorageInsightsGet_564283; apiVersion: string;
          storageInsightName: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## storageInsightsGet
  ## Gets a storage insight instance.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   storageInsightName: string (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564293 = newJObject()
  var query_564294 = newJObject()
  add(query_564294, "api-version", newJString(apiVersion))
  add(path_564293, "storageInsightName", newJString(storageInsightName))
  add(path_564293, "subscriptionId", newJString(subscriptionId))
  add(path_564293, "resourceGroupName", newJString(resourceGroupName))
  add(path_564293, "workspaceName", newJString(workspaceName))
  result = call_564292.call(path_564293, query_564294, nil, nil, nil)

var storageInsightsGet* = Call_StorageInsightsGet_564283(
    name: "storageInsightsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs/{storageInsightName}",
    validator: validate_StorageInsightsGet_564284, base: "",
    url: url_StorageInsightsGet_564285, schemes: {Scheme.Https})
type
  Call_StorageInsightsDelete_564309 = ref object of OpenApiRestCall_563556
proc url_StorageInsightsDelete_564311(protocol: Scheme; host: string; base: string;
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

proc validate_StorageInsightsDelete_564310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a storageInsightsConfigs resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageInsightName: JString (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: JString (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group name.
  ##   workspaceName: JString (required)
  ##                : The Log Analytics Workspace name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageInsightName` field"
  var valid_564312 = path.getOrDefault("storageInsightName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "storageInsightName", valid_564312
  var valid_564313 = path.getOrDefault("subscriptionId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "subscriptionId", valid_564313
  var valid_564314 = path.getOrDefault("resourceGroupName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "resourceGroupName", valid_564314
  var valid_564315 = path.getOrDefault("workspaceName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "workspaceName", valid_564315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_StorageInsightsDelete_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storageInsightsConfigs resource
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_StorageInsightsDelete_564309; apiVersion: string;
          storageInsightName: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## storageInsightsDelete
  ## Deletes a storageInsightsConfigs resource
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   storageInsightName: string (required)
  ##                     : Name of the storageInsightsConfigs resource
  ##   subscriptionId: string (required)
  ##                 : The Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group name.
  ##   workspaceName: string (required)
  ##                : The Log Analytics Workspace name.
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "storageInsightName", newJString(storageInsightName))
  add(path_564319, "subscriptionId", newJString(subscriptionId))
  add(path_564319, "resourceGroupName", newJString(resourceGroupName))
  add(path_564319, "workspaceName", newJString(workspaceName))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var storageInsightsDelete* = Call_StorageInsightsDelete_564309(
    name: "storageInsightsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/storageInsightConfigs/{storageInsightName}",
    validator: validate_StorageInsightsDelete_564310, base: "",
    url: url_StorageInsightsDelete_564311, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
