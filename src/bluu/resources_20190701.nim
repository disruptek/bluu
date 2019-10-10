
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ResourceManagementClient
## version: 2019-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides operations for working with resources and resource groups.
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProvidersListAtTenantScope_573889 = ref object of OpenApiRestCall_573667
proc url_ProvidersListAtTenantScope_573891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProvidersListAtTenantScope_573890(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all resource providers for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed returns all providers.
  section = newJObject()
  var valid_574051 = query.getOrDefault("$expand")
  valid_574051 = validateParameter(valid_574051, JString, required = false,
                                 default = nil)
  if valid_574051 != nil:
    section.add "$expand", valid_574051
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574052 = query.getOrDefault("api-version")
  valid_574052 = validateParameter(valid_574052, JString, required = true,
                                 default = nil)
  if valid_574052 != nil:
    section.add "api-version", valid_574052
  var valid_574053 = query.getOrDefault("$top")
  valid_574053 = validateParameter(valid_574053, JInt, required = false, default = nil)
  if valid_574053 != nil:
    section.add "$top", valid_574053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574076: Call_ProvidersListAtTenantScope_573889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for the tenant.
  ## 
  let valid = call_574076.validator(path, query, header, formData, body)
  let scheme = call_574076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574076.url(scheme.get, call_574076.host, call_574076.base,
                         call_574076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574076, url, valid)

proc call*(call_574147: Call_ProvidersListAtTenantScope_573889; apiVersion: string;
          Expand: string = ""; Top: int = 0): Recallable =
  ## providersListAtTenantScope
  ## Gets all resource providers for the tenant.
  ##   Expand: string
  ##         : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : The number of results to return. If null is passed returns all providers.
  var query_574148 = newJObject()
  add(query_574148, "$expand", newJString(Expand))
  add(query_574148, "api-version", newJString(apiVersion))
  add(query_574148, "$top", newJInt(Top))
  result = call_574147.call(nil, query_574148, nil, nil, nil)

var providersListAtTenantScope* = Call_ProvidersListAtTenantScope_573889(
    name: "providersListAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers",
    validator: validate_ProvidersListAtTenantScope_573890, base: "",
    url: url_ProvidersListAtTenantScope_573891, schemes: {Scheme.Https})
type
  Call_DeploymentsListAtManagementGroupScope_574188 = ref object of OpenApiRestCall_573667
proc url_DeploymentsListAtManagementGroupScope_574190(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListAtManagementGroupScope_574189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574205 = path.getOrDefault("groupId")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "groupId", valid_574205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  var valid_574207 = query.getOrDefault("$top")
  valid_574207 = validateParameter(valid_574207, JInt, required = false, default = nil)
  if valid_574207 != nil:
    section.add "$top", valid_574207
  var valid_574208 = query.getOrDefault("$filter")
  valid_574208 = validateParameter(valid_574208, JString, required = false,
                                 default = nil)
  if valid_574208 != nil:
    section.add "$filter", valid_574208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574209: Call_DeploymentsListAtManagementGroupScope_574188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a management group.
  ## 
  let valid = call_574209.validator(path, query, header, formData, body)
  let scheme = call_574209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574209.url(scheme.get, call_574209.host, call_574209.base,
                         call_574209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574209, url, valid)

proc call*(call_574210: Call_DeploymentsListAtManagementGroupScope_574188;
          groupId: string; apiVersion: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtManagementGroupScope
  ## Get all the deployments for a management group.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_574211 = newJObject()
  var query_574212 = newJObject()
  add(path_574211, "groupId", newJString(groupId))
  add(query_574212, "api-version", newJString(apiVersion))
  add(query_574212, "$top", newJInt(Top))
  add(query_574212, "$filter", newJString(Filter))
  result = call_574210.call(path_574211, query_574212, nil, nil, nil)

var deploymentsListAtManagementGroupScope* = Call_DeploymentsListAtManagementGroupScope_574188(
    name: "deploymentsListAtManagementGroupScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtManagementGroupScope_574189, base: "",
    url: url_DeploymentsListAtManagementGroupScope_574190, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtManagementGroupScope_574223 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCreateOrUpdateAtManagementGroupScope_574225(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtManagementGroupScope_574224(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574243 = path.getOrDefault("groupId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "groupId", valid_574243
  var valid_574244 = path.getOrDefault("deploymentName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "deploymentName", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574247: Call_DeploymentsCreateOrUpdateAtManagementGroupScope_574223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_DeploymentsCreateOrUpdateAtManagementGroupScope_574223;
          groupId: string; apiVersion: string; deploymentName: string;
          parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdateAtManagementGroupScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  var body_574251 = newJObject()
  add(path_574249, "groupId", newJString(groupId))
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_574251 = parameters
  result = call_574248.call(path_574249, query_574250, nil, nil, body_574251)

var deploymentsCreateOrUpdateAtManagementGroupScope* = Call_DeploymentsCreateOrUpdateAtManagementGroupScope_574223(
    name: "deploymentsCreateOrUpdateAtManagementGroupScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtManagementGroupScope_574224,
    base: "", url: url_DeploymentsCreateOrUpdateAtManagementGroupScope_574225,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtManagementGroupScope_574262 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCheckExistenceAtManagementGroupScope_574264(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtManagementGroupScope_574263(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574265 = path.getOrDefault("groupId")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "groupId", valid_574265
  var valid_574266 = path.getOrDefault("deploymentName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "deploymentName", valid_574266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574268: Call_DeploymentsCheckExistenceAtManagementGroupScope_574262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_574268.validator(path, query, header, formData, body)
  let scheme = call_574268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574268.url(scheme.get, call_574268.host, call_574268.base,
                         call_574268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574268, url, valid)

proc call*(call_574269: Call_DeploymentsCheckExistenceAtManagementGroupScope_574262;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCheckExistenceAtManagementGroupScope
  ## Checks whether the deployment exists.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574270 = newJObject()
  var query_574271 = newJObject()
  add(path_574270, "groupId", newJString(groupId))
  add(query_574271, "api-version", newJString(apiVersion))
  add(path_574270, "deploymentName", newJString(deploymentName))
  result = call_574269.call(path_574270, query_574271, nil, nil, nil)

var deploymentsCheckExistenceAtManagementGroupScope* = Call_DeploymentsCheckExistenceAtManagementGroupScope_574262(
    name: "deploymentsCheckExistenceAtManagementGroupScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtManagementGroupScope_574263,
    base: "", url: url_DeploymentsCheckExistenceAtManagementGroupScope_574264,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtManagementGroupScope_574213 = ref object of OpenApiRestCall_573667
proc url_DeploymentsGetAtManagementGroupScope_574215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtManagementGroupScope_574214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574216 = path.getOrDefault("groupId")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "groupId", valid_574216
  var valid_574217 = path.getOrDefault("deploymentName")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "deploymentName", valid_574217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574218 = query.getOrDefault("api-version")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "api-version", valid_574218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574219: Call_DeploymentsGetAtManagementGroupScope_574213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_574219.validator(path, query, header, formData, body)
  let scheme = call_574219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574219.url(scheme.get, call_574219.host, call_574219.base,
                         call_574219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574219, url, valid)

proc call*(call_574220: Call_DeploymentsGetAtManagementGroupScope_574213;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsGetAtManagementGroupScope
  ## Gets a deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574221 = newJObject()
  var query_574222 = newJObject()
  add(path_574221, "groupId", newJString(groupId))
  add(query_574222, "api-version", newJString(apiVersion))
  add(path_574221, "deploymentName", newJString(deploymentName))
  result = call_574220.call(path_574221, query_574222, nil, nil, nil)

var deploymentsGetAtManagementGroupScope* = Call_DeploymentsGetAtManagementGroupScope_574213(
    name: "deploymentsGetAtManagementGroupScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtManagementGroupScope_574214, base: "",
    url: url_DeploymentsGetAtManagementGroupScope_574215, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtManagementGroupScope_574252 = ref object of OpenApiRestCall_573667
proc url_DeploymentsDeleteAtManagementGroupScope_574254(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtManagementGroupScope_574253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574255 = path.getOrDefault("groupId")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "groupId", valid_574255
  var valid_574256 = path.getOrDefault("deploymentName")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "deploymentName", valid_574256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574257 = query.getOrDefault("api-version")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "api-version", valid_574257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_DeploymentsDeleteAtManagementGroupScope_574252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_DeploymentsDeleteAtManagementGroupScope_574252;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsDeleteAtManagementGroupScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  add(path_574260, "groupId", newJString(groupId))
  add(query_574261, "api-version", newJString(apiVersion))
  add(path_574260, "deploymentName", newJString(deploymentName))
  result = call_574259.call(path_574260, query_574261, nil, nil, nil)

var deploymentsDeleteAtManagementGroupScope* = Call_DeploymentsDeleteAtManagementGroupScope_574252(
    name: "deploymentsDeleteAtManagementGroupScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtManagementGroupScope_574253, base: "",
    url: url_DeploymentsDeleteAtManagementGroupScope_574254,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtManagementGroupScope_574272 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCancelAtManagementGroupScope_574274(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtManagementGroupScope_574273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574275 = path.getOrDefault("groupId")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "groupId", valid_574275
  var valid_574276 = path.getOrDefault("deploymentName")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "deploymentName", valid_574276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574277 = query.getOrDefault("api-version")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "api-version", valid_574277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574278: Call_DeploymentsCancelAtManagementGroupScope_574272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_574278.validator(path, query, header, formData, body)
  let scheme = call_574278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574278.url(scheme.get, call_574278.host, call_574278.base,
                         call_574278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574278, url, valid)

proc call*(call_574279: Call_DeploymentsCancelAtManagementGroupScope_574272;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCancelAtManagementGroupScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574280 = newJObject()
  var query_574281 = newJObject()
  add(path_574280, "groupId", newJString(groupId))
  add(query_574281, "api-version", newJString(apiVersion))
  add(path_574280, "deploymentName", newJString(deploymentName))
  result = call_574279.call(path_574280, query_574281, nil, nil, nil)

var deploymentsCancelAtManagementGroupScope* = Call_DeploymentsCancelAtManagementGroupScope_574272(
    name: "deploymentsCancelAtManagementGroupScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtManagementGroupScope_574273, base: "",
    url: url_DeploymentsCancelAtManagementGroupScope_574274,
    schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtManagementGroupScope_574282 = ref object of OpenApiRestCall_573667
proc url_DeploymentsExportTemplateAtManagementGroupScope_574284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtManagementGroupScope_574283(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574285 = path.getOrDefault("groupId")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "groupId", valid_574285
  var valid_574286 = path.getOrDefault("deploymentName")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "deploymentName", valid_574286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574287 = query.getOrDefault("api-version")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "api-version", valid_574287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574288: Call_DeploymentsExportTemplateAtManagementGroupScope_574282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_574288.validator(path, query, header, formData, body)
  let scheme = call_574288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574288.url(scheme.get, call_574288.host, call_574288.base,
                         call_574288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574288, url, valid)

proc call*(call_574289: Call_DeploymentsExportTemplateAtManagementGroupScope_574282;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsExportTemplateAtManagementGroupScope
  ## Exports the template used for specified deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574290 = newJObject()
  var query_574291 = newJObject()
  add(path_574290, "groupId", newJString(groupId))
  add(query_574291, "api-version", newJString(apiVersion))
  add(path_574290, "deploymentName", newJString(deploymentName))
  result = call_574289.call(path_574290, query_574291, nil, nil, nil)

var deploymentsExportTemplateAtManagementGroupScope* = Call_DeploymentsExportTemplateAtManagementGroupScope_574282(
    name: "deploymentsExportTemplateAtManagementGroupScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtManagementGroupScope_574283,
    base: "", url: url_DeploymentsExportTemplateAtManagementGroupScope_574284,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtManagementGroupScope_574292 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsListAtManagementGroupScope_574294(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtManagementGroupScope_574293(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574295 = path.getOrDefault("groupId")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "groupId", valid_574295
  var valid_574296 = path.getOrDefault("deploymentName")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "deploymentName", valid_574296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  var valid_574298 = query.getOrDefault("$top")
  valid_574298 = validateParameter(valid_574298, JInt, required = false, default = nil)
  if valid_574298 != nil:
    section.add "$top", valid_574298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574299: Call_DeploymentOperationsListAtManagementGroupScope_574292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_574299.validator(path, query, header, formData, body)
  let scheme = call_574299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574299.url(scheme.get, call_574299.host, call_574299.base,
                         call_574299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574299, url, valid)

proc call*(call_574300: Call_DeploymentOperationsListAtManagementGroupScope_574292;
          groupId: string; apiVersion: string; deploymentName: string; Top: int = 0): Recallable =
  ## deploymentOperationsListAtManagementGroupScope
  ## Gets all deployments operations for a deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   Top: int
  ##      : The number of results to return.
  var path_574301 = newJObject()
  var query_574302 = newJObject()
  add(path_574301, "groupId", newJString(groupId))
  add(query_574302, "api-version", newJString(apiVersion))
  add(path_574301, "deploymentName", newJString(deploymentName))
  add(query_574302, "$top", newJInt(Top))
  result = call_574300.call(path_574301, query_574302, nil, nil, nil)

var deploymentOperationsListAtManagementGroupScope* = Call_DeploymentOperationsListAtManagementGroupScope_574292(
    name: "deploymentOperationsListAtManagementGroupScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtManagementGroupScope_574293,
    base: "", url: url_DeploymentOperationsListAtManagementGroupScope_574294,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtManagementGroupScope_574303 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsGetAtManagementGroupScope_574305(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtManagementGroupScope_574304(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574306 = path.getOrDefault("groupId")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "groupId", valid_574306
  var valid_574307 = path.getOrDefault("deploymentName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "deploymentName", valid_574307
  var valid_574308 = path.getOrDefault("operationId")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "operationId", valid_574308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574309 = query.getOrDefault("api-version")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "api-version", valid_574309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574310: Call_DeploymentOperationsGetAtManagementGroupScope_574303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_574310.validator(path, query, header, formData, body)
  let scheme = call_574310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574310.url(scheme.get, call_574310.host, call_574310.base,
                         call_574310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574310, url, valid)

proc call*(call_574311: Call_DeploymentOperationsGetAtManagementGroupScope_574303;
          groupId: string; apiVersion: string; deploymentName: string;
          operationId: string): Recallable =
  ## deploymentOperationsGetAtManagementGroupScope
  ## Gets a deployments operation.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_574312 = newJObject()
  var query_574313 = newJObject()
  add(path_574312, "groupId", newJString(groupId))
  add(query_574313, "api-version", newJString(apiVersion))
  add(path_574312, "deploymentName", newJString(deploymentName))
  add(path_574312, "operationId", newJString(operationId))
  result = call_574311.call(path_574312, query_574313, nil, nil, nil)

var deploymentOperationsGetAtManagementGroupScope* = Call_DeploymentOperationsGetAtManagementGroupScope_574303(
    name: "deploymentOperationsGetAtManagementGroupScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtManagementGroupScope_574304,
    base: "", url: url_DeploymentOperationsGetAtManagementGroupScope_574305,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtManagementGroupScope_574314 = ref object of OpenApiRestCall_573667
proc url_DeploymentsValidateAtManagementGroupScope_574316(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtManagementGroupScope_574315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : The management group ID.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574317 = path.getOrDefault("groupId")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "groupId", valid_574317
  var valid_574318 = path.getOrDefault("deploymentName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "deploymentName", valid_574318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574319 = query.getOrDefault("api-version")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "api-version", valid_574319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574321: Call_DeploymentsValidateAtManagementGroupScope_574314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_574321.validator(path, query, header, formData, body)
  let scheme = call_574321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574321.url(scheme.get, call_574321.host, call_574321.base,
                         call_574321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574321, url, valid)

proc call*(call_574322: Call_DeploymentsValidateAtManagementGroupScope_574314;
          groupId: string; apiVersion: string; deploymentName: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidateAtManagementGroupScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_574323 = newJObject()
  var query_574324 = newJObject()
  var body_574325 = newJObject()
  add(path_574323, "groupId", newJString(groupId))
  add(query_574324, "api-version", newJString(apiVersion))
  add(path_574323, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_574325 = parameters
  result = call_574322.call(path_574323, query_574324, nil, nil, body_574325)

var deploymentsValidateAtManagementGroupScope* = Call_DeploymentsValidateAtManagementGroupScope_574314(
    name: "deploymentsValidateAtManagementGroupScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtManagementGroupScope_574315,
    base: "", url: url_DeploymentsValidateAtManagementGroupScope_574316,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCalculateTemplateHash_574326 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCalculateTemplateHash_574328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_574327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Calculate the hash of the given template.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574329 = query.getOrDefault("api-version")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "api-version", valid_574329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574331: Call_DeploymentsCalculateTemplateHash_574326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_574331.validator(path, query, header, formData, body)
  let scheme = call_574331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574331.url(scheme.get, call_574331.host, call_574331.base,
                         call_574331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574331, url, valid)

proc call*(call_574332: Call_DeploymentsCalculateTemplateHash_574326;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_574333 = newJObject()
  var body_574334 = newJObject()
  add(query_574333, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_574334 = `template`
  result = call_574332.call(nil, query_574333, nil, nil, body_574334)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_574326(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_574327, base: "",
    url: url_DeploymentsCalculateTemplateHash_574328, schemes: {Scheme.Https})
type
  Call_DeploymentsListAtTenantScope_574335 = ref object of OpenApiRestCall_573667
proc url_DeploymentsListAtTenantScope_574337(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsListAtTenantScope_574336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments at the tenant scope.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574338 = query.getOrDefault("api-version")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "api-version", valid_574338
  var valid_574339 = query.getOrDefault("$top")
  valid_574339 = validateParameter(valid_574339, JInt, required = false, default = nil)
  if valid_574339 != nil:
    section.add "$top", valid_574339
  var valid_574340 = query.getOrDefault("$filter")
  valid_574340 = validateParameter(valid_574340, JString, required = false,
                                 default = nil)
  if valid_574340 != nil:
    section.add "$filter", valid_574340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574341: Call_DeploymentsListAtTenantScope_574335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments at the tenant scope.
  ## 
  let valid = call_574341.validator(path, query, header, formData, body)
  let scheme = call_574341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574341.url(scheme.get, call_574341.host, call_574341.base,
                         call_574341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574341, url, valid)

proc call*(call_574342: Call_DeploymentsListAtTenantScope_574335;
          apiVersion: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtTenantScope
  ## Get all the deployments at the tenant scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var query_574343 = newJObject()
  add(query_574343, "api-version", newJString(apiVersion))
  add(query_574343, "$top", newJInt(Top))
  add(query_574343, "$filter", newJString(Filter))
  result = call_574342.call(nil, query_574343, nil, nil, nil)

var deploymentsListAtTenantScope* = Call_DeploymentsListAtTenantScope_574335(
    name: "deploymentsListAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtTenantScope_574336, base: "",
    url: url_DeploymentsListAtTenantScope_574337, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtTenantScope_574353 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCreateOrUpdateAtTenantScope_574355(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtTenantScope_574354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574356 = path.getOrDefault("deploymentName")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "deploymentName", valid_574356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574357 = query.getOrDefault("api-version")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "api-version", valid_574357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574359: Call_DeploymentsCreateOrUpdateAtTenantScope_574353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_574359.validator(path, query, header, formData, body)
  let scheme = call_574359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574359.url(scheme.get, call_574359.host, call_574359.base,
                         call_574359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574359, url, valid)

proc call*(call_574360: Call_DeploymentsCreateOrUpdateAtTenantScope_574353;
          apiVersion: string; deploymentName: string; parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdateAtTenantScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_574361 = newJObject()
  var query_574362 = newJObject()
  var body_574363 = newJObject()
  add(query_574362, "api-version", newJString(apiVersion))
  add(path_574361, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_574363 = parameters
  result = call_574360.call(path_574361, query_574362, nil, nil, body_574363)

var deploymentsCreateOrUpdateAtTenantScope* = Call_DeploymentsCreateOrUpdateAtTenantScope_574353(
    name: "deploymentsCreateOrUpdateAtTenantScope", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtTenantScope_574354, base: "",
    url: url_DeploymentsCreateOrUpdateAtTenantScope_574355,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtTenantScope_574373 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCheckExistenceAtTenantScope_574375(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtTenantScope_574374(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574376 = path.getOrDefault("deploymentName")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "deploymentName", valid_574376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574377 = query.getOrDefault("api-version")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "api-version", valid_574377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574378: Call_DeploymentsCheckExistenceAtTenantScope_574373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_574378.validator(path, query, header, formData, body)
  let scheme = call_574378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574378.url(scheme.get, call_574378.host, call_574378.base,
                         call_574378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574378, url, valid)

proc call*(call_574379: Call_DeploymentsCheckExistenceAtTenantScope_574373;
          apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCheckExistenceAtTenantScope
  ## Checks whether the deployment exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574380 = newJObject()
  var query_574381 = newJObject()
  add(query_574381, "api-version", newJString(apiVersion))
  add(path_574380, "deploymentName", newJString(deploymentName))
  result = call_574379.call(path_574380, query_574381, nil, nil, nil)

var deploymentsCheckExistenceAtTenantScope* = Call_DeploymentsCheckExistenceAtTenantScope_574373(
    name: "deploymentsCheckExistenceAtTenantScope", meth: HttpMethod.HttpHead,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtTenantScope_574374, base: "",
    url: url_DeploymentsCheckExistenceAtTenantScope_574375,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtTenantScope_574344 = ref object of OpenApiRestCall_573667
proc url_DeploymentsGetAtTenantScope_574346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtTenantScope_574345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574347 = path.getOrDefault("deploymentName")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "deploymentName", valid_574347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574348 = query.getOrDefault("api-version")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "api-version", valid_574348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574349: Call_DeploymentsGetAtTenantScope_574344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_574349.validator(path, query, header, formData, body)
  let scheme = call_574349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574349.url(scheme.get, call_574349.host, call_574349.base,
                         call_574349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574349, url, valid)

proc call*(call_574350: Call_DeploymentsGetAtTenantScope_574344;
          apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsGetAtTenantScope
  ## Gets a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574351 = newJObject()
  var query_574352 = newJObject()
  add(query_574352, "api-version", newJString(apiVersion))
  add(path_574351, "deploymentName", newJString(deploymentName))
  result = call_574350.call(path_574351, query_574352, nil, nil, nil)

var deploymentsGetAtTenantScope* = Call_DeploymentsGetAtTenantScope_574344(
    name: "deploymentsGetAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtTenantScope_574345, base: "",
    url: url_DeploymentsGetAtTenantScope_574346, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtTenantScope_574364 = ref object of OpenApiRestCall_573667
proc url_DeploymentsDeleteAtTenantScope_574366(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtTenantScope_574365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574367 = path.getOrDefault("deploymentName")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "deploymentName", valid_574367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574368 = query.getOrDefault("api-version")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "api-version", valid_574368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574369: Call_DeploymentsDeleteAtTenantScope_574364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_574369.validator(path, query, header, formData, body)
  let scheme = call_574369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574369.url(scheme.get, call_574369.host, call_574369.base,
                         call_574369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574369, url, valid)

proc call*(call_574370: Call_DeploymentsDeleteAtTenantScope_574364;
          apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsDeleteAtTenantScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574371 = newJObject()
  var query_574372 = newJObject()
  add(query_574372, "api-version", newJString(apiVersion))
  add(path_574371, "deploymentName", newJString(deploymentName))
  result = call_574370.call(path_574371, query_574372, nil, nil, nil)

var deploymentsDeleteAtTenantScope* = Call_DeploymentsDeleteAtTenantScope_574364(
    name: "deploymentsDeleteAtTenantScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtTenantScope_574365, base: "",
    url: url_DeploymentsDeleteAtTenantScope_574366, schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtTenantScope_574382 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCancelAtTenantScope_574384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtTenantScope_574383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574385 = path.getOrDefault("deploymentName")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "deploymentName", valid_574385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574386 = query.getOrDefault("api-version")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "api-version", valid_574386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574387: Call_DeploymentsCancelAtTenantScope_574382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_574387.validator(path, query, header, formData, body)
  let scheme = call_574387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574387.url(scheme.get, call_574387.host, call_574387.base,
                         call_574387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574387, url, valid)

proc call*(call_574388: Call_DeploymentsCancelAtTenantScope_574382;
          apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCancelAtTenantScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574389 = newJObject()
  var query_574390 = newJObject()
  add(query_574390, "api-version", newJString(apiVersion))
  add(path_574389, "deploymentName", newJString(deploymentName))
  result = call_574388.call(path_574389, query_574390, nil, nil, nil)

var deploymentsCancelAtTenantScope* = Call_DeploymentsCancelAtTenantScope_574382(
    name: "deploymentsCancelAtTenantScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtTenantScope_574383, base: "",
    url: url_DeploymentsCancelAtTenantScope_574384, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtTenantScope_574391 = ref object of OpenApiRestCall_573667
proc url_DeploymentsExportTemplateAtTenantScope_574393(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtTenantScope_574392(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574394 = path.getOrDefault("deploymentName")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "deploymentName", valid_574394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574395 = query.getOrDefault("api-version")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "api-version", valid_574395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574396: Call_DeploymentsExportTemplateAtTenantScope_574391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_574396.validator(path, query, header, formData, body)
  let scheme = call_574396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574396.url(scheme.get, call_574396.host, call_574396.base,
                         call_574396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574396, url, valid)

proc call*(call_574397: Call_DeploymentsExportTemplateAtTenantScope_574391;
          apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsExportTemplateAtTenantScope
  ## Exports the template used for specified deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_574398 = newJObject()
  var query_574399 = newJObject()
  add(query_574399, "api-version", newJString(apiVersion))
  add(path_574398, "deploymentName", newJString(deploymentName))
  result = call_574397.call(path_574398, query_574399, nil, nil, nil)

var deploymentsExportTemplateAtTenantScope* = Call_DeploymentsExportTemplateAtTenantScope_574391(
    name: "deploymentsExportTemplateAtTenantScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtTenantScope_574392, base: "",
    url: url_DeploymentsExportTemplateAtTenantScope_574393,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtTenantScope_574400 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsListAtTenantScope_574402(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtTenantScope_574401(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574403 = path.getOrDefault("deploymentName")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "deploymentName", valid_574403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574404 = query.getOrDefault("api-version")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = nil)
  if valid_574404 != nil:
    section.add "api-version", valid_574404
  var valid_574405 = query.getOrDefault("$top")
  valid_574405 = validateParameter(valid_574405, JInt, required = false, default = nil)
  if valid_574405 != nil:
    section.add "$top", valid_574405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574406: Call_DeploymentOperationsListAtTenantScope_574400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_574406.validator(path, query, header, formData, body)
  let scheme = call_574406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574406.url(scheme.get, call_574406.host, call_574406.base,
                         call_574406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574406, url, valid)

proc call*(call_574407: Call_DeploymentOperationsListAtTenantScope_574400;
          apiVersion: string; deploymentName: string; Top: int = 0): Recallable =
  ## deploymentOperationsListAtTenantScope
  ## Gets all deployments operations for a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   Top: int
  ##      : The number of results to return.
  var path_574408 = newJObject()
  var query_574409 = newJObject()
  add(query_574409, "api-version", newJString(apiVersion))
  add(path_574408, "deploymentName", newJString(deploymentName))
  add(query_574409, "$top", newJInt(Top))
  result = call_574407.call(path_574408, query_574409, nil, nil, nil)

var deploymentOperationsListAtTenantScope* = Call_DeploymentOperationsListAtTenantScope_574400(
    name: "deploymentOperationsListAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtTenantScope_574401, base: "",
    url: url_DeploymentOperationsListAtTenantScope_574402, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtTenantScope_574410 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsGetAtTenantScope_574412(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtTenantScope_574411(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574413 = path.getOrDefault("deploymentName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "deploymentName", valid_574413
  var valid_574414 = path.getOrDefault("operationId")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "operationId", valid_574414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574415 = query.getOrDefault("api-version")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "api-version", valid_574415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574416: Call_DeploymentOperationsGetAtTenantScope_574410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_574416.validator(path, query, header, formData, body)
  let scheme = call_574416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574416.url(scheme.get, call_574416.host, call_574416.base,
                         call_574416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574416, url, valid)

proc call*(call_574417: Call_DeploymentOperationsGetAtTenantScope_574410;
          apiVersion: string; deploymentName: string; operationId: string): Recallable =
  ## deploymentOperationsGetAtTenantScope
  ## Gets a deployments operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_574418 = newJObject()
  var query_574419 = newJObject()
  add(query_574419, "api-version", newJString(apiVersion))
  add(path_574418, "deploymentName", newJString(deploymentName))
  add(path_574418, "operationId", newJString(operationId))
  result = call_574417.call(path_574418, query_574419, nil, nil, nil)

var deploymentOperationsGetAtTenantScope* = Call_DeploymentOperationsGetAtTenantScope_574410(
    name: "deploymentOperationsGetAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtTenantScope_574411, base: "",
    url: url_DeploymentOperationsGetAtTenantScope_574412, schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtTenantScope_574420 = ref object of OpenApiRestCall_573667
proc url_DeploymentsValidateAtTenantScope_574422(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtTenantScope_574421(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574423 = path.getOrDefault("deploymentName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "deploymentName", valid_574423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574424 = query.getOrDefault("api-version")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "api-version", valid_574424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574426: Call_DeploymentsValidateAtTenantScope_574420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_574426.validator(path, query, header, formData, body)
  let scheme = call_574426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574426.url(scheme.get, call_574426.host, call_574426.base,
                         call_574426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574426, url, valid)

proc call*(call_574427: Call_DeploymentsValidateAtTenantScope_574420;
          apiVersion: string; deploymentName: string; parameters: JsonNode): Recallable =
  ## deploymentsValidateAtTenantScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_574428 = newJObject()
  var query_574429 = newJObject()
  var body_574430 = newJObject()
  add(query_574429, "api-version", newJString(apiVersion))
  add(path_574428, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_574430 = parameters
  result = call_574427.call(path_574428, query_574429, nil, nil, body_574430)

var deploymentsValidateAtTenantScope* = Call_DeploymentsValidateAtTenantScope_574420(
    name: "deploymentsValidateAtTenantScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtTenantScope_574421, base: "",
    url: url_DeploymentsValidateAtTenantScope_574422, schemes: {Scheme.Https})
type
  Call_OperationsList_574431 = ref object of OpenApiRestCall_573667
proc url_OperationsList_574433(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574432(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574434 = query.getOrDefault("api-version")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "api-version", valid_574434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574435: Call_OperationsList_574431; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_574435.validator(path, query, header, formData, body)
  let scheme = call_574435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574435.url(scheme.get, call_574435.host, call_574435.base,
                         call_574435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574435, url, valid)

proc call*(call_574436: Call_OperationsList_574431; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_574437 = newJObject()
  add(query_574437, "api-version", newJString(apiVersion))
  result = call_574436.call(nil, query_574437, nil, nil, nil)

var operationsList* = Call_OperationsList_574431(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_574432, base: "", url: url_OperationsList_574433,
    schemes: {Scheme.Https})
type
  Call_ProvidersGetAtTenantScope_574438 = ref object of OpenApiRestCall_573667
proc url_ProvidersGetAtTenantScope_574440(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersGetAtTenantScope_574439(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified resource provider at the tenant level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
  var valid_574441 = path.getOrDefault("resourceProviderNamespace")
  valid_574441 = validateParameter(valid_574441, JString, required = true,
                                 default = nil)
  if valid_574441 != nil:
    section.add "resourceProviderNamespace", valid_574441
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_574442 = query.getOrDefault("$expand")
  valid_574442 = validateParameter(valid_574442, JString, required = false,
                                 default = nil)
  if valid_574442 != nil:
    section.add "$expand", valid_574442
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574443 = query.getOrDefault("api-version")
  valid_574443 = validateParameter(valid_574443, JString, required = true,
                                 default = nil)
  if valid_574443 != nil:
    section.add "api-version", valid_574443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574444: Call_ProvidersGetAtTenantScope_574438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider at the tenant level.
  ## 
  let valid = call_574444.validator(path, query, header, formData, body)
  let scheme = call_574444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574444.url(scheme.get, call_574444.host, call_574444.base,
                         call_574444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574444, url, valid)

proc call*(call_574445: Call_ProvidersGetAtTenantScope_574438; apiVersion: string;
          resourceProviderNamespace: string; Expand: string = ""): Recallable =
  ## providersGetAtTenantScope
  ## Gets the specified resource provider at the tenant level.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_574446 = newJObject()
  var query_574447 = newJObject()
  add(query_574447, "$expand", newJString(Expand))
  add(query_574447, "api-version", newJString(apiVersion))
  add(path_574446, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_574445.call(path_574446, query_574447, nil, nil, nil)

var providersGetAtTenantScope* = Call_ProvidersGetAtTenantScope_574438(
    name: "providersGetAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGetAtTenantScope_574439, base: "",
    url: url_ProvidersGetAtTenantScope_574440, schemes: {Scheme.Https})
type
  Call_ProvidersList_574448 = ref object of OpenApiRestCall_573667
proc url_ProvidersList_574450(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersList_574449(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all resource providers for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574451 = path.getOrDefault("subscriptionId")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "subscriptionId", valid_574451
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed returns all deployments.
  section = newJObject()
  var valid_574452 = query.getOrDefault("$expand")
  valid_574452 = validateParameter(valid_574452, JString, required = false,
                                 default = nil)
  if valid_574452 != nil:
    section.add "$expand", valid_574452
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574453 = query.getOrDefault("api-version")
  valid_574453 = validateParameter(valid_574453, JString, required = true,
                                 default = nil)
  if valid_574453 != nil:
    section.add "api-version", valid_574453
  var valid_574454 = query.getOrDefault("$top")
  valid_574454 = validateParameter(valid_574454, JInt, required = false, default = nil)
  if valid_574454 != nil:
    section.add "$top", valid_574454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574455: Call_ProvidersList_574448; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for a subscription.
  ## 
  let valid = call_574455.validator(path, query, header, formData, body)
  let scheme = call_574455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574455.url(scheme.get, call_574455.host, call_574455.base,
                         call_574455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574455, url, valid)

proc call*(call_574456: Call_ProvidersList_574448; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0): Recallable =
  ## providersList
  ## Gets all resource providers for a subscription.
  ##   Expand: string
  ##         : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed returns all deployments.
  var path_574457 = newJObject()
  var query_574458 = newJObject()
  add(query_574458, "$expand", newJString(Expand))
  add(query_574458, "api-version", newJString(apiVersion))
  add(path_574457, "subscriptionId", newJString(subscriptionId))
  add(query_574458, "$top", newJInt(Top))
  result = call_574456.call(path_574457, query_574458, nil, nil, nil)

var providersList* = Call_ProvidersList_574448(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_574449, base: "", url: url_ProvidersList_574450,
    schemes: {Scheme.Https})
type
  Call_DeploymentsListAtSubscriptionScope_574459 = ref object of OpenApiRestCall_573667
proc url_DeploymentsListAtSubscriptionScope_574461(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListAtSubscriptionScope_574460(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574462 = path.getOrDefault("subscriptionId")
  valid_574462 = validateParameter(valid_574462, JString, required = true,
                                 default = nil)
  if valid_574462 != nil:
    section.add "subscriptionId", valid_574462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574463 = query.getOrDefault("api-version")
  valid_574463 = validateParameter(valid_574463, JString, required = true,
                                 default = nil)
  if valid_574463 != nil:
    section.add "api-version", valid_574463
  var valid_574464 = query.getOrDefault("$top")
  valid_574464 = validateParameter(valid_574464, JInt, required = false, default = nil)
  if valid_574464 != nil:
    section.add "$top", valid_574464
  var valid_574465 = query.getOrDefault("$filter")
  valid_574465 = validateParameter(valid_574465, JString, required = false,
                                 default = nil)
  if valid_574465 != nil:
    section.add "$filter", valid_574465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574466: Call_DeploymentsListAtSubscriptionScope_574459;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a subscription.
  ## 
  let valid = call_574466.validator(path, query, header, formData, body)
  let scheme = call_574466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574466.url(scheme.get, call_574466.host, call_574466.base,
                         call_574466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574466, url, valid)

proc call*(call_574467: Call_DeploymentsListAtSubscriptionScope_574459;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtSubscriptionScope
  ## Get all the deployments for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_574468 = newJObject()
  var query_574469 = newJObject()
  add(query_574469, "api-version", newJString(apiVersion))
  add(path_574468, "subscriptionId", newJString(subscriptionId))
  add(query_574469, "$top", newJInt(Top))
  add(query_574469, "$filter", newJString(Filter))
  result = call_574467.call(path_574468, query_574469, nil, nil, nil)

var deploymentsListAtSubscriptionScope* = Call_DeploymentsListAtSubscriptionScope_574459(
    name: "deploymentsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtSubscriptionScope_574460, base: "",
    url: url_DeploymentsListAtSubscriptionScope_574461, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtSubscriptionScope_574480 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCreateOrUpdateAtSubscriptionScope_574482(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtSubscriptionScope_574481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574483 = path.getOrDefault("deploymentName")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "deploymentName", valid_574483
  var valid_574484 = path.getOrDefault("subscriptionId")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "subscriptionId", valid_574484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574485 = query.getOrDefault("api-version")
  valid_574485 = validateParameter(valid_574485, JString, required = true,
                                 default = nil)
  if valid_574485 != nil:
    section.add "api-version", valid_574485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574487: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_574480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_574487.validator(path, query, header, formData, body)
  let scheme = call_574487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574487.url(scheme.get, call_574487.host, call_574487.base,
                         call_574487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574487, url, valid)

proc call*(call_574488: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_574480;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdateAtSubscriptionScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_574489 = newJObject()
  var query_574490 = newJObject()
  var body_574491 = newJObject()
  add(query_574490, "api-version", newJString(apiVersion))
  add(path_574489, "deploymentName", newJString(deploymentName))
  add(path_574489, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574491 = parameters
  result = call_574488.call(path_574489, query_574490, nil, nil, body_574491)

var deploymentsCreateOrUpdateAtSubscriptionScope* = Call_DeploymentsCreateOrUpdateAtSubscriptionScope_574480(
    name: "deploymentsCreateOrUpdateAtSubscriptionScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtSubscriptionScope_574481,
    base: "", url: url_DeploymentsCreateOrUpdateAtSubscriptionScope_574482,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtSubscriptionScope_574502 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCheckExistenceAtSubscriptionScope_574504(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtSubscriptionScope_574503(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574505 = path.getOrDefault("deploymentName")
  valid_574505 = validateParameter(valid_574505, JString, required = true,
                                 default = nil)
  if valid_574505 != nil:
    section.add "deploymentName", valid_574505
  var valid_574506 = path.getOrDefault("subscriptionId")
  valid_574506 = validateParameter(valid_574506, JString, required = true,
                                 default = nil)
  if valid_574506 != nil:
    section.add "subscriptionId", valid_574506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574507 = query.getOrDefault("api-version")
  valid_574507 = validateParameter(valid_574507, JString, required = true,
                                 default = nil)
  if valid_574507 != nil:
    section.add "api-version", valid_574507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574508: Call_DeploymentsCheckExistenceAtSubscriptionScope_574502;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_574508.validator(path, query, header, formData, body)
  let scheme = call_574508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574508.url(scheme.get, call_574508.host, call_574508.base,
                         call_574508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574508, url, valid)

proc call*(call_574509: Call_DeploymentsCheckExistenceAtSubscriptionScope_574502;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCheckExistenceAtSubscriptionScope
  ## Checks whether the deployment exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574510 = newJObject()
  var query_574511 = newJObject()
  add(query_574511, "api-version", newJString(apiVersion))
  add(path_574510, "deploymentName", newJString(deploymentName))
  add(path_574510, "subscriptionId", newJString(subscriptionId))
  result = call_574509.call(path_574510, query_574511, nil, nil, nil)

var deploymentsCheckExistenceAtSubscriptionScope* = Call_DeploymentsCheckExistenceAtSubscriptionScope_574502(
    name: "deploymentsCheckExistenceAtSubscriptionScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtSubscriptionScope_574503,
    base: "", url: url_DeploymentsCheckExistenceAtSubscriptionScope_574504,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtSubscriptionScope_574470 = ref object of OpenApiRestCall_573667
proc url_DeploymentsGetAtSubscriptionScope_574472(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtSubscriptionScope_574471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574473 = path.getOrDefault("deploymentName")
  valid_574473 = validateParameter(valid_574473, JString, required = true,
                                 default = nil)
  if valid_574473 != nil:
    section.add "deploymentName", valid_574473
  var valid_574474 = path.getOrDefault("subscriptionId")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "subscriptionId", valid_574474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574475 = query.getOrDefault("api-version")
  valid_574475 = validateParameter(valid_574475, JString, required = true,
                                 default = nil)
  if valid_574475 != nil:
    section.add "api-version", valid_574475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574476: Call_DeploymentsGetAtSubscriptionScope_574470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_574476.validator(path, query, header, formData, body)
  let scheme = call_574476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574476.url(scheme.get, call_574476.host, call_574476.base,
                         call_574476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574476, url, valid)

proc call*(call_574477: Call_DeploymentsGetAtSubscriptionScope_574470;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGetAtSubscriptionScope
  ## Gets a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574478 = newJObject()
  var query_574479 = newJObject()
  add(query_574479, "api-version", newJString(apiVersion))
  add(path_574478, "deploymentName", newJString(deploymentName))
  add(path_574478, "subscriptionId", newJString(subscriptionId))
  result = call_574477.call(path_574478, query_574479, nil, nil, nil)

var deploymentsGetAtSubscriptionScope* = Call_DeploymentsGetAtSubscriptionScope_574470(
    name: "deploymentsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtSubscriptionScope_574471, base: "",
    url: url_DeploymentsGetAtSubscriptionScope_574472, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtSubscriptionScope_574492 = ref object of OpenApiRestCall_573667
proc url_DeploymentsDeleteAtSubscriptionScope_574494(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtSubscriptionScope_574493(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574495 = path.getOrDefault("deploymentName")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "deploymentName", valid_574495
  var valid_574496 = path.getOrDefault("subscriptionId")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "subscriptionId", valid_574496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574497 = query.getOrDefault("api-version")
  valid_574497 = validateParameter(valid_574497, JString, required = true,
                                 default = nil)
  if valid_574497 != nil:
    section.add "api-version", valid_574497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574498: Call_DeploymentsDeleteAtSubscriptionScope_574492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_574498.validator(path, query, header, formData, body)
  let scheme = call_574498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574498.url(scheme.get, call_574498.host, call_574498.base,
                         call_574498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574498, url, valid)

proc call*(call_574499: Call_DeploymentsDeleteAtSubscriptionScope_574492;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDeleteAtSubscriptionScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574500 = newJObject()
  var query_574501 = newJObject()
  add(query_574501, "api-version", newJString(apiVersion))
  add(path_574500, "deploymentName", newJString(deploymentName))
  add(path_574500, "subscriptionId", newJString(subscriptionId))
  result = call_574499.call(path_574500, query_574501, nil, nil, nil)

var deploymentsDeleteAtSubscriptionScope* = Call_DeploymentsDeleteAtSubscriptionScope_574492(
    name: "deploymentsDeleteAtSubscriptionScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtSubscriptionScope_574493, base: "",
    url: url_DeploymentsDeleteAtSubscriptionScope_574494, schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtSubscriptionScope_574512 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCancelAtSubscriptionScope_574514(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtSubscriptionScope_574513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574515 = path.getOrDefault("deploymentName")
  valid_574515 = validateParameter(valid_574515, JString, required = true,
                                 default = nil)
  if valid_574515 != nil:
    section.add "deploymentName", valid_574515
  var valid_574516 = path.getOrDefault("subscriptionId")
  valid_574516 = validateParameter(valid_574516, JString, required = true,
                                 default = nil)
  if valid_574516 != nil:
    section.add "subscriptionId", valid_574516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574517 = query.getOrDefault("api-version")
  valid_574517 = validateParameter(valid_574517, JString, required = true,
                                 default = nil)
  if valid_574517 != nil:
    section.add "api-version", valid_574517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574518: Call_DeploymentsCancelAtSubscriptionScope_574512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_574518.validator(path, query, header, formData, body)
  let scheme = call_574518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574518.url(scheme.get, call_574518.host, call_574518.base,
                         call_574518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574518, url, valid)

proc call*(call_574519: Call_DeploymentsCancelAtSubscriptionScope_574512;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancelAtSubscriptionScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574520 = newJObject()
  var query_574521 = newJObject()
  add(query_574521, "api-version", newJString(apiVersion))
  add(path_574520, "deploymentName", newJString(deploymentName))
  add(path_574520, "subscriptionId", newJString(subscriptionId))
  result = call_574519.call(path_574520, query_574521, nil, nil, nil)

var deploymentsCancelAtSubscriptionScope* = Call_DeploymentsCancelAtSubscriptionScope_574512(
    name: "deploymentsCancelAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtSubscriptionScope_574513, base: "",
    url: url_DeploymentsCancelAtSubscriptionScope_574514, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtSubscriptionScope_574522 = ref object of OpenApiRestCall_573667
proc url_DeploymentsExportTemplateAtSubscriptionScope_574524(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtSubscriptionScope_574523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574525 = path.getOrDefault("deploymentName")
  valid_574525 = validateParameter(valid_574525, JString, required = true,
                                 default = nil)
  if valid_574525 != nil:
    section.add "deploymentName", valid_574525
  var valid_574526 = path.getOrDefault("subscriptionId")
  valid_574526 = validateParameter(valid_574526, JString, required = true,
                                 default = nil)
  if valid_574526 != nil:
    section.add "subscriptionId", valid_574526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574527 = query.getOrDefault("api-version")
  valid_574527 = validateParameter(valid_574527, JString, required = true,
                                 default = nil)
  if valid_574527 != nil:
    section.add "api-version", valid_574527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574528: Call_DeploymentsExportTemplateAtSubscriptionScope_574522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_574528.validator(path, query, header, formData, body)
  let scheme = call_574528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574528.url(scheme.get, call_574528.host, call_574528.base,
                         call_574528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574528, url, valid)

proc call*(call_574529: Call_DeploymentsExportTemplateAtSubscriptionScope_574522;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsExportTemplateAtSubscriptionScope
  ## Exports the template used for specified deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574530 = newJObject()
  var query_574531 = newJObject()
  add(query_574531, "api-version", newJString(apiVersion))
  add(path_574530, "deploymentName", newJString(deploymentName))
  add(path_574530, "subscriptionId", newJString(subscriptionId))
  result = call_574529.call(path_574530, query_574531, nil, nil, nil)

var deploymentsExportTemplateAtSubscriptionScope* = Call_DeploymentsExportTemplateAtSubscriptionScope_574522(
    name: "deploymentsExportTemplateAtSubscriptionScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtSubscriptionScope_574523,
    base: "", url: url_DeploymentsExportTemplateAtSubscriptionScope_574524,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtSubscriptionScope_574532 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsListAtSubscriptionScope_574534(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtSubscriptionScope_574533(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574535 = path.getOrDefault("deploymentName")
  valid_574535 = validateParameter(valid_574535, JString, required = true,
                                 default = nil)
  if valid_574535 != nil:
    section.add "deploymentName", valid_574535
  var valid_574536 = path.getOrDefault("subscriptionId")
  valid_574536 = validateParameter(valid_574536, JString, required = true,
                                 default = nil)
  if valid_574536 != nil:
    section.add "subscriptionId", valid_574536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574537 = query.getOrDefault("api-version")
  valid_574537 = validateParameter(valid_574537, JString, required = true,
                                 default = nil)
  if valid_574537 != nil:
    section.add "api-version", valid_574537
  var valid_574538 = query.getOrDefault("$top")
  valid_574538 = validateParameter(valid_574538, JInt, required = false, default = nil)
  if valid_574538 != nil:
    section.add "$top", valid_574538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574539: Call_DeploymentOperationsListAtSubscriptionScope_574532;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_574539.validator(path, query, header, formData, body)
  let scheme = call_574539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574539.url(scheme.get, call_574539.host, call_574539.base,
                         call_574539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574539, url, valid)

proc call*(call_574540: Call_DeploymentOperationsListAtSubscriptionScope_574532;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## deploymentOperationsListAtSubscriptionScope
  ## Gets all deployments operations for a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_574541 = newJObject()
  var query_574542 = newJObject()
  add(query_574542, "api-version", newJString(apiVersion))
  add(path_574541, "deploymentName", newJString(deploymentName))
  add(path_574541, "subscriptionId", newJString(subscriptionId))
  add(query_574542, "$top", newJInt(Top))
  result = call_574540.call(path_574541, query_574542, nil, nil, nil)

var deploymentOperationsListAtSubscriptionScope* = Call_DeploymentOperationsListAtSubscriptionScope_574532(
    name: "deploymentOperationsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtSubscriptionScope_574533,
    base: "", url: url_DeploymentOperationsListAtSubscriptionScope_574534,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtSubscriptionScope_574543 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsGetAtSubscriptionScope_574545(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtSubscriptionScope_574544(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574546 = path.getOrDefault("deploymentName")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "deploymentName", valid_574546
  var valid_574547 = path.getOrDefault("subscriptionId")
  valid_574547 = validateParameter(valid_574547, JString, required = true,
                                 default = nil)
  if valid_574547 != nil:
    section.add "subscriptionId", valid_574547
  var valid_574548 = path.getOrDefault("operationId")
  valid_574548 = validateParameter(valid_574548, JString, required = true,
                                 default = nil)
  if valid_574548 != nil:
    section.add "operationId", valid_574548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574549 = query.getOrDefault("api-version")
  valid_574549 = validateParameter(valid_574549, JString, required = true,
                                 default = nil)
  if valid_574549 != nil:
    section.add "api-version", valid_574549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574550: Call_DeploymentOperationsGetAtSubscriptionScope_574543;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_574550.validator(path, query, header, formData, body)
  let scheme = call_574550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574550.url(scheme.get, call_574550.host, call_574550.base,
                         call_574550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574550, url, valid)

proc call*(call_574551: Call_DeploymentOperationsGetAtSubscriptionScope_574543;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          operationId: string): Recallable =
  ## deploymentOperationsGetAtSubscriptionScope
  ## Gets a deployments operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_574552 = newJObject()
  var query_574553 = newJObject()
  add(query_574553, "api-version", newJString(apiVersion))
  add(path_574552, "deploymentName", newJString(deploymentName))
  add(path_574552, "subscriptionId", newJString(subscriptionId))
  add(path_574552, "operationId", newJString(operationId))
  result = call_574551.call(path_574552, query_574553, nil, nil, nil)

var deploymentOperationsGetAtSubscriptionScope* = Call_DeploymentOperationsGetAtSubscriptionScope_574543(
    name: "deploymentOperationsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtSubscriptionScope_574544,
    base: "", url: url_DeploymentOperationsGetAtSubscriptionScope_574545,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtSubscriptionScope_574554 = ref object of OpenApiRestCall_573667
proc url_DeploymentsValidateAtSubscriptionScope_574556(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtSubscriptionScope_574555(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574557 = path.getOrDefault("deploymentName")
  valid_574557 = validateParameter(valid_574557, JString, required = true,
                                 default = nil)
  if valid_574557 != nil:
    section.add "deploymentName", valid_574557
  var valid_574558 = path.getOrDefault("subscriptionId")
  valid_574558 = validateParameter(valid_574558, JString, required = true,
                                 default = nil)
  if valid_574558 != nil:
    section.add "subscriptionId", valid_574558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574559 = query.getOrDefault("api-version")
  valid_574559 = validateParameter(valid_574559, JString, required = true,
                                 default = nil)
  if valid_574559 != nil:
    section.add "api-version", valid_574559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574561: Call_DeploymentsValidateAtSubscriptionScope_574554;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_574561.validator(path, query, header, formData, body)
  let scheme = call_574561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574561.url(scheme.get, call_574561.host, call_574561.base,
                         call_574561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574561, url, valid)

proc call*(call_574562: Call_DeploymentsValidateAtSubscriptionScope_574554;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidateAtSubscriptionScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_574563 = newJObject()
  var query_574564 = newJObject()
  var body_574565 = newJObject()
  add(query_574564, "api-version", newJString(apiVersion))
  add(path_574563, "deploymentName", newJString(deploymentName))
  add(path_574563, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574565 = parameters
  result = call_574562.call(path_574563, query_574564, nil, nil, body_574565)

var deploymentsValidateAtSubscriptionScope* = Call_DeploymentsValidateAtSubscriptionScope_574554(
    name: "deploymentsValidateAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtSubscriptionScope_574555, base: "",
    url: url_DeploymentsValidateAtSubscriptionScope_574556,
    schemes: {Scheme.Https})
type
  Call_DeploymentsWhatIfAtSubscriptionScope_574566 = ref object of OpenApiRestCall_573667
proc url_DeploymentsWhatIfAtSubscriptionScope_574568(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/whatIf")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsWhatIfAtSubscriptionScope_574567(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns changes that will be made by the deployment if executed at the scope of the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_574569 = path.getOrDefault("deploymentName")
  valid_574569 = validateParameter(valid_574569, JString, required = true,
                                 default = nil)
  if valid_574569 != nil:
    section.add "deploymentName", valid_574569
  var valid_574570 = path.getOrDefault("subscriptionId")
  valid_574570 = validateParameter(valid_574570, JString, required = true,
                                 default = nil)
  if valid_574570 != nil:
    section.add "subscriptionId", valid_574570
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574571 = query.getOrDefault("api-version")
  valid_574571 = validateParameter(valid_574571, JString, required = true,
                                 default = nil)
  if valid_574571 != nil:
    section.add "api-version", valid_574571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to What If.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574573: Call_DeploymentsWhatIfAtSubscriptionScope_574566;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns changes that will be made by the deployment if executed at the scope of the subscription.
  ## 
  let valid = call_574573.validator(path, query, header, formData, body)
  let scheme = call_574573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574573.url(scheme.get, call_574573.host, call_574573.base,
                         call_574573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574573, url, valid)

proc call*(call_574574: Call_DeploymentsWhatIfAtSubscriptionScope_574566;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsWhatIfAtSubscriptionScope
  ## Returns changes that will be made by the deployment if executed at the scope of the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to What If.
  var path_574575 = newJObject()
  var query_574576 = newJObject()
  var body_574577 = newJObject()
  add(query_574576, "api-version", newJString(apiVersion))
  add(path_574575, "deploymentName", newJString(deploymentName))
  add(path_574575, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574577 = parameters
  result = call_574574.call(path_574575, query_574576, nil, nil, body_574577)

var deploymentsWhatIfAtSubscriptionScope* = Call_DeploymentsWhatIfAtSubscriptionScope_574566(
    name: "deploymentsWhatIfAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/whatIf",
    validator: validate_DeploymentsWhatIfAtSubscriptionScope_574567, base: "",
    url: url_DeploymentsWhatIfAtSubscriptionScope_574568, schemes: {Scheme.Https})
type
  Call_ProvidersGet_574578 = ref object of OpenApiRestCall_573667
proc url_ProvidersGet_574580(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersGet_574579(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574581 = path.getOrDefault("subscriptionId")
  valid_574581 = validateParameter(valid_574581, JString, required = true,
                                 default = nil)
  if valid_574581 != nil:
    section.add "subscriptionId", valid_574581
  var valid_574582 = path.getOrDefault("resourceProviderNamespace")
  valid_574582 = validateParameter(valid_574582, JString, required = true,
                                 default = nil)
  if valid_574582 != nil:
    section.add "resourceProviderNamespace", valid_574582
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_574583 = query.getOrDefault("$expand")
  valid_574583 = validateParameter(valid_574583, JString, required = false,
                                 default = nil)
  if valid_574583 != nil:
    section.add "$expand", valid_574583
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574584 = query.getOrDefault("api-version")
  valid_574584 = validateParameter(valid_574584, JString, required = true,
                                 default = nil)
  if valid_574584 != nil:
    section.add "api-version", valid_574584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574585: Call_ProvidersGet_574578; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider.
  ## 
  let valid = call_574585.validator(path, query, header, formData, body)
  let scheme = call_574585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574585.url(scheme.get, call_574585.host, call_574585.base,
                         call_574585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574585, url, valid)

proc call*(call_574586: Call_ProvidersGet_574578; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string;
          Expand: string = ""): Recallable =
  ## providersGet
  ## Gets the specified resource provider.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_574587 = newJObject()
  var query_574588 = newJObject()
  add(query_574588, "$expand", newJString(Expand))
  add(query_574588, "api-version", newJString(apiVersion))
  add(path_574587, "subscriptionId", newJString(subscriptionId))
  add(path_574587, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_574586.call(path_574587, query_574588, nil, nil, nil)

var providersGet* = Call_ProvidersGet_574578(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_574579, base: "", url: url_ProvidersGet_574580,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_574589 = ref object of OpenApiRestCall_573667
proc url_ProvidersRegister_574591(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersRegister_574590(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Registers a subscription with a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to register.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574592 = path.getOrDefault("subscriptionId")
  valid_574592 = validateParameter(valid_574592, JString, required = true,
                                 default = nil)
  if valid_574592 != nil:
    section.add "subscriptionId", valid_574592
  var valid_574593 = path.getOrDefault("resourceProviderNamespace")
  valid_574593 = validateParameter(valid_574593, JString, required = true,
                                 default = nil)
  if valid_574593 != nil:
    section.add "resourceProviderNamespace", valid_574593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574594 = query.getOrDefault("api-version")
  valid_574594 = validateParameter(valid_574594, JString, required = true,
                                 default = nil)
  if valid_574594 != nil:
    section.add "api-version", valid_574594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574595: Call_ProvidersRegister_574589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a subscription with a resource provider.
  ## 
  let valid = call_574595.validator(path, query, header, formData, body)
  let scheme = call_574595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574595.url(scheme.get, call_574595.host, call_574595.base,
                         call_574595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574595, url, valid)

proc call*(call_574596: Call_ProvidersRegister_574589; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers a subscription with a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to register.
  var path_574597 = newJObject()
  var query_574598 = newJObject()
  add(query_574598, "api-version", newJString(apiVersion))
  add(path_574597, "subscriptionId", newJString(subscriptionId))
  add(path_574597, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_574596.call(path_574597, query_574598, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_574589(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_574590, base: "",
    url: url_ProvidersRegister_574591, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_574599 = ref object of OpenApiRestCall_573667
proc url_ProvidersUnregister_574601(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/unregister")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersUnregister_574600(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Unregisters a subscription from a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to unregister.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574602 = path.getOrDefault("subscriptionId")
  valid_574602 = validateParameter(valid_574602, JString, required = true,
                                 default = nil)
  if valid_574602 != nil:
    section.add "subscriptionId", valid_574602
  var valid_574603 = path.getOrDefault("resourceProviderNamespace")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "resourceProviderNamespace", valid_574603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574604 = query.getOrDefault("api-version")
  valid_574604 = validateParameter(valid_574604, JString, required = true,
                                 default = nil)
  if valid_574604 != nil:
    section.add "api-version", valid_574604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574605: Call_ProvidersUnregister_574599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters a subscription from a resource provider.
  ## 
  let valid = call_574605.validator(path, query, header, formData, body)
  let scheme = call_574605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574605.url(scheme.get, call_574605.host, call_574605.base,
                         call_574605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574605, url, valid)

proc call*(call_574606: Call_ProvidersUnregister_574599; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters a subscription from a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to unregister.
  var path_574607 = newJObject()
  var query_574608 = newJObject()
  add(query_574608, "api-version", newJString(apiVersion))
  add(path_574607, "subscriptionId", newJString(subscriptionId))
  add(path_574607, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_574606.call(path_574607, query_574608, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_574599(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_574600, base: "",
    url: url_ProvidersUnregister_574601, schemes: {Scheme.Https})
type
  Call_ResourcesListByResourceGroup_574609 = ref object of OpenApiRestCall_573667
proc url_ResourcesListByResourceGroup_574611(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesListByResourceGroup_574610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group with the resources to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574612 = path.getOrDefault("resourceGroupName")
  valid_574612 = validateParameter(valid_574612, JString, required = true,
                                 default = nil)
  if valid_574612 != nil:
    section.add "resourceGroupName", valid_574612
  var valid_574613 = path.getOrDefault("subscriptionId")
  valid_574613 = validateParameter(valid_574613, JString, required = true,
                                 default = nil)
  if valid_574613 != nil:
    section.add "subscriptionId", valid_574613
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resources.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  section = newJObject()
  var valid_574614 = query.getOrDefault("$expand")
  valid_574614 = validateParameter(valid_574614, JString, required = false,
                                 default = nil)
  if valid_574614 != nil:
    section.add "$expand", valid_574614
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574615 = query.getOrDefault("api-version")
  valid_574615 = validateParameter(valid_574615, JString, required = true,
                                 default = nil)
  if valid_574615 != nil:
    section.add "api-version", valid_574615
  var valid_574616 = query.getOrDefault("$top")
  valid_574616 = validateParameter(valid_574616, JInt, required = false, default = nil)
  if valid_574616 != nil:
    section.add "$top", valid_574616
  var valid_574617 = query.getOrDefault("$filter")
  valid_574617 = validateParameter(valid_574617, JString, required = false,
                                 default = nil)
  if valid_574617 != nil:
    section.add "$filter", valid_574617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574618: Call_ResourcesListByResourceGroup_574609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources for a resource group.
  ## 
  let valid = call_574618.validator(path, query, header, formData, body)
  let scheme = call_574618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574618.url(scheme.get, call_574618.host, call_574618.base,
                         call_574618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574618, url, valid)

proc call*(call_574619: Call_ResourcesListByResourceGroup_574609;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesListByResourceGroup
  ## Get all the resources for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group with the resources to get.
  ##   Expand: string
  ##         : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resources.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  var path_574620 = newJObject()
  var query_574621 = newJObject()
  add(path_574620, "resourceGroupName", newJString(resourceGroupName))
  add(query_574621, "$expand", newJString(Expand))
  add(query_574621, "api-version", newJString(apiVersion))
  add(path_574620, "subscriptionId", newJString(subscriptionId))
  add(query_574621, "$top", newJInt(Top))
  add(query_574621, "$filter", newJString(Filter))
  result = call_574619.call(path_574620, query_574621, nil, nil, nil)

var resourcesListByResourceGroup* = Call_ResourcesListByResourceGroup_574609(
    name: "resourcesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourcesListByResourceGroup_574610, base: "",
    url: url_ResourcesListByResourceGroup_574611, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_574622 = ref object of OpenApiRestCall_573667
proc url_ResourcesMoveResources_574624(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesMoveResources_574623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_574625 = path.getOrDefault("sourceResourceGroupName")
  valid_574625 = validateParameter(valid_574625, JString, required = true,
                                 default = nil)
  if valid_574625 != nil:
    section.add "sourceResourceGroupName", valid_574625
  var valid_574626 = path.getOrDefault("subscriptionId")
  valid_574626 = validateParameter(valid_574626, JString, required = true,
                                 default = nil)
  if valid_574626 != nil:
    section.add "subscriptionId", valid_574626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574627 = query.getOrDefault("api-version")
  valid_574627 = validateParameter(valid_574627, JString, required = true,
                                 default = nil)
  if valid_574627 != nil:
    section.add "api-version", valid_574627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574629: Call_ResourcesMoveResources_574622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  let valid = call_574629.validator(path, query, header, formData, body)
  let scheme = call_574629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574629.url(scheme.get, call_574629.host, call_574629.base,
                         call_574629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574629, url, valid)

proc call*(call_574630: Call_ResourcesMoveResources_574622; apiVersion: string;
          sourceResourceGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourcesMoveResources
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_574631 = newJObject()
  var query_574632 = newJObject()
  var body_574633 = newJObject()
  add(query_574632, "api-version", newJString(apiVersion))
  add(path_574631, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_574631, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574633 = parameters
  result = call_574630.call(path_574631, query_574632, nil, nil, body_574633)

var resourcesMoveResources* = Call_ResourcesMoveResources_574622(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_574623, base: "",
    url: url_ResourcesMoveResources_574624, schemes: {Scheme.Https})
type
  Call_ResourcesValidateMoveResources_574634 = ref object of OpenApiRestCall_573667
proc url_ResourcesValidateMoveResources_574636(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/validateMoveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesValidateMoveResources_574635(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to validate for move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_574637 = path.getOrDefault("sourceResourceGroupName")
  valid_574637 = validateParameter(valid_574637, JString, required = true,
                                 default = nil)
  if valid_574637 != nil:
    section.add "sourceResourceGroupName", valid_574637
  var valid_574638 = path.getOrDefault("subscriptionId")
  valid_574638 = validateParameter(valid_574638, JString, required = true,
                                 default = nil)
  if valid_574638 != nil:
    section.add "subscriptionId", valid_574638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574639 = query.getOrDefault("api-version")
  valid_574639 = validateParameter(valid_574639, JString, required = true,
                                 default = nil)
  if valid_574639 != nil:
    section.add "api-version", valid_574639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574641: Call_ResourcesValidateMoveResources_574634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  let valid = call_574641.validator(path, query, header, formData, body)
  let scheme = call_574641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574641.url(scheme.get, call_574641.host, call_574641.base,
                         call_574641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574641, url, valid)

proc call*(call_574642: Call_ResourcesValidateMoveResources_574634;
          apiVersion: string; sourceResourceGroupName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## resourcesValidateMoveResources
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to validate for move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_574643 = newJObject()
  var query_574644 = newJObject()
  var body_574645 = newJObject()
  add(query_574644, "api-version", newJString(apiVersion))
  add(path_574643, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_574643, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574645 = parameters
  result = call_574642.call(path_574643, query_574644, nil, nil, body_574645)

var resourcesValidateMoveResources* = Call_ResourcesValidateMoveResources_574634(
    name: "resourcesValidateMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/validateMoveResources",
    validator: validate_ResourcesValidateMoveResources_574635, base: "",
    url: url_ResourcesValidateMoveResources_574636, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_574646 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsList_574648(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsList_574647(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all the resource groups for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574649 = path.getOrDefault("subscriptionId")
  valid_574649 = validateParameter(valid_574649, JString, required = true,
                                 default = nil)
  if valid_574649 != nil:
    section.add "subscriptionId", valid_574649
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574650 = query.getOrDefault("api-version")
  valid_574650 = validateParameter(valid_574650, JString, required = true,
                                 default = nil)
  if valid_574650 != nil:
    section.add "api-version", valid_574650
  var valid_574651 = query.getOrDefault("$top")
  valid_574651 = validateParameter(valid_574651, JInt, required = false, default = nil)
  if valid_574651 != nil:
    section.add "$top", valid_574651
  var valid_574652 = query.getOrDefault("$filter")
  valid_574652 = validateParameter(valid_574652, JString, required = false,
                                 default = nil)
  if valid_574652 != nil:
    section.add "$filter", valid_574652
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574653: Call_ResourceGroupsList_574646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the resource groups for a subscription.
  ## 
  let valid = call_574653.validator(path, query, header, formData, body)
  let scheme = call_574653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574653.url(scheme.get, call_574653.host, call_574653.base,
                         call_574653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574653, url, valid)

proc call*(call_574654: Call_ResourceGroupsList_574646; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsList
  ## Gets all the resource groups for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  var path_574655 = newJObject()
  var query_574656 = newJObject()
  add(query_574656, "api-version", newJString(apiVersion))
  add(path_574655, "subscriptionId", newJString(subscriptionId))
  add(query_574656, "$top", newJInt(Top))
  add(query_574656, "$filter", newJString(Filter))
  result = call_574654.call(path_574655, query_574656, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_574646(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_574647, base: "",
    url: url_ResourceGroupsList_574648, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_574667 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsCreateOrUpdate_574669(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCreateOrUpdate_574668(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to create or update. Can include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574670 = path.getOrDefault("resourceGroupName")
  valid_574670 = validateParameter(valid_574670, JString, required = true,
                                 default = nil)
  if valid_574670 != nil:
    section.add "resourceGroupName", valid_574670
  var valid_574671 = path.getOrDefault("subscriptionId")
  valid_574671 = validateParameter(valid_574671, JString, required = true,
                                 default = nil)
  if valid_574671 != nil:
    section.add "subscriptionId", valid_574671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574672 = query.getOrDefault("api-version")
  valid_574672 = validateParameter(valid_574672, JString, required = true,
                                 default = nil)
  if valid_574672 != nil:
    section.add "api-version", valid_574672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574674: Call_ResourceGroupsCreateOrUpdate_574667; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a resource group.
  ## 
  let valid = call_574674.validator(path, query, header, formData, body)
  let scheme = call_574674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574674.url(scheme.get, call_574674.host, call_574674.base,
                         call_574674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574674, url, valid)

proc call*(call_574675: Call_ResourceGroupsCreateOrUpdate_574667;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsCreateOrUpdate
  ## Creates or updates a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to create or update. Can include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  var path_574676 = newJObject()
  var query_574677 = newJObject()
  var body_574678 = newJObject()
  add(path_574676, "resourceGroupName", newJString(resourceGroupName))
  add(query_574677, "api-version", newJString(apiVersion))
  add(path_574676, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574678 = parameters
  result = call_574675.call(path_574676, query_574677, nil, nil, body_574678)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_574667(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_574668, base: "",
    url: url_ResourceGroupsCreateOrUpdate_574669, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_574689 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsCheckExistence_574691(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCheckExistence_574690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource group exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574692 = path.getOrDefault("resourceGroupName")
  valid_574692 = validateParameter(valid_574692, JString, required = true,
                                 default = nil)
  if valid_574692 != nil:
    section.add "resourceGroupName", valid_574692
  var valid_574693 = path.getOrDefault("subscriptionId")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "subscriptionId", valid_574693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574694 = query.getOrDefault("api-version")
  valid_574694 = validateParameter(valid_574694, JString, required = true,
                                 default = nil)
  if valid_574694 != nil:
    section.add "api-version", valid_574694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574695: Call_ResourceGroupsCheckExistence_574689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource group exists.
  ## 
  let valid = call_574695.validator(path, query, header, formData, body)
  let scheme = call_574695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574695.url(scheme.get, call_574695.host, call_574695.base,
                         call_574695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574695, url, valid)

proc call*(call_574696: Call_ResourceGroupsCheckExistence_574689;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether a resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574697 = newJObject()
  var query_574698 = newJObject()
  add(path_574697, "resourceGroupName", newJString(resourceGroupName))
  add(query_574698, "api-version", newJString(apiVersion))
  add(path_574697, "subscriptionId", newJString(subscriptionId))
  result = call_574696.call(path_574697, query_574698, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_574689(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_574690, base: "",
    url: url_ResourceGroupsCheckExistence_574691, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_574657 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsGet_574659(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsGet_574658(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574660 = path.getOrDefault("resourceGroupName")
  valid_574660 = validateParameter(valid_574660, JString, required = true,
                                 default = nil)
  if valid_574660 != nil:
    section.add "resourceGroupName", valid_574660
  var valid_574661 = path.getOrDefault("subscriptionId")
  valid_574661 = validateParameter(valid_574661, JString, required = true,
                                 default = nil)
  if valid_574661 != nil:
    section.add "subscriptionId", valid_574661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574662 = query.getOrDefault("api-version")
  valid_574662 = validateParameter(valid_574662, JString, required = true,
                                 default = nil)
  if valid_574662 != nil:
    section.add "api-version", valid_574662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574663: Call_ResourceGroupsGet_574657; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource group.
  ## 
  let valid = call_574663.validator(path, query, header, formData, body)
  let scheme = call_574663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574663.url(scheme.get, call_574663.host, call_574663.base,
                         call_574663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574663, url, valid)

proc call*(call_574664: Call_ResourceGroupsGet_574657; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Gets a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574665 = newJObject()
  var query_574666 = newJObject()
  add(path_574665, "resourceGroupName", newJString(resourceGroupName))
  add(query_574666, "api-version", newJString(apiVersion))
  add(path_574665, "subscriptionId", newJString(subscriptionId))
  result = call_574664.call(path_574665, query_574666, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_574657(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_574658, base: "",
    url: url_ResourceGroupsGet_574659, schemes: {Scheme.Https})
type
  Call_ResourceGroupsUpdate_574699 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsUpdate_574701(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsUpdate_574700(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574702 = path.getOrDefault("resourceGroupName")
  valid_574702 = validateParameter(valid_574702, JString, required = true,
                                 default = nil)
  if valid_574702 != nil:
    section.add "resourceGroupName", valid_574702
  var valid_574703 = path.getOrDefault("subscriptionId")
  valid_574703 = validateParameter(valid_574703, JString, required = true,
                                 default = nil)
  if valid_574703 != nil:
    section.add "subscriptionId", valid_574703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574704 = query.getOrDefault("api-version")
  valid_574704 = validateParameter(valid_574704, JString, required = true,
                                 default = nil)
  if valid_574704 != nil:
    section.add "api-version", valid_574704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574706: Call_ResourceGroupsUpdate_574699; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  let valid = call_574706.validator(path, query, header, formData, body)
  let scheme = call_574706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574706.url(scheme.get, call_574706.host, call_574706.base,
                         call_574706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574706, url, valid)

proc call*(call_574707: Call_ResourceGroupsUpdate_574699;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsUpdate
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  var path_574708 = newJObject()
  var query_574709 = newJObject()
  var body_574710 = newJObject()
  add(path_574708, "resourceGroupName", newJString(resourceGroupName))
  add(query_574709, "api-version", newJString(apiVersion))
  add(path_574708, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574710 = parameters
  result = call_574707.call(path_574708, query_574709, nil, nil, body_574710)

var resourceGroupsUpdate* = Call_ResourceGroupsUpdate_574699(
    name: "resourceGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsUpdate_574700, base: "",
    url: url_ResourceGroupsUpdate_574701, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_574679 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsDelete_574681(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsDelete_574680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574682 = path.getOrDefault("resourceGroupName")
  valid_574682 = validateParameter(valid_574682, JString, required = true,
                                 default = nil)
  if valid_574682 != nil:
    section.add "resourceGroupName", valid_574682
  var valid_574683 = path.getOrDefault("subscriptionId")
  valid_574683 = validateParameter(valid_574683, JString, required = true,
                                 default = nil)
  if valid_574683 != nil:
    section.add "subscriptionId", valid_574683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574684 = query.getOrDefault("api-version")
  valid_574684 = validateParameter(valid_574684, JString, required = true,
                                 default = nil)
  if valid_574684 != nil:
    section.add "api-version", valid_574684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574685: Call_ResourceGroupsDelete_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  let valid = call_574685.validator(path, query, header, formData, body)
  let scheme = call_574685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574685.url(scheme.get, call_574685.host, call_574685.base,
                         call_574685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574685, url, valid)

proc call*(call_574686: Call_ResourceGroupsDelete_574679;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574687 = newJObject()
  var query_574688 = newJObject()
  add(path_574687, "resourceGroupName", newJString(resourceGroupName))
  add(query_574688, "api-version", newJString(apiVersion))
  add(path_574687, "subscriptionId", newJString(subscriptionId))
  result = call_574686.call(path_574687, query_574688, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_574679(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_574680, base: "",
    url: url_ResourceGroupsDelete_574681, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_574711 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsList_574713(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsList_574712(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574714 = path.getOrDefault("resourceGroupName")
  valid_574714 = validateParameter(valid_574714, JString, required = true,
                                 default = nil)
  if valid_574714 != nil:
    section.add "resourceGroupName", valid_574714
  var valid_574715 = path.getOrDefault("deploymentName")
  valid_574715 = validateParameter(valid_574715, JString, required = true,
                                 default = nil)
  if valid_574715 != nil:
    section.add "deploymentName", valid_574715
  var valid_574716 = path.getOrDefault("subscriptionId")
  valid_574716 = validateParameter(valid_574716, JString, required = true,
                                 default = nil)
  if valid_574716 != nil:
    section.add "subscriptionId", valid_574716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574717 = query.getOrDefault("api-version")
  valid_574717 = validateParameter(valid_574717, JString, required = true,
                                 default = nil)
  if valid_574717 != nil:
    section.add "api-version", valid_574717
  var valid_574718 = query.getOrDefault("$top")
  valid_574718 = validateParameter(valid_574718, JInt, required = false, default = nil)
  if valid_574718 != nil:
    section.add "$top", valid_574718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574719: Call_DeploymentOperationsList_574711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_574719.validator(path, query, header, formData, body)
  let scheme = call_574719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574719.url(scheme.get, call_574719.host, call_574719.base,
                         call_574719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574719, url, valid)

proc call*(call_574720: Call_DeploymentOperationsList_574711;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## deploymentOperationsList
  ## Gets all deployments operations for a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_574721 = newJObject()
  var query_574722 = newJObject()
  add(path_574721, "resourceGroupName", newJString(resourceGroupName))
  add(query_574722, "api-version", newJString(apiVersion))
  add(path_574721, "deploymentName", newJString(deploymentName))
  add(path_574721, "subscriptionId", newJString(subscriptionId))
  add(query_574722, "$top", newJInt(Top))
  result = call_574720.call(path_574721, query_574722, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_574711(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_574712, base: "",
    url: url_DeploymentOperationsList_574713, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_574723 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsGet_574725(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGet_574724(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574726 = path.getOrDefault("resourceGroupName")
  valid_574726 = validateParameter(valid_574726, JString, required = true,
                                 default = nil)
  if valid_574726 != nil:
    section.add "resourceGroupName", valid_574726
  var valid_574727 = path.getOrDefault("deploymentName")
  valid_574727 = validateParameter(valid_574727, JString, required = true,
                                 default = nil)
  if valid_574727 != nil:
    section.add "deploymentName", valid_574727
  var valid_574728 = path.getOrDefault("subscriptionId")
  valid_574728 = validateParameter(valid_574728, JString, required = true,
                                 default = nil)
  if valid_574728 != nil:
    section.add "subscriptionId", valid_574728
  var valid_574729 = path.getOrDefault("operationId")
  valid_574729 = validateParameter(valid_574729, JString, required = true,
                                 default = nil)
  if valid_574729 != nil:
    section.add "operationId", valid_574729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574730 = query.getOrDefault("api-version")
  valid_574730 = validateParameter(valid_574730, JString, required = true,
                                 default = nil)
  if valid_574730 != nil:
    section.add "api-version", valid_574730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574731: Call_DeploymentOperationsGet_574723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_574731.validator(path, query, header, formData, body)
  let scheme = call_574731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574731.url(scheme.get, call_574731.host, call_574731.base,
                         call_574731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574731, url, valid)

proc call*(call_574732: Call_DeploymentOperationsGet_574723;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; operationId: string): Recallable =
  ## deploymentOperationsGet
  ## Gets a deployments operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_574733 = newJObject()
  var query_574734 = newJObject()
  add(path_574733, "resourceGroupName", newJString(resourceGroupName))
  add(query_574734, "api-version", newJString(apiVersion))
  add(path_574733, "deploymentName", newJString(deploymentName))
  add(path_574733, "subscriptionId", newJString(subscriptionId))
  add(path_574733, "operationId", newJString(operationId))
  result = call_574732.call(path_574733, query_574734, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_574723(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_574724, base: "",
    url: url_DeploymentOperationsGet_574725, schemes: {Scheme.Https})
type
  Call_ResourceGroupsExportTemplate_574735 = ref object of OpenApiRestCall_573667
proc url_ResourceGroupsExportTemplate_574737(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsExportTemplate_574736(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the specified resource group as a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to export as a template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574738 = path.getOrDefault("resourceGroupName")
  valid_574738 = validateParameter(valid_574738, JString, required = true,
                                 default = nil)
  if valid_574738 != nil:
    section.add "resourceGroupName", valid_574738
  var valid_574739 = path.getOrDefault("subscriptionId")
  valid_574739 = validateParameter(valid_574739, JString, required = true,
                                 default = nil)
  if valid_574739 != nil:
    section.add "subscriptionId", valid_574739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574740 = query.getOrDefault("api-version")
  valid_574740 = validateParameter(valid_574740, JString, required = true,
                                 default = nil)
  if valid_574740 != nil:
    section.add "api-version", valid_574740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574742: Call_ResourceGroupsExportTemplate_574735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the specified resource group as a template.
  ## 
  let valid = call_574742.validator(path, query, header, formData, body)
  let scheme = call_574742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574742.url(scheme.get, call_574742.host, call_574742.base,
                         call_574742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574742, url, valid)

proc call*(call_574743: Call_ResourceGroupsExportTemplate_574735;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsExportTemplate
  ## Captures the specified resource group as a template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to export as a template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  var path_574744 = newJObject()
  var query_574745 = newJObject()
  var body_574746 = newJObject()
  add(path_574744, "resourceGroupName", newJString(resourceGroupName))
  add(query_574745, "api-version", newJString(apiVersion))
  add(path_574744, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574746 = parameters
  result = call_574743.call(path_574744, query_574745, nil, nil, body_574746)

var resourceGroupsExportTemplate* = Call_ResourceGroupsExportTemplate_574735(
    name: "resourceGroupsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/exportTemplate",
    validator: validate_ResourceGroupsExportTemplate_574736, base: "",
    url: url_ResourceGroupsExportTemplate_574737, schemes: {Scheme.Https})
type
  Call_DeploymentsListByResourceGroup_574747 = ref object of OpenApiRestCall_573667
proc url_DeploymentsListByResourceGroup_574749(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListByResourceGroup_574748(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574750 = path.getOrDefault("resourceGroupName")
  valid_574750 = validateParameter(valid_574750, JString, required = true,
                                 default = nil)
  if valid_574750 != nil:
    section.add "resourceGroupName", valid_574750
  var valid_574751 = path.getOrDefault("subscriptionId")
  valid_574751 = validateParameter(valid_574751, JString, required = true,
                                 default = nil)
  if valid_574751 != nil:
    section.add "subscriptionId", valid_574751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574752 = query.getOrDefault("api-version")
  valid_574752 = validateParameter(valid_574752, JString, required = true,
                                 default = nil)
  if valid_574752 != nil:
    section.add "api-version", valid_574752
  var valid_574753 = query.getOrDefault("$top")
  valid_574753 = validateParameter(valid_574753, JInt, required = false, default = nil)
  if valid_574753 != nil:
    section.add "$top", valid_574753
  var valid_574754 = query.getOrDefault("$filter")
  valid_574754 = validateParameter(valid_574754, JString, required = false,
                                 default = nil)
  if valid_574754 != nil:
    section.add "$filter", valid_574754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574755: Call_DeploymentsListByResourceGroup_574747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments for a resource group.
  ## 
  let valid = call_574755.validator(path, query, header, formData, body)
  let scheme = call_574755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574755.url(scheme.get, call_574755.host, call_574755.base,
                         call_574755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574755, url, valid)

proc call*(call_574756: Call_DeploymentsListByResourceGroup_574747;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListByResourceGroup
  ## Get all the deployments for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_574757 = newJObject()
  var query_574758 = newJObject()
  add(path_574757, "resourceGroupName", newJString(resourceGroupName))
  add(query_574758, "api-version", newJString(apiVersion))
  add(path_574757, "subscriptionId", newJString(subscriptionId))
  add(query_574758, "$top", newJInt(Top))
  add(query_574758, "$filter", newJString(Filter))
  result = call_574756.call(path_574757, query_574758, nil, nil, nil)

var deploymentsListByResourceGroup* = Call_DeploymentsListByResourceGroup_574747(
    name: "deploymentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListByResourceGroup_574748, base: "",
    url: url_DeploymentsListByResourceGroup_574749, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_574770 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCreateOrUpdate_574772(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdate_574771(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574773 = path.getOrDefault("resourceGroupName")
  valid_574773 = validateParameter(valid_574773, JString, required = true,
                                 default = nil)
  if valid_574773 != nil:
    section.add "resourceGroupName", valid_574773
  var valid_574774 = path.getOrDefault("deploymentName")
  valid_574774 = validateParameter(valid_574774, JString, required = true,
                                 default = nil)
  if valid_574774 != nil:
    section.add "deploymentName", valid_574774
  var valid_574775 = path.getOrDefault("subscriptionId")
  valid_574775 = validateParameter(valid_574775, JString, required = true,
                                 default = nil)
  if valid_574775 != nil:
    section.add "subscriptionId", valid_574775
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574776 = query.getOrDefault("api-version")
  valid_574776 = validateParameter(valid_574776, JString, required = true,
                                 default = nil)
  if valid_574776 != nil:
    section.add "api-version", valid_574776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574778: Call_DeploymentsCreateOrUpdate_574770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_574778.validator(path, query, header, formData, body)
  let scheme = call_574778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574778.url(scheme.get, call_574778.host, call_574778.base,
                         call_574778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574778, url, valid)

proc call*(call_574779: Call_DeploymentsCreateOrUpdate_574770;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdate
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_574780 = newJObject()
  var query_574781 = newJObject()
  var body_574782 = newJObject()
  add(path_574780, "resourceGroupName", newJString(resourceGroupName))
  add(query_574781, "api-version", newJString(apiVersion))
  add(path_574780, "deploymentName", newJString(deploymentName))
  add(path_574780, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574782 = parameters
  result = call_574779.call(path_574780, query_574781, nil, nil, body_574782)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_574770(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_574771, base: "",
    url: url_DeploymentsCreateOrUpdate_574772, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_574794 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCheckExistence_574796(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistence_574795(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574797 = path.getOrDefault("resourceGroupName")
  valid_574797 = validateParameter(valid_574797, JString, required = true,
                                 default = nil)
  if valid_574797 != nil:
    section.add "resourceGroupName", valid_574797
  var valid_574798 = path.getOrDefault("deploymentName")
  valid_574798 = validateParameter(valid_574798, JString, required = true,
                                 default = nil)
  if valid_574798 != nil:
    section.add "deploymentName", valid_574798
  var valid_574799 = path.getOrDefault("subscriptionId")
  valid_574799 = validateParameter(valid_574799, JString, required = true,
                                 default = nil)
  if valid_574799 != nil:
    section.add "subscriptionId", valid_574799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574800 = query.getOrDefault("api-version")
  valid_574800 = validateParameter(valid_574800, JString, required = true,
                                 default = nil)
  if valid_574800 != nil:
    section.add "api-version", valid_574800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574801: Call_DeploymentsCheckExistence_574794; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_574801.validator(path, query, header, formData, body)
  let scheme = call_574801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574801.url(scheme.get, call_574801.host, call_574801.base,
                         call_574801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574801, url, valid)

proc call*(call_574802: Call_DeploymentsCheckExistence_574794;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsCheckExistence
  ## Checks whether the deployment exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574803 = newJObject()
  var query_574804 = newJObject()
  add(path_574803, "resourceGroupName", newJString(resourceGroupName))
  add(query_574804, "api-version", newJString(apiVersion))
  add(path_574803, "deploymentName", newJString(deploymentName))
  add(path_574803, "subscriptionId", newJString(subscriptionId))
  result = call_574802.call(path_574803, query_574804, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_574794(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_574795, base: "",
    url: url_DeploymentsCheckExistence_574796, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_574759 = ref object of OpenApiRestCall_573667
proc url_DeploymentsGet_574761(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGet_574760(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574762 = path.getOrDefault("resourceGroupName")
  valid_574762 = validateParameter(valid_574762, JString, required = true,
                                 default = nil)
  if valid_574762 != nil:
    section.add "resourceGroupName", valid_574762
  var valid_574763 = path.getOrDefault("deploymentName")
  valid_574763 = validateParameter(valid_574763, JString, required = true,
                                 default = nil)
  if valid_574763 != nil:
    section.add "deploymentName", valid_574763
  var valid_574764 = path.getOrDefault("subscriptionId")
  valid_574764 = validateParameter(valid_574764, JString, required = true,
                                 default = nil)
  if valid_574764 != nil:
    section.add "subscriptionId", valid_574764
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574765 = query.getOrDefault("api-version")
  valid_574765 = validateParameter(valid_574765, JString, required = true,
                                 default = nil)
  if valid_574765 != nil:
    section.add "api-version", valid_574765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574766: Call_DeploymentsGet_574759; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_574766.validator(path, query, header, formData, body)
  let scheme = call_574766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574766.url(scheme.get, call_574766.host, call_574766.base,
                         call_574766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574766, url, valid)

proc call*(call_574767: Call_DeploymentsGet_574759; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGet
  ## Gets a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574768 = newJObject()
  var query_574769 = newJObject()
  add(path_574768, "resourceGroupName", newJString(resourceGroupName))
  add(query_574769, "api-version", newJString(apiVersion))
  add(path_574768, "deploymentName", newJString(deploymentName))
  add(path_574768, "subscriptionId", newJString(subscriptionId))
  result = call_574767.call(path_574768, query_574769, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_574759(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_574760, base: "", url: url_DeploymentsGet_574761,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_574783 = ref object of OpenApiRestCall_573667
proc url_DeploymentsDelete_574785(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDelete_574784(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574786 = path.getOrDefault("resourceGroupName")
  valid_574786 = validateParameter(valid_574786, JString, required = true,
                                 default = nil)
  if valid_574786 != nil:
    section.add "resourceGroupName", valid_574786
  var valid_574787 = path.getOrDefault("deploymentName")
  valid_574787 = validateParameter(valid_574787, JString, required = true,
                                 default = nil)
  if valid_574787 != nil:
    section.add "deploymentName", valid_574787
  var valid_574788 = path.getOrDefault("subscriptionId")
  valid_574788 = validateParameter(valid_574788, JString, required = true,
                                 default = nil)
  if valid_574788 != nil:
    section.add "subscriptionId", valid_574788
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574789 = query.getOrDefault("api-version")
  valid_574789 = validateParameter(valid_574789, JString, required = true,
                                 default = nil)
  if valid_574789 != nil:
    section.add "api-version", valid_574789
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574790: Call_DeploymentsDelete_574783; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_574790.validator(path, query, header, formData, body)
  let scheme = call_574790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574790.url(scheme.get, call_574790.host, call_574790.base,
                         call_574790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574790, url, valid)

proc call*(call_574791: Call_DeploymentsDelete_574783; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDelete
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574792 = newJObject()
  var query_574793 = newJObject()
  add(path_574792, "resourceGroupName", newJString(resourceGroupName))
  add(query_574793, "api-version", newJString(apiVersion))
  add(path_574792, "deploymentName", newJString(deploymentName))
  add(path_574792, "subscriptionId", newJString(subscriptionId))
  result = call_574791.call(path_574792, query_574793, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_574783(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_574784, base: "",
    url: url_DeploymentsDelete_574785, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_574805 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCancel_574807(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancel_574806(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574808 = path.getOrDefault("resourceGroupName")
  valid_574808 = validateParameter(valid_574808, JString, required = true,
                                 default = nil)
  if valid_574808 != nil:
    section.add "resourceGroupName", valid_574808
  var valid_574809 = path.getOrDefault("deploymentName")
  valid_574809 = validateParameter(valid_574809, JString, required = true,
                                 default = nil)
  if valid_574809 != nil:
    section.add "deploymentName", valid_574809
  var valid_574810 = path.getOrDefault("subscriptionId")
  valid_574810 = validateParameter(valid_574810, JString, required = true,
                                 default = nil)
  if valid_574810 != nil:
    section.add "subscriptionId", valid_574810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574811 = query.getOrDefault("api-version")
  valid_574811 = validateParameter(valid_574811, JString, required = true,
                                 default = nil)
  if valid_574811 != nil:
    section.add "api-version", valid_574811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574812: Call_DeploymentsCancel_574805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  let valid = call_574812.validator(path, query, header, formData, body)
  let scheme = call_574812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574812.url(scheme.get, call_574812.host, call_574812.base,
                         call_574812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574812, url, valid)

proc call*(call_574813: Call_DeploymentsCancel_574805; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancel
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574814 = newJObject()
  var query_574815 = newJObject()
  add(path_574814, "resourceGroupName", newJString(resourceGroupName))
  add(query_574815, "api-version", newJString(apiVersion))
  add(path_574814, "deploymentName", newJString(deploymentName))
  add(path_574814, "subscriptionId", newJString(subscriptionId))
  result = call_574813.call(path_574814, query_574815, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_574805(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_574806, base: "",
    url: url_DeploymentsCancel_574807, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplate_574816 = ref object of OpenApiRestCall_573667
proc url_DeploymentsExportTemplate_574818(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplate_574817(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574819 = path.getOrDefault("resourceGroupName")
  valid_574819 = validateParameter(valid_574819, JString, required = true,
                                 default = nil)
  if valid_574819 != nil:
    section.add "resourceGroupName", valid_574819
  var valid_574820 = path.getOrDefault("deploymentName")
  valid_574820 = validateParameter(valid_574820, JString, required = true,
                                 default = nil)
  if valid_574820 != nil:
    section.add "deploymentName", valid_574820
  var valid_574821 = path.getOrDefault("subscriptionId")
  valid_574821 = validateParameter(valid_574821, JString, required = true,
                                 default = nil)
  if valid_574821 != nil:
    section.add "subscriptionId", valid_574821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574822 = query.getOrDefault("api-version")
  valid_574822 = validateParameter(valid_574822, JString, required = true,
                                 default = nil)
  if valid_574822 != nil:
    section.add "api-version", valid_574822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574823: Call_DeploymentsExportTemplate_574816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_574823.validator(path, query, header, formData, body)
  let scheme = call_574823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574823.url(scheme.get, call_574823.host, call_574823.base,
                         call_574823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574823, url, valid)

proc call*(call_574824: Call_DeploymentsExportTemplate_574816;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsExportTemplate
  ## Exports the template used for specified deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574825 = newJObject()
  var query_574826 = newJObject()
  add(path_574825, "resourceGroupName", newJString(resourceGroupName))
  add(query_574826, "api-version", newJString(apiVersion))
  add(path_574825, "deploymentName", newJString(deploymentName))
  add(path_574825, "subscriptionId", newJString(subscriptionId))
  result = call_574824.call(path_574825, query_574826, nil, nil, nil)

var deploymentsExportTemplate* = Call_DeploymentsExportTemplate_574816(
    name: "deploymentsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplate_574817, base: "",
    url: url_DeploymentsExportTemplate_574818, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_574827 = ref object of OpenApiRestCall_573667
proc url_DeploymentsValidate_574829(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidate_574828(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574830 = path.getOrDefault("resourceGroupName")
  valid_574830 = validateParameter(valid_574830, JString, required = true,
                                 default = nil)
  if valid_574830 != nil:
    section.add "resourceGroupName", valid_574830
  var valid_574831 = path.getOrDefault("deploymentName")
  valid_574831 = validateParameter(valid_574831, JString, required = true,
                                 default = nil)
  if valid_574831 != nil:
    section.add "deploymentName", valid_574831
  var valid_574832 = path.getOrDefault("subscriptionId")
  valid_574832 = validateParameter(valid_574832, JString, required = true,
                                 default = nil)
  if valid_574832 != nil:
    section.add "subscriptionId", valid_574832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574833 = query.getOrDefault("api-version")
  valid_574833 = validateParameter(valid_574833, JString, required = true,
                                 default = nil)
  if valid_574833 != nil:
    section.add "api-version", valid_574833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574835: Call_DeploymentsValidate_574827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_574835.validator(path, query, header, formData, body)
  let scheme = call_574835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574835.url(scheme.get, call_574835.host, call_574835.base,
                         call_574835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574835, url, valid)

proc call*(call_574836: Call_DeploymentsValidate_574827; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidate
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_574837 = newJObject()
  var query_574838 = newJObject()
  var body_574839 = newJObject()
  add(path_574837, "resourceGroupName", newJString(resourceGroupName))
  add(query_574838, "api-version", newJString(apiVersion))
  add(path_574837, "deploymentName", newJString(deploymentName))
  add(path_574837, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574839 = parameters
  result = call_574836.call(path_574837, query_574838, nil, nil, body_574839)

var deploymentsValidate* = Call_DeploymentsValidate_574827(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_574828, base: "",
    url: url_DeploymentsValidate_574829, schemes: {Scheme.Https})
type
  Call_DeploymentsWhatIf_574840 = ref object of OpenApiRestCall_573667
proc url_DeploymentsWhatIf_574842(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/whatIf")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsWhatIf_574841(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns changes that will be made by the deployment if executed at the scope of the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574843 = path.getOrDefault("resourceGroupName")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "resourceGroupName", valid_574843
  var valid_574844 = path.getOrDefault("deploymentName")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "deploymentName", valid_574844
  var valid_574845 = path.getOrDefault("subscriptionId")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "subscriptionId", valid_574845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574846 = query.getOrDefault("api-version")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "api-version", valid_574846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574848: Call_DeploymentsWhatIf_574840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns changes that will be made by the deployment if executed at the scope of the resource group.
  ## 
  let valid = call_574848.validator(path, query, header, formData, body)
  let scheme = call_574848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574848.url(scheme.get, call_574848.host, call_574848.base,
                         call_574848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574848, url, valid)

proc call*(call_574849: Call_DeploymentsWhatIf_574840; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsWhatIf
  ## Returns changes that will be made by the deployment if executed at the scope of the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_574850 = newJObject()
  var query_574851 = newJObject()
  var body_574852 = newJObject()
  add(path_574850, "resourceGroupName", newJString(resourceGroupName))
  add(query_574851, "api-version", newJString(apiVersion))
  add(path_574850, "deploymentName", newJString(deploymentName))
  add(path_574850, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574852 = parameters
  result = call_574849.call(path_574850, query_574851, nil, nil, body_574852)

var deploymentsWhatIf* = Call_DeploymentsWhatIf_574840(name: "deploymentsWhatIf",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/whatIf",
    validator: validate_DeploymentsWhatIf_574841, base: "",
    url: url_DeploymentsWhatIf_574842, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_574867 = ref object of OpenApiRestCall_573667
proc url_ResourcesCreateOrUpdate_574869(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdate_574868(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to create.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574870 = path.getOrDefault("resourceType")
  valid_574870 = validateParameter(valid_574870, JString, required = true,
                                 default = nil)
  if valid_574870 != nil:
    section.add "resourceType", valid_574870
  var valid_574871 = path.getOrDefault("resourceGroupName")
  valid_574871 = validateParameter(valid_574871, JString, required = true,
                                 default = nil)
  if valid_574871 != nil:
    section.add "resourceGroupName", valid_574871
  var valid_574872 = path.getOrDefault("subscriptionId")
  valid_574872 = validateParameter(valid_574872, JString, required = true,
                                 default = nil)
  if valid_574872 != nil:
    section.add "subscriptionId", valid_574872
  var valid_574873 = path.getOrDefault("resourceName")
  valid_574873 = validateParameter(valid_574873, JString, required = true,
                                 default = nil)
  if valid_574873 != nil:
    section.add "resourceName", valid_574873
  var valid_574874 = path.getOrDefault("resourceProviderNamespace")
  valid_574874 = validateParameter(valid_574874, JString, required = true,
                                 default = nil)
  if valid_574874 != nil:
    section.add "resourceProviderNamespace", valid_574874
  var valid_574875 = path.getOrDefault("parentResourcePath")
  valid_574875 = validateParameter(valid_574875, JString, required = true,
                                 default = nil)
  if valid_574875 != nil:
    section.add "parentResourcePath", valid_574875
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574876 = query.getOrDefault("api-version")
  valid_574876 = validateParameter(valid_574876, JString, required = true,
                                 default = nil)
  if valid_574876 != nil:
    section.add "api-version", valid_574876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574878: Call_ResourcesCreateOrUpdate_574867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a resource.
  ## 
  let valid = call_574878.validator(path, query, header, formData, body)
  let scheme = call_574878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574878.url(scheme.get, call_574878.host, call_574878.base,
                         call_574878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574878, url, valid)

proc call*(call_574879: Call_ResourcesCreateOrUpdate_574867; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesCreateOrUpdate
  ## Creates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to create.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_574880 = newJObject()
  var query_574881 = newJObject()
  var body_574882 = newJObject()
  add(path_574880, "resourceType", newJString(resourceType))
  add(path_574880, "resourceGroupName", newJString(resourceGroupName))
  add(query_574881, "api-version", newJString(apiVersion))
  add(path_574880, "subscriptionId", newJString(subscriptionId))
  add(path_574880, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_574882 = parameters
  add(path_574880, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_574880, "parentResourcePath", newJString(parentResourcePath))
  result = call_574879.call(path_574880, query_574881, nil, nil, body_574882)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_574867(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_574868, base: "",
    url: url_ResourcesCreateOrUpdate_574869, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_574897 = ref object of OpenApiRestCall_573667
proc url_ResourcesCheckExistence_574899(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistence_574898(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574900 = path.getOrDefault("resourceType")
  valid_574900 = validateParameter(valid_574900, JString, required = true,
                                 default = nil)
  if valid_574900 != nil:
    section.add "resourceType", valid_574900
  var valid_574901 = path.getOrDefault("resourceGroupName")
  valid_574901 = validateParameter(valid_574901, JString, required = true,
                                 default = nil)
  if valid_574901 != nil:
    section.add "resourceGroupName", valid_574901
  var valid_574902 = path.getOrDefault("subscriptionId")
  valid_574902 = validateParameter(valid_574902, JString, required = true,
                                 default = nil)
  if valid_574902 != nil:
    section.add "subscriptionId", valid_574902
  var valid_574903 = path.getOrDefault("resourceName")
  valid_574903 = validateParameter(valid_574903, JString, required = true,
                                 default = nil)
  if valid_574903 != nil:
    section.add "resourceName", valid_574903
  var valid_574904 = path.getOrDefault("resourceProviderNamespace")
  valid_574904 = validateParameter(valid_574904, JString, required = true,
                                 default = nil)
  if valid_574904 != nil:
    section.add "resourceProviderNamespace", valid_574904
  var valid_574905 = path.getOrDefault("parentResourcePath")
  valid_574905 = validateParameter(valid_574905, JString, required = true,
                                 default = nil)
  if valid_574905 != nil:
    section.add "parentResourcePath", valid_574905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574906 = query.getOrDefault("api-version")
  valid_574906 = validateParameter(valid_574906, JString, required = true,
                                 default = nil)
  if valid_574906 != nil:
    section.add "api-version", valid_574906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574907: Call_ResourcesCheckExistence_574897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource exists.
  ## 
  let valid = call_574907.validator(path, query, header, formData, body)
  let scheme = call_574907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574907.url(scheme.get, call_574907.host, call_574907.base,
                         call_574907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574907, url, valid)

proc call*(call_574908: Call_ResourcesCheckExistence_574897; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesCheckExistence
  ## Checks whether a resource exists.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: string (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_574909 = newJObject()
  var query_574910 = newJObject()
  add(path_574909, "resourceType", newJString(resourceType))
  add(path_574909, "resourceGroupName", newJString(resourceGroupName))
  add(query_574910, "api-version", newJString(apiVersion))
  add(path_574909, "subscriptionId", newJString(subscriptionId))
  add(path_574909, "resourceName", newJString(resourceName))
  add(path_574909, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_574909, "parentResourcePath", newJString(parentResourcePath))
  result = call_574908.call(path_574909, query_574910, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_574897(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_574898, base: "",
    url: url_ResourcesCheckExistence_574899, schemes: {Scheme.Https})
type
  Call_ResourcesGet_574853 = ref object of OpenApiRestCall_573667
proc url_ResourcesGet_574855(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGet_574854(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574856 = path.getOrDefault("resourceType")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = nil)
  if valid_574856 != nil:
    section.add "resourceType", valid_574856
  var valid_574857 = path.getOrDefault("resourceGroupName")
  valid_574857 = validateParameter(valid_574857, JString, required = true,
                                 default = nil)
  if valid_574857 != nil:
    section.add "resourceGroupName", valid_574857
  var valid_574858 = path.getOrDefault("subscriptionId")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = nil)
  if valid_574858 != nil:
    section.add "subscriptionId", valid_574858
  var valid_574859 = path.getOrDefault("resourceName")
  valid_574859 = validateParameter(valid_574859, JString, required = true,
                                 default = nil)
  if valid_574859 != nil:
    section.add "resourceName", valid_574859
  var valid_574860 = path.getOrDefault("resourceProviderNamespace")
  valid_574860 = validateParameter(valid_574860, JString, required = true,
                                 default = nil)
  if valid_574860 != nil:
    section.add "resourceProviderNamespace", valid_574860
  var valid_574861 = path.getOrDefault("parentResourcePath")
  valid_574861 = validateParameter(valid_574861, JString, required = true,
                                 default = nil)
  if valid_574861 != nil:
    section.add "parentResourcePath", valid_574861
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574862 = query.getOrDefault("api-version")
  valid_574862 = validateParameter(valid_574862, JString, required = true,
                                 default = nil)
  if valid_574862 != nil:
    section.add "api-version", valid_574862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574863: Call_ResourcesGet_574853; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource.
  ## 
  let valid = call_574863.validator(path, query, header, formData, body)
  let scheme = call_574863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574863.url(scheme.get, call_574863.host, call_574863.base,
                         call_574863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574863, url, valid)

proc call*(call_574864: Call_ResourcesGet_574853; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesGet
  ## Gets a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_574865 = newJObject()
  var query_574866 = newJObject()
  add(path_574865, "resourceType", newJString(resourceType))
  add(path_574865, "resourceGroupName", newJString(resourceGroupName))
  add(query_574866, "api-version", newJString(apiVersion))
  add(path_574865, "subscriptionId", newJString(subscriptionId))
  add(path_574865, "resourceName", newJString(resourceName))
  add(path_574865, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_574865, "parentResourcePath", newJString(parentResourcePath))
  result = call_574864.call(path_574865, query_574866, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_574853(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_574854, base: "", url: url_ResourcesGet_574855,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_574911 = ref object of OpenApiRestCall_573667
proc url_ResourcesUpdate_574913(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdate_574912(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to update.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574914 = path.getOrDefault("resourceType")
  valid_574914 = validateParameter(valid_574914, JString, required = true,
                                 default = nil)
  if valid_574914 != nil:
    section.add "resourceType", valid_574914
  var valid_574915 = path.getOrDefault("resourceGroupName")
  valid_574915 = validateParameter(valid_574915, JString, required = true,
                                 default = nil)
  if valid_574915 != nil:
    section.add "resourceGroupName", valid_574915
  var valid_574916 = path.getOrDefault("subscriptionId")
  valid_574916 = validateParameter(valid_574916, JString, required = true,
                                 default = nil)
  if valid_574916 != nil:
    section.add "subscriptionId", valid_574916
  var valid_574917 = path.getOrDefault("resourceName")
  valid_574917 = validateParameter(valid_574917, JString, required = true,
                                 default = nil)
  if valid_574917 != nil:
    section.add "resourceName", valid_574917
  var valid_574918 = path.getOrDefault("resourceProviderNamespace")
  valid_574918 = validateParameter(valid_574918, JString, required = true,
                                 default = nil)
  if valid_574918 != nil:
    section.add "resourceProviderNamespace", valid_574918
  var valid_574919 = path.getOrDefault("parentResourcePath")
  valid_574919 = validateParameter(valid_574919, JString, required = true,
                                 default = nil)
  if valid_574919 != nil:
    section.add "parentResourcePath", valid_574919
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574920 = query.getOrDefault("api-version")
  valid_574920 = validateParameter(valid_574920, JString, required = true,
                                 default = nil)
  if valid_574920 != nil:
    section.add "api-version", valid_574920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574922: Call_ResourcesUpdate_574911; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_574922.validator(path, query, header, formData, body)
  let scheme = call_574922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574922.url(scheme.get, call_574922.host, call_574922.base,
                         call_574922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574922, url, valid)

proc call*(call_574923: Call_ResourcesUpdate_574911; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesUpdate
  ## Updates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to update.
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_574924 = newJObject()
  var query_574925 = newJObject()
  var body_574926 = newJObject()
  add(path_574924, "resourceType", newJString(resourceType))
  add(path_574924, "resourceGroupName", newJString(resourceGroupName))
  add(query_574925, "api-version", newJString(apiVersion))
  add(path_574924, "subscriptionId", newJString(subscriptionId))
  add(path_574924, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_574926 = parameters
  add(path_574924, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_574924, "parentResourcePath", newJString(parentResourcePath))
  result = call_574923.call(path_574924, query_574925, nil, nil, body_574926)

var resourcesUpdate* = Call_ResourcesUpdate_574911(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_574912, base: "", url: url_ResourcesUpdate_574913,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_574883 = ref object of OpenApiRestCall_573667
proc url_ResourcesDelete_574885(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDelete_574884(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574886 = path.getOrDefault("resourceType")
  valid_574886 = validateParameter(valid_574886, JString, required = true,
                                 default = nil)
  if valid_574886 != nil:
    section.add "resourceType", valid_574886
  var valid_574887 = path.getOrDefault("resourceGroupName")
  valid_574887 = validateParameter(valid_574887, JString, required = true,
                                 default = nil)
  if valid_574887 != nil:
    section.add "resourceGroupName", valid_574887
  var valid_574888 = path.getOrDefault("subscriptionId")
  valid_574888 = validateParameter(valid_574888, JString, required = true,
                                 default = nil)
  if valid_574888 != nil:
    section.add "subscriptionId", valid_574888
  var valid_574889 = path.getOrDefault("resourceName")
  valid_574889 = validateParameter(valid_574889, JString, required = true,
                                 default = nil)
  if valid_574889 != nil:
    section.add "resourceName", valid_574889
  var valid_574890 = path.getOrDefault("resourceProviderNamespace")
  valid_574890 = validateParameter(valid_574890, JString, required = true,
                                 default = nil)
  if valid_574890 != nil:
    section.add "resourceProviderNamespace", valid_574890
  var valid_574891 = path.getOrDefault("parentResourcePath")
  valid_574891 = validateParameter(valid_574891, JString, required = true,
                                 default = nil)
  if valid_574891 != nil:
    section.add "parentResourcePath", valid_574891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574892 = query.getOrDefault("api-version")
  valid_574892 = validateParameter(valid_574892, JString, required = true,
                                 default = nil)
  if valid_574892 != nil:
    section.add "api-version", valid_574892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574893: Call_ResourcesDelete_574883; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource.
  ## 
  let valid = call_574893.validator(path, query, header, formData, body)
  let scheme = call_574893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574893.url(scheme.get, call_574893.host, call_574893.base,
                         call_574893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574893, url, valid)

proc call*(call_574894: Call_ResourcesDelete_574883; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesDelete
  ## Deletes a resource.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_574895 = newJObject()
  var query_574896 = newJObject()
  add(path_574895, "resourceType", newJString(resourceType))
  add(path_574895, "resourceGroupName", newJString(resourceGroupName))
  add(query_574896, "api-version", newJString(apiVersion))
  add(path_574895, "subscriptionId", newJString(subscriptionId))
  add(path_574895, "resourceName", newJString(resourceName))
  add(path_574895, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_574895, "parentResourcePath", newJString(parentResourcePath))
  result = call_574894.call(path_574895, query_574896, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_574883(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_574884, base: "", url: url_ResourcesDelete_574885,
    schemes: {Scheme.Https})
type
  Call_ResourcesList_574927 = ref object of OpenApiRestCall_573667
proc url_ResourcesList_574929(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesList_574928(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574930 = path.getOrDefault("subscriptionId")
  valid_574930 = validateParameter(valid_574930, JString, required = true,
                                 default = nil)
  if valid_574930 != nil:
    section.add "subscriptionId", valid_574930
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  section = newJObject()
  var valid_574931 = query.getOrDefault("$expand")
  valid_574931 = validateParameter(valid_574931, JString, required = false,
                                 default = nil)
  if valid_574931 != nil:
    section.add "$expand", valid_574931
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574932 = query.getOrDefault("api-version")
  valid_574932 = validateParameter(valid_574932, JString, required = true,
                                 default = nil)
  if valid_574932 != nil:
    section.add "api-version", valid_574932
  var valid_574933 = query.getOrDefault("$top")
  valid_574933 = validateParameter(valid_574933, JInt, required = false, default = nil)
  if valid_574933 != nil:
    section.add "$top", valid_574933
  var valid_574934 = query.getOrDefault("$filter")
  valid_574934 = validateParameter(valid_574934, JString, required = false,
                                 default = nil)
  if valid_574934 != nil:
    section.add "$filter", valid_574934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574935: Call_ResourcesList_574927; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources in a subscription.
  ## 
  let valid = call_574935.validator(path, query, header, formData, body)
  let scheme = call_574935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574935.url(scheme.get, call_574935.host, call_574935.base,
                         call_574935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574935, url, valid)

proc call*(call_574936: Call_ResourcesList_574927; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesList
  ## Get all the resources in a subscription.
  ##   Expand: string
  ##         : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  var path_574937 = newJObject()
  var query_574938 = newJObject()
  add(query_574938, "$expand", newJString(Expand))
  add(query_574938, "api-version", newJString(apiVersion))
  add(path_574937, "subscriptionId", newJString(subscriptionId))
  add(query_574938, "$top", newJInt(Top))
  add(query_574938, "$filter", newJString(Filter))
  result = call_574936.call(path_574937, query_574938, nil, nil, nil)

var resourcesList* = Call_ResourcesList_574927(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_574928, base: "", url: url_ResourcesList_574929,
    schemes: {Scheme.Https})
type
  Call_TagsList_574939 = ref object of OpenApiRestCall_573667
proc url_TagsList_574941(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsList_574940(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574942 = path.getOrDefault("subscriptionId")
  valid_574942 = validateParameter(valid_574942, JString, required = true,
                                 default = nil)
  if valid_574942 != nil:
    section.add "subscriptionId", valid_574942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574943 = query.getOrDefault("api-version")
  valid_574943 = validateParameter(valid_574943, JString, required = true,
                                 default = nil)
  if valid_574943 != nil:
    section.add "api-version", valid_574943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574944: Call_TagsList_574939; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  let valid = call_574944.validator(path, query, header, formData, body)
  let scheme = call_574944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574944.url(scheme.get, call_574944.host, call_574944.base,
                         call_574944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574944, url, valid)

proc call*(call_574945: Call_TagsList_574939; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574946 = newJObject()
  var query_574947 = newJObject()
  add(query_574947, "api-version", newJString(apiVersion))
  add(path_574946, "subscriptionId", newJString(subscriptionId))
  result = call_574945.call(path_574946, query_574947, nil, nil, nil)

var tagsList* = Call_TagsList_574939(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_574940, base: "",
                                  url: url_TagsList_574941,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_574948 = ref object of OpenApiRestCall_573667
proc url_TagsCreateOrUpdate_574950(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdate_574949(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_574951 = path.getOrDefault("tagName")
  valid_574951 = validateParameter(valid_574951, JString, required = true,
                                 default = nil)
  if valid_574951 != nil:
    section.add "tagName", valid_574951
  var valid_574952 = path.getOrDefault("subscriptionId")
  valid_574952 = validateParameter(valid_574952, JString, required = true,
                                 default = nil)
  if valid_574952 != nil:
    section.add "subscriptionId", valid_574952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574953 = query.getOrDefault("api-version")
  valid_574953 = validateParameter(valid_574953, JString, required = true,
                                 default = nil)
  if valid_574953 != nil:
    section.add "api-version", valid_574953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574954: Call_TagsCreateOrUpdate_574948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  let valid = call_574954.validator(path, query, header, formData, body)
  let scheme = call_574954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574954.url(scheme.get, call_574954.host, call_574954.base,
                         call_574954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574954, url, valid)

proc call*(call_574955: Call_TagsCreateOrUpdate_574948; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574956 = newJObject()
  var query_574957 = newJObject()
  add(query_574957, "api-version", newJString(apiVersion))
  add(path_574956, "tagName", newJString(tagName))
  add(path_574956, "subscriptionId", newJString(subscriptionId))
  result = call_574955.call(path_574956, query_574957, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_574948(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_574949, base: "",
    url: url_TagsCreateOrUpdate_574950, schemes: {Scheme.Https})
type
  Call_TagsDelete_574958 = ref object of OpenApiRestCall_573667
proc url_TagsDelete_574960(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDelete_574959(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_574961 = path.getOrDefault("tagName")
  valid_574961 = validateParameter(valid_574961, JString, required = true,
                                 default = nil)
  if valid_574961 != nil:
    section.add "tagName", valid_574961
  var valid_574962 = path.getOrDefault("subscriptionId")
  valid_574962 = validateParameter(valid_574962, JString, required = true,
                                 default = nil)
  if valid_574962 != nil:
    section.add "subscriptionId", valid_574962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574963 = query.getOrDefault("api-version")
  valid_574963 = validateParameter(valid_574963, JString, required = true,
                                 default = nil)
  if valid_574963 != nil:
    section.add "api-version", valid_574963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574964: Call_TagsDelete_574958; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  let valid = call_574964.validator(path, query, header, formData, body)
  let scheme = call_574964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574964.url(scheme.get, call_574964.host, call_574964.base,
                         call_574964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574964, url, valid)

proc call*(call_574965: Call_TagsDelete_574958; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## You must remove all values from a resource tag before you can delete it.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574966 = newJObject()
  var query_574967 = newJObject()
  add(query_574967, "api-version", newJString(apiVersion))
  add(path_574966, "tagName", newJString(tagName))
  add(path_574966, "subscriptionId", newJString(subscriptionId))
  result = call_574965.call(path_574966, query_574967, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_574958(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_574959,
                                      base: "", url: url_TagsDelete_574960,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_574968 = ref object of OpenApiRestCall_573667
proc url_TagsCreateOrUpdateValue_574970(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdateValue_574969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_574971 = path.getOrDefault("tagName")
  valid_574971 = validateParameter(valid_574971, JString, required = true,
                                 default = nil)
  if valid_574971 != nil:
    section.add "tagName", valid_574971
  var valid_574972 = path.getOrDefault("subscriptionId")
  valid_574972 = validateParameter(valid_574972, JString, required = true,
                                 default = nil)
  if valid_574972 != nil:
    section.add "subscriptionId", valid_574972
  var valid_574973 = path.getOrDefault("tagValue")
  valid_574973 = validateParameter(valid_574973, JString, required = true,
                                 default = nil)
  if valid_574973 != nil:
    section.add "tagValue", valid_574973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574974 = query.getOrDefault("api-version")
  valid_574974 = validateParameter(valid_574974, JString, required = true,
                                 default = nil)
  if valid_574974 != nil:
    section.add "api-version", valid_574974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574975: Call_TagsCreateOrUpdateValue_574968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  let valid = call_574975.validator(path, query, header, formData, body)
  let scheme = call_574975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574975.url(scheme.get, call_574975.host, call_574975.base,
                         call_574975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574975, url, valid)

proc call*(call_574976: Call_TagsCreateOrUpdateValue_574968; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsCreateOrUpdateValue
  ## Creates a tag value. The name of the tag must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to create.
  var path_574977 = newJObject()
  var query_574978 = newJObject()
  add(query_574978, "api-version", newJString(apiVersion))
  add(path_574977, "tagName", newJString(tagName))
  add(path_574977, "subscriptionId", newJString(subscriptionId))
  add(path_574977, "tagValue", newJString(tagValue))
  result = call_574976.call(path_574977, query_574978, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_574968(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_574969, base: "",
    url: url_TagsCreateOrUpdateValue_574970, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_574979 = ref object of OpenApiRestCall_573667
proc url_TagsDeleteValue_574981(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDeleteValue_574980(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a tag value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_574982 = path.getOrDefault("tagName")
  valid_574982 = validateParameter(valid_574982, JString, required = true,
                                 default = nil)
  if valid_574982 != nil:
    section.add "tagName", valid_574982
  var valid_574983 = path.getOrDefault("subscriptionId")
  valid_574983 = validateParameter(valid_574983, JString, required = true,
                                 default = nil)
  if valid_574983 != nil:
    section.add "subscriptionId", valid_574983
  var valid_574984 = path.getOrDefault("tagValue")
  valid_574984 = validateParameter(valid_574984, JString, required = true,
                                 default = nil)
  if valid_574984 != nil:
    section.add "tagValue", valid_574984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574985 = query.getOrDefault("api-version")
  valid_574985 = validateParameter(valid_574985, JString, required = true,
                                 default = nil)
  if valid_574985 != nil:
    section.add "api-version", valid_574985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574986: Call_TagsDeleteValue_574979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a tag value.
  ## 
  let valid = call_574986.validator(path, query, header, formData, body)
  let scheme = call_574986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574986.url(scheme.get, call_574986.host, call_574986.base,
                         call_574986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574986, url, valid)

proc call*(call_574987: Call_TagsDeleteValue_574979; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsDeleteValue
  ## Deletes a tag value.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to delete.
  var path_574988 = newJObject()
  var query_574989 = newJObject()
  add(query_574989, "api-version", newJString(apiVersion))
  add(path_574988, "tagName", newJString(tagName))
  add(path_574988, "subscriptionId", newJString(subscriptionId))
  add(path_574988, "tagValue", newJString(tagValue))
  result = call_574987.call(path_574988, query_574989, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_574979(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_574980, base: "", url: url_TagsDeleteValue_574981,
    schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdateById_574999 = ref object of OpenApiRestCall_573667
proc url_ResourcesCreateOrUpdateById_575001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdateById_575000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_575002 = path.getOrDefault("resourceId")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "resourceId", valid_575002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575003 = query.getOrDefault("api-version")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "api-version", valid_575003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575005: Call_ResourcesCreateOrUpdateById_574999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource by ID.
  ## 
  let valid = call_575005.validator(path, query, header, formData, body)
  let scheme = call_575005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575005.url(scheme.get, call_575005.host, call_575005.base,
                         call_575005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575005, url, valid)

proc call*(call_575006: Call_ResourcesCreateOrUpdateById_574999;
          apiVersion: string; resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesCreateOrUpdateById
  ## Create a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  var path_575007 = newJObject()
  var query_575008 = newJObject()
  var body_575009 = newJObject()
  add(query_575008, "api-version", newJString(apiVersion))
  add(path_575007, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_575009 = parameters
  result = call_575006.call(path_575007, query_575008, nil, nil, body_575009)

var resourcesCreateOrUpdateById* = Call_ResourcesCreateOrUpdateById_574999(
    name: "resourcesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCreateOrUpdateById_575000, base: "",
    url: url_ResourcesCreateOrUpdateById_575001, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistenceById_575019 = ref object of OpenApiRestCall_573667
proc url_ResourcesCheckExistenceById_575021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistenceById_575020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks by ID whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_575022 = path.getOrDefault("resourceId")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "resourceId", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "api-version", valid_575023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575024: Call_ResourcesCheckExistenceById_575019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks by ID whether a resource exists.
  ## 
  let valid = call_575024.validator(path, query, header, formData, body)
  let scheme = call_575024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575024.url(scheme.get, call_575024.host, call_575024.base,
                         call_575024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575024, url, valid)

proc call*(call_575025: Call_ResourcesCheckExistenceById_575019;
          apiVersion: string; resourceId: string): Recallable =
  ## resourcesCheckExistenceById
  ## Checks by ID whether a resource exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_575026 = newJObject()
  var query_575027 = newJObject()
  add(query_575027, "api-version", newJString(apiVersion))
  add(path_575026, "resourceId", newJString(resourceId))
  result = call_575025.call(path_575026, query_575027, nil, nil, nil)

var resourcesCheckExistenceById* = Call_ResourcesCheckExistenceById_575019(
    name: "resourcesCheckExistenceById", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCheckExistenceById_575020, base: "",
    url: url_ResourcesCheckExistenceById_575021, schemes: {Scheme.Https})
type
  Call_ResourcesGetById_574990 = ref object of OpenApiRestCall_573667
proc url_ResourcesGetById_574992(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGetById_574991(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_574993 = path.getOrDefault("resourceId")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "resourceId", valid_574993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574994 = query.getOrDefault("api-version")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "api-version", valid_574994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574995: Call_ResourcesGetById_574990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource by ID.
  ## 
  let valid = call_574995.validator(path, query, header, formData, body)
  let scheme = call_574995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574995.url(scheme.get, call_574995.host, call_574995.base,
                         call_574995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574995, url, valid)

proc call*(call_574996: Call_ResourcesGetById_574990; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesGetById
  ## Gets a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_574997 = newJObject()
  var query_574998 = newJObject()
  add(query_574998, "api-version", newJString(apiVersion))
  add(path_574997, "resourceId", newJString(resourceId))
  result = call_574996.call(path_574997, query_574998, nil, nil, nil)

var resourcesGetById* = Call_ResourcesGetById_574990(name: "resourcesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesGetById_574991, base: "",
    url: url_ResourcesGetById_574992, schemes: {Scheme.Https})
type
  Call_ResourcesUpdateById_575028 = ref object of OpenApiRestCall_573667
proc url_ResourcesUpdateById_575030(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdateById_575029(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_575031 = path.getOrDefault("resourceId")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "resourceId", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = nil)
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575034: Call_ResourcesUpdateById_575028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource by ID.
  ## 
  let valid = call_575034.validator(path, query, header, formData, body)
  let scheme = call_575034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575034.url(scheme.get, call_575034.host, call_575034.base,
                         call_575034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575034, url, valid)

proc call*(call_575035: Call_ResourcesUpdateById_575028; apiVersion: string;
          resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesUpdateById
  ## Updates a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  var path_575036 = newJObject()
  var query_575037 = newJObject()
  var body_575038 = newJObject()
  add(query_575037, "api-version", newJString(apiVersion))
  add(path_575036, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_575038 = parameters
  result = call_575035.call(path_575036, query_575037, nil, nil, body_575038)

var resourcesUpdateById* = Call_ResourcesUpdateById_575028(
    name: "resourcesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesUpdateById_575029, base: "",
    url: url_ResourcesUpdateById_575030, schemes: {Scheme.Https})
type
  Call_ResourcesDeleteById_575010 = ref object of OpenApiRestCall_573667
proc url_ResourcesDeleteById_575012(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDeleteById_575011(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_575013 = path.getOrDefault("resourceId")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "resourceId", valid_575013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575014 = query.getOrDefault("api-version")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "api-version", valid_575014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575015: Call_ResourcesDeleteById_575010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource by ID.
  ## 
  let valid = call_575015.validator(path, query, header, formData, body)
  let scheme = call_575015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575015.url(scheme.get, call_575015.host, call_575015.base,
                         call_575015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575015, url, valid)

proc call*(call_575016: Call_ResourcesDeleteById_575010; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesDeleteById
  ## Deletes a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_575017 = newJObject()
  var query_575018 = newJObject()
  add(query_575018, "api-version", newJString(apiVersion))
  add(path_575017, "resourceId", newJString(resourceId))
  result = call_575016.call(path_575017, query_575018, nil, nil, nil)

var resourcesDeleteById* = Call_ResourcesDeleteById_575010(
    name: "resourcesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesDeleteById_575011, base: "",
    url: url_ResourcesDeleteById_575012, schemes: {Scheme.Https})
type
  Call_DeploymentsListAtScope_575039 = ref object of OpenApiRestCall_573667
proc url_DeploymentsListAtScope_575041(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListAtScope_575040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments at the given scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_575042 = path.getOrDefault("scope")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "scope", valid_575042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575043 = query.getOrDefault("api-version")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = nil)
  if valid_575043 != nil:
    section.add "api-version", valid_575043
  var valid_575044 = query.getOrDefault("$top")
  valid_575044 = validateParameter(valid_575044, JInt, required = false, default = nil)
  if valid_575044 != nil:
    section.add "$top", valid_575044
  var valid_575045 = query.getOrDefault("$filter")
  valid_575045 = validateParameter(valid_575045, JString, required = false,
                                 default = nil)
  if valid_575045 != nil:
    section.add "$filter", valid_575045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575046: Call_DeploymentsListAtScope_575039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments at the given scope.
  ## 
  let valid = call_575046.validator(path, query, header, formData, body)
  let scheme = call_575046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575046.url(scheme.get, call_575046.host, call_575046.base,
                         call_575046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575046, url, valid)

proc call*(call_575047: Call_DeploymentsListAtScope_575039; apiVersion: string;
          scope: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtScope
  ## Get all the deployments at the given scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_575048 = newJObject()
  var query_575049 = newJObject()
  add(query_575049, "api-version", newJString(apiVersion))
  add(query_575049, "$top", newJInt(Top))
  add(path_575048, "scope", newJString(scope))
  add(query_575049, "$filter", newJString(Filter))
  result = call_575047.call(path_575048, query_575049, nil, nil, nil)

var deploymentsListAtScope* = Call_DeploymentsListAtScope_575039(
    name: "deploymentsListAtScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtScope_575040, base: "",
    url: url_DeploymentsListAtScope_575041, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtScope_575060 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCreateOrUpdateAtScope_575062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtScope_575061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575063 = path.getOrDefault("deploymentName")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "deploymentName", valid_575063
  var valid_575064 = path.getOrDefault("scope")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "scope", valid_575064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575065 = query.getOrDefault("api-version")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "api-version", valid_575065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575067: Call_DeploymentsCreateOrUpdateAtScope_575060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_575067.validator(path, query, header, formData, body)
  let scheme = call_575067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575067.url(scheme.get, call_575067.host, call_575067.base,
                         call_575067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575067, url, valid)

proc call*(call_575068: Call_DeploymentsCreateOrUpdateAtScope_575060;
          apiVersion: string; deploymentName: string; parameters: JsonNode;
          scope: string): Recallable =
  ## deploymentsCreateOrUpdateAtScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575069 = newJObject()
  var query_575070 = newJObject()
  var body_575071 = newJObject()
  add(query_575070, "api-version", newJString(apiVersion))
  add(path_575069, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_575071 = parameters
  add(path_575069, "scope", newJString(scope))
  result = call_575068.call(path_575069, query_575070, nil, nil, body_575071)

var deploymentsCreateOrUpdateAtScope* = Call_DeploymentsCreateOrUpdateAtScope_575060(
    name: "deploymentsCreateOrUpdateAtScope", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtScope_575061, base: "",
    url: url_DeploymentsCreateOrUpdateAtScope_575062, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtScope_575082 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCheckExistenceAtScope_575084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtScope_575083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575085 = path.getOrDefault("deploymentName")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "deploymentName", valid_575085
  var valid_575086 = path.getOrDefault("scope")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "scope", valid_575086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575087 = query.getOrDefault("api-version")
  valid_575087 = validateParameter(valid_575087, JString, required = true,
                                 default = nil)
  if valid_575087 != nil:
    section.add "api-version", valid_575087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575088: Call_DeploymentsCheckExistenceAtScope_575082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_575088.validator(path, query, header, formData, body)
  let scheme = call_575088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575088.url(scheme.get, call_575088.host, call_575088.base,
                         call_575088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575088, url, valid)

proc call*(call_575089: Call_DeploymentsCheckExistenceAtScope_575082;
          apiVersion: string; deploymentName: string; scope: string): Recallable =
  ## deploymentsCheckExistenceAtScope
  ## Checks whether the deployment exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575090 = newJObject()
  var query_575091 = newJObject()
  add(query_575091, "api-version", newJString(apiVersion))
  add(path_575090, "deploymentName", newJString(deploymentName))
  add(path_575090, "scope", newJString(scope))
  result = call_575089.call(path_575090, query_575091, nil, nil, nil)

var deploymentsCheckExistenceAtScope* = Call_DeploymentsCheckExistenceAtScope_575082(
    name: "deploymentsCheckExistenceAtScope", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtScope_575083, base: "",
    url: url_DeploymentsCheckExistenceAtScope_575084, schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtScope_575050 = ref object of OpenApiRestCall_573667
proc url_DeploymentsGetAtScope_575052(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtScope_575051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575053 = path.getOrDefault("deploymentName")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "deploymentName", valid_575053
  var valid_575054 = path.getOrDefault("scope")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "scope", valid_575054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575055 = query.getOrDefault("api-version")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "api-version", valid_575055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575056: Call_DeploymentsGetAtScope_575050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_575056.validator(path, query, header, formData, body)
  let scheme = call_575056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575056.url(scheme.get, call_575056.host, call_575056.base,
                         call_575056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575056, url, valid)

proc call*(call_575057: Call_DeploymentsGetAtScope_575050; apiVersion: string;
          deploymentName: string; scope: string): Recallable =
  ## deploymentsGetAtScope
  ## Gets a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575058 = newJObject()
  var query_575059 = newJObject()
  add(query_575059, "api-version", newJString(apiVersion))
  add(path_575058, "deploymentName", newJString(deploymentName))
  add(path_575058, "scope", newJString(scope))
  result = call_575057.call(path_575058, query_575059, nil, nil, nil)

var deploymentsGetAtScope* = Call_DeploymentsGetAtScope_575050(
    name: "deploymentsGetAtScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtScope_575051, base: "",
    url: url_DeploymentsGetAtScope_575052, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtScope_575072 = ref object of OpenApiRestCall_573667
proc url_DeploymentsDeleteAtScope_575074(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtScope_575073(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575075 = path.getOrDefault("deploymentName")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "deploymentName", valid_575075
  var valid_575076 = path.getOrDefault("scope")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "scope", valid_575076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575077 = query.getOrDefault("api-version")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "api-version", valid_575077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575078: Call_DeploymentsDeleteAtScope_575072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_575078.validator(path, query, header, formData, body)
  let scheme = call_575078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575078.url(scheme.get, call_575078.host, call_575078.base,
                         call_575078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575078, url, valid)

proc call*(call_575079: Call_DeploymentsDeleteAtScope_575072; apiVersion: string;
          deploymentName: string; scope: string): Recallable =
  ## deploymentsDeleteAtScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575080 = newJObject()
  var query_575081 = newJObject()
  add(query_575081, "api-version", newJString(apiVersion))
  add(path_575080, "deploymentName", newJString(deploymentName))
  add(path_575080, "scope", newJString(scope))
  result = call_575079.call(path_575080, query_575081, nil, nil, nil)

var deploymentsDeleteAtScope* = Call_DeploymentsDeleteAtScope_575072(
    name: "deploymentsDeleteAtScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtScope_575073, base: "",
    url: url_DeploymentsDeleteAtScope_575074, schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtScope_575092 = ref object of OpenApiRestCall_573667
proc url_DeploymentsCancelAtScope_575094(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtScope_575093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575095 = path.getOrDefault("deploymentName")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "deploymentName", valid_575095
  var valid_575096 = path.getOrDefault("scope")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "scope", valid_575096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575097 = query.getOrDefault("api-version")
  valid_575097 = validateParameter(valid_575097, JString, required = true,
                                 default = nil)
  if valid_575097 != nil:
    section.add "api-version", valid_575097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575098: Call_DeploymentsCancelAtScope_575092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_575098.validator(path, query, header, formData, body)
  let scheme = call_575098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575098.url(scheme.get, call_575098.host, call_575098.base,
                         call_575098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575098, url, valid)

proc call*(call_575099: Call_DeploymentsCancelAtScope_575092; apiVersion: string;
          deploymentName: string; scope: string): Recallable =
  ## deploymentsCancelAtScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575100 = newJObject()
  var query_575101 = newJObject()
  add(query_575101, "api-version", newJString(apiVersion))
  add(path_575100, "deploymentName", newJString(deploymentName))
  add(path_575100, "scope", newJString(scope))
  result = call_575099.call(path_575100, query_575101, nil, nil, nil)

var deploymentsCancelAtScope* = Call_DeploymentsCancelAtScope_575092(
    name: "deploymentsCancelAtScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtScope_575093, base: "",
    url: url_DeploymentsCancelAtScope_575094, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtScope_575102 = ref object of OpenApiRestCall_573667
proc url_DeploymentsExportTemplateAtScope_575104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtScope_575103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575105 = path.getOrDefault("deploymentName")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "deploymentName", valid_575105
  var valid_575106 = path.getOrDefault("scope")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "scope", valid_575106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575107 = query.getOrDefault("api-version")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "api-version", valid_575107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575108: Call_DeploymentsExportTemplateAtScope_575102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_575108.validator(path, query, header, formData, body)
  let scheme = call_575108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575108.url(scheme.get, call_575108.host, call_575108.base,
                         call_575108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575108, url, valid)

proc call*(call_575109: Call_DeploymentsExportTemplateAtScope_575102;
          apiVersion: string; deploymentName: string; scope: string): Recallable =
  ## deploymentsExportTemplateAtScope
  ## Exports the template used for specified deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575110 = newJObject()
  var query_575111 = newJObject()
  add(query_575111, "api-version", newJString(apiVersion))
  add(path_575110, "deploymentName", newJString(deploymentName))
  add(path_575110, "scope", newJString(scope))
  result = call_575109.call(path_575110, query_575111, nil, nil, nil)

var deploymentsExportTemplateAtScope* = Call_DeploymentsExportTemplateAtScope_575102(
    name: "deploymentsExportTemplateAtScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtScope_575103, base: "",
    url: url_DeploymentsExportTemplateAtScope_575104, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtScope_575112 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsListAtScope_575114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtScope_575113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575115 = path.getOrDefault("deploymentName")
  valid_575115 = validateParameter(valid_575115, JString, required = true,
                                 default = nil)
  if valid_575115 != nil:
    section.add "deploymentName", valid_575115
  var valid_575116 = path.getOrDefault("scope")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "scope", valid_575116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575117 = query.getOrDefault("api-version")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "api-version", valid_575117
  var valid_575118 = query.getOrDefault("$top")
  valid_575118 = validateParameter(valid_575118, JInt, required = false, default = nil)
  if valid_575118 != nil:
    section.add "$top", valid_575118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575119: Call_DeploymentOperationsListAtScope_575112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_575119.validator(path, query, header, formData, body)
  let scheme = call_575119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575119.url(scheme.get, call_575119.host, call_575119.base,
                         call_575119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575119, url, valid)

proc call*(call_575120: Call_DeploymentOperationsListAtScope_575112;
          apiVersion: string; deploymentName: string; scope: string; Top: int = 0): Recallable =
  ## deploymentOperationsListAtScope
  ## Gets all deployments operations for a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   Top: int
  ##      : The number of results to return.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575121 = newJObject()
  var query_575122 = newJObject()
  add(query_575122, "api-version", newJString(apiVersion))
  add(path_575121, "deploymentName", newJString(deploymentName))
  add(query_575122, "$top", newJInt(Top))
  add(path_575121, "scope", newJString(scope))
  result = call_575120.call(path_575121, query_575122, nil, nil, nil)

var deploymentOperationsListAtScope* = Call_DeploymentOperationsListAtScope_575112(
    name: "deploymentOperationsListAtScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtScope_575113, base: "",
    url: url_DeploymentOperationsListAtScope_575114, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtScope_575123 = ref object of OpenApiRestCall_573667
proc url_DeploymentOperationsGetAtScope_575125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtScope_575124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575126 = path.getOrDefault("deploymentName")
  valid_575126 = validateParameter(valid_575126, JString, required = true,
                                 default = nil)
  if valid_575126 != nil:
    section.add "deploymentName", valid_575126
  var valid_575127 = path.getOrDefault("scope")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "scope", valid_575127
  var valid_575128 = path.getOrDefault("operationId")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "operationId", valid_575128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575129 = query.getOrDefault("api-version")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "api-version", valid_575129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575130: Call_DeploymentOperationsGetAtScope_575123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_575130.validator(path, query, header, formData, body)
  let scheme = call_575130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575130.url(scheme.get, call_575130.host, call_575130.base,
                         call_575130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575130, url, valid)

proc call*(call_575131: Call_DeploymentOperationsGetAtScope_575123;
          apiVersion: string; deploymentName: string; scope: string;
          operationId: string): Recallable =
  ## deploymentOperationsGetAtScope
  ## Gets a deployments operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_575132 = newJObject()
  var query_575133 = newJObject()
  add(query_575133, "api-version", newJString(apiVersion))
  add(path_575132, "deploymentName", newJString(deploymentName))
  add(path_575132, "scope", newJString(scope))
  add(path_575132, "operationId", newJString(operationId))
  result = call_575131.call(path_575132, query_575133, nil, nil, nil)

var deploymentOperationsGetAtScope* = Call_DeploymentOperationsGetAtScope_575123(
    name: "deploymentOperationsGetAtScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtScope_575124, base: "",
    url: url_DeploymentOperationsGetAtScope_575125, schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtScope_575134 = ref object of OpenApiRestCall_573667
proc url_DeploymentsValidateAtScope_575136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtScope_575135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   scope: JString (required)
  ##        : The scope of a deployment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_575137 = path.getOrDefault("deploymentName")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "deploymentName", valid_575137
  var valid_575138 = path.getOrDefault("scope")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "scope", valid_575138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575139 = query.getOrDefault("api-version")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "api-version", valid_575139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575141: Call_DeploymentsValidateAtScope_575134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_575141.validator(path, query, header, formData, body)
  let scheme = call_575141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575141.url(scheme.get, call_575141.host, call_575141.base,
                         call_575141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575141, url, valid)

proc call*(call_575142: Call_DeploymentsValidateAtScope_575134; apiVersion: string;
          deploymentName: string; parameters: JsonNode; scope: string): Recallable =
  ## deploymentsValidateAtScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  ##   scope: string (required)
  ##        : The scope of a deployment.
  var path_575143 = newJObject()
  var query_575144 = newJObject()
  var body_575145 = newJObject()
  add(query_575144, "api-version", newJString(apiVersion))
  add(path_575143, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_575145 = parameters
  add(path_575143, "scope", newJString(scope))
  result = call_575142.call(path_575143, query_575144, nil, nil, body_575145)

var deploymentsValidateAtScope* = Call_DeploymentsValidateAtScope_575134(
    name: "deploymentsValidateAtScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtScope_575135, base: "",
    url: url_DeploymentsValidateAtScope_575136, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
