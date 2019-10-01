
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ResourceManagementClient
## version: 2019-05-10
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  Call_ProvidersListAtTenantScope_567889 = ref object of OpenApiRestCall_567667
proc url_ProvidersListAtTenantScope_567891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProvidersListAtTenantScope_567890(path: JsonNode; query: JsonNode;
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
  var valid_568051 = query.getOrDefault("$expand")
  valid_568051 = validateParameter(valid_568051, JString, required = false,
                                 default = nil)
  if valid_568051 != nil:
    section.add "$expand", valid_568051
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568052 = query.getOrDefault("api-version")
  valid_568052 = validateParameter(valid_568052, JString, required = true,
                                 default = nil)
  if valid_568052 != nil:
    section.add "api-version", valid_568052
  var valid_568053 = query.getOrDefault("$top")
  valid_568053 = validateParameter(valid_568053, JInt, required = false, default = nil)
  if valid_568053 != nil:
    section.add "$top", valid_568053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568076: Call_ProvidersListAtTenantScope_567889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for the tenant.
  ## 
  let valid = call_568076.validator(path, query, header, formData, body)
  let scheme = call_568076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568076.url(scheme.get, call_568076.host, call_568076.base,
                         call_568076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568076, url, valid)

proc call*(call_568147: Call_ProvidersListAtTenantScope_567889; apiVersion: string;
          Expand: string = ""; Top: int = 0): Recallable =
  ## providersListAtTenantScope
  ## Gets all resource providers for the tenant.
  ##   Expand: string
  ##         : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : The number of results to return. If null is passed returns all providers.
  var query_568148 = newJObject()
  add(query_568148, "$expand", newJString(Expand))
  add(query_568148, "api-version", newJString(apiVersion))
  add(query_568148, "$top", newJInt(Top))
  result = call_568147.call(nil, query_568148, nil, nil, nil)

var providersListAtTenantScope* = Call_ProvidersListAtTenantScope_567889(
    name: "providersListAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers",
    validator: validate_ProvidersListAtTenantScope_567890, base: "",
    url: url_ProvidersListAtTenantScope_567891, schemes: {Scheme.Https})
type
  Call_DeploymentsListAtManagementGroupScope_568188 = ref object of OpenApiRestCall_567667
proc url_DeploymentsListAtManagementGroupScope_568190(protocol: Scheme;
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

proc validate_DeploymentsListAtManagementGroupScope_568189(path: JsonNode;
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
  var valid_568205 = path.getOrDefault("groupId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "groupId", valid_568205
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
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  var valid_568207 = query.getOrDefault("$top")
  valid_568207 = validateParameter(valid_568207, JInt, required = false, default = nil)
  if valid_568207 != nil:
    section.add "$top", valid_568207
  var valid_568208 = query.getOrDefault("$filter")
  valid_568208 = validateParameter(valid_568208, JString, required = false,
                                 default = nil)
  if valid_568208 != nil:
    section.add "$filter", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_DeploymentsListAtManagementGroupScope_568188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a management group.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_DeploymentsListAtManagementGroupScope_568188;
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
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(path_568211, "groupId", newJString(groupId))
  add(query_568212, "api-version", newJString(apiVersion))
  add(query_568212, "$top", newJInt(Top))
  add(query_568212, "$filter", newJString(Filter))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var deploymentsListAtManagementGroupScope* = Call_DeploymentsListAtManagementGroupScope_568188(
    name: "deploymentsListAtManagementGroupScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtManagementGroupScope_568189, base: "",
    url: url_DeploymentsListAtManagementGroupScope_568190, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568223 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCreateOrUpdateAtManagementGroupScope_568225(protocol: Scheme;
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

proc validate_DeploymentsCreateOrUpdateAtManagementGroupScope_568224(
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
  var valid_568243 = path.getOrDefault("groupId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "groupId", valid_568243
  var valid_568244 = path.getOrDefault("deploymentName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "deploymentName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
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

proc call*(call_568247: Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568223;
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
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "groupId", newJString(groupId))
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_568251 = parameters
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var deploymentsCreateOrUpdateAtManagementGroupScope* = Call_DeploymentsCreateOrUpdateAtManagementGroupScope_568223(
    name: "deploymentsCreateOrUpdateAtManagementGroupScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtManagementGroupScope_568224,
    base: "", url: url_DeploymentsCreateOrUpdateAtManagementGroupScope_568225,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtManagementGroupScope_568262 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCheckExistenceAtManagementGroupScope_568264(protocol: Scheme;
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

proc validate_DeploymentsCheckExistenceAtManagementGroupScope_568263(
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
  var valid_568265 = path.getOrDefault("groupId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "groupId", valid_568265
  var valid_568266 = path.getOrDefault("deploymentName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "deploymentName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_DeploymentsCheckExistenceAtManagementGroupScope_568262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_DeploymentsCheckExistenceAtManagementGroupScope_568262;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCheckExistenceAtManagementGroupScope
  ## Checks whether the deployment exists.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "groupId", newJString(groupId))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "deploymentName", newJString(deploymentName))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var deploymentsCheckExistenceAtManagementGroupScope* = Call_DeploymentsCheckExistenceAtManagementGroupScope_568262(
    name: "deploymentsCheckExistenceAtManagementGroupScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtManagementGroupScope_568263,
    base: "", url: url_DeploymentsCheckExistenceAtManagementGroupScope_568264,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtManagementGroupScope_568213 = ref object of OpenApiRestCall_567667
proc url_DeploymentsGetAtManagementGroupScope_568215(protocol: Scheme;
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

proc validate_DeploymentsGetAtManagementGroupScope_568214(path: JsonNode;
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
  var valid_568216 = path.getOrDefault("groupId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "groupId", valid_568216
  var valid_568217 = path.getOrDefault("deploymentName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "deploymentName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_DeploymentsGetAtManagementGroupScope_568213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_DeploymentsGetAtManagementGroupScope_568213;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsGetAtManagementGroupScope
  ## Gets a deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(path_568221, "groupId", newJString(groupId))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "deploymentName", newJString(deploymentName))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var deploymentsGetAtManagementGroupScope* = Call_DeploymentsGetAtManagementGroupScope_568213(
    name: "deploymentsGetAtManagementGroupScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtManagementGroupScope_568214, base: "",
    url: url_DeploymentsGetAtManagementGroupScope_568215, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtManagementGroupScope_568252 = ref object of OpenApiRestCall_567667
proc url_DeploymentsDeleteAtManagementGroupScope_568254(protocol: Scheme;
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

proc validate_DeploymentsDeleteAtManagementGroupScope_568253(path: JsonNode;
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
  var valid_568255 = path.getOrDefault("groupId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "groupId", valid_568255
  var valid_568256 = path.getOrDefault("deploymentName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "deploymentName", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_DeploymentsDeleteAtManagementGroupScope_568252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_DeploymentsDeleteAtManagementGroupScope_568252;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsDeleteAtManagementGroupScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  add(path_568260, "groupId", newJString(groupId))
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "deploymentName", newJString(deploymentName))
  result = call_568259.call(path_568260, query_568261, nil, nil, nil)

var deploymentsDeleteAtManagementGroupScope* = Call_DeploymentsDeleteAtManagementGroupScope_568252(
    name: "deploymentsDeleteAtManagementGroupScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtManagementGroupScope_568253, base: "",
    url: url_DeploymentsDeleteAtManagementGroupScope_568254,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtManagementGroupScope_568272 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCancelAtManagementGroupScope_568274(protocol: Scheme;
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

proc validate_DeploymentsCancelAtManagementGroupScope_568273(path: JsonNode;
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
  var valid_568275 = path.getOrDefault("groupId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "groupId", valid_568275
  var valid_568276 = path.getOrDefault("deploymentName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "deploymentName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_DeploymentsCancelAtManagementGroupScope_568272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_DeploymentsCancelAtManagementGroupScope_568272;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsCancelAtManagementGroupScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "groupId", newJString(groupId))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "deploymentName", newJString(deploymentName))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var deploymentsCancelAtManagementGroupScope* = Call_DeploymentsCancelAtManagementGroupScope_568272(
    name: "deploymentsCancelAtManagementGroupScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtManagementGroupScope_568273, base: "",
    url: url_DeploymentsCancelAtManagementGroupScope_568274,
    schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtManagementGroupScope_568282 = ref object of OpenApiRestCall_567667
proc url_DeploymentsExportTemplateAtManagementGroupScope_568284(protocol: Scheme;
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

proc validate_DeploymentsExportTemplateAtManagementGroupScope_568283(
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
  var valid_568285 = path.getOrDefault("groupId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "groupId", valid_568285
  var valid_568286 = path.getOrDefault("deploymentName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "deploymentName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_DeploymentsExportTemplateAtManagementGroupScope_568282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_DeploymentsExportTemplateAtManagementGroupScope_568282;
          groupId: string; apiVersion: string; deploymentName: string): Recallable =
  ## deploymentsExportTemplateAtManagementGroupScope
  ## Exports the template used for specified deployment.
  ##   groupId: string (required)
  ##          : The management group ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(path_568290, "groupId", newJString(groupId))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "deploymentName", newJString(deploymentName))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var deploymentsExportTemplateAtManagementGroupScope* = Call_DeploymentsExportTemplateAtManagementGroupScope_568282(
    name: "deploymentsExportTemplateAtManagementGroupScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtManagementGroupScope_568283,
    base: "", url: url_DeploymentsExportTemplateAtManagementGroupScope_568284,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtManagementGroupScope_568292 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsListAtManagementGroupScope_568294(protocol: Scheme;
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

proc validate_DeploymentOperationsListAtManagementGroupScope_568293(
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
  var valid_568295 = path.getOrDefault("groupId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "groupId", valid_568295
  var valid_568296 = path.getOrDefault("deploymentName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "deploymentName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  var valid_568298 = query.getOrDefault("$top")
  valid_568298 = validateParameter(valid_568298, JInt, required = false, default = nil)
  if valid_568298 != nil:
    section.add "$top", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_DeploymentOperationsListAtManagementGroupScope_568292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_DeploymentOperationsListAtManagementGroupScope_568292;
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
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(path_568301, "groupId", newJString(groupId))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "deploymentName", newJString(deploymentName))
  add(query_568302, "$top", newJInt(Top))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var deploymentOperationsListAtManagementGroupScope* = Call_DeploymentOperationsListAtManagementGroupScope_568292(
    name: "deploymentOperationsListAtManagementGroupScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtManagementGroupScope_568293,
    base: "", url: url_DeploymentOperationsListAtManagementGroupScope_568294,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtManagementGroupScope_568303 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsGetAtManagementGroupScope_568305(protocol: Scheme;
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

proc validate_DeploymentOperationsGetAtManagementGroupScope_568304(
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
  var valid_568306 = path.getOrDefault("groupId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "groupId", valid_568306
  var valid_568307 = path.getOrDefault("deploymentName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "deploymentName", valid_568307
  var valid_568308 = path.getOrDefault("operationId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "operationId", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_DeploymentOperationsGetAtManagementGroupScope_568303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_DeploymentOperationsGetAtManagementGroupScope_568303;
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
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(path_568312, "groupId", newJString(groupId))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "deploymentName", newJString(deploymentName))
  add(path_568312, "operationId", newJString(operationId))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var deploymentOperationsGetAtManagementGroupScope* = Call_DeploymentOperationsGetAtManagementGroupScope_568303(
    name: "deploymentOperationsGetAtManagementGroupScope",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtManagementGroupScope_568304,
    base: "", url: url_DeploymentOperationsGetAtManagementGroupScope_568305,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtManagementGroupScope_568314 = ref object of OpenApiRestCall_567667
proc url_DeploymentsValidateAtManagementGroupScope_568316(protocol: Scheme;
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

proc validate_DeploymentsValidateAtManagementGroupScope_568315(path: JsonNode;
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
  var valid_568317 = path.getOrDefault("groupId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "groupId", valid_568317
  var valid_568318 = path.getOrDefault("deploymentName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "deploymentName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_DeploymentsValidateAtManagementGroupScope_568314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_DeploymentsValidateAtManagementGroupScope_568314;
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
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  var body_568325 = newJObject()
  add(path_568323, "groupId", newJString(groupId))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "deploymentName", newJString(deploymentName))
  if parameters != nil:
    body_568325 = parameters
  result = call_568322.call(path_568323, query_568324, nil, nil, body_568325)

var deploymentsValidateAtManagementGroupScope* = Call_DeploymentsValidateAtManagementGroupScope_568314(
    name: "deploymentsValidateAtManagementGroupScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtManagementGroupScope_568315,
    base: "", url: url_DeploymentsValidateAtManagementGroupScope_568316,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCalculateTemplateHash_568326 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCalculateTemplateHash_568328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_568327(path: JsonNode;
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
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
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

proc call*(call_568331: Call_DeploymentsCalculateTemplateHash_568326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_DeploymentsCalculateTemplateHash_568326;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_568333 = newJObject()
  var body_568334 = newJObject()
  add(query_568333, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_568334 = `template`
  result = call_568332.call(nil, query_568333, nil, nil, body_568334)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_568326(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_568327, base: "",
    url: url_DeploymentsCalculateTemplateHash_568328, schemes: {Scheme.Https})
type
  Call_OperationsList_568335 = ref object of OpenApiRestCall_567667
proc url_OperationsList_568337(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568336(path: JsonNode; query: JsonNode;
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
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_OperationsList_568335; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_OperationsList_568335; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568341 = newJObject()
  add(query_568341, "api-version", newJString(apiVersion))
  result = call_568340.call(nil, query_568341, nil, nil, nil)

var operationsList* = Call_OperationsList_568335(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_568336, base: "", url: url_OperationsList_568337,
    schemes: {Scheme.Https})
type
  Call_ProvidersGetAtTenantScope_568342 = ref object of OpenApiRestCall_567667
proc url_ProvidersGetAtTenantScope_568344(protocol: Scheme; host: string;
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

proc validate_ProvidersGetAtTenantScope_568343(path: JsonNode; query: JsonNode;
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
  var valid_568345 = path.getOrDefault("resourceProviderNamespace")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceProviderNamespace", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568346 = query.getOrDefault("$expand")
  valid_568346 = validateParameter(valid_568346, JString, required = false,
                                 default = nil)
  if valid_568346 != nil:
    section.add "$expand", valid_568346
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568348: Call_ProvidersGetAtTenantScope_568342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider at the tenant level.
  ## 
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_ProvidersGetAtTenantScope_568342; apiVersion: string;
          resourceProviderNamespace: string; Expand: string = ""): Recallable =
  ## providersGetAtTenantScope
  ## Gets the specified resource provider at the tenant level.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  add(query_568351, "$expand", newJString(Expand))
  add(query_568351, "api-version", newJString(apiVersion))
  add(path_568350, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568349.call(path_568350, query_568351, nil, nil, nil)

var providersGetAtTenantScope* = Call_ProvidersGetAtTenantScope_568342(
    name: "providersGetAtTenantScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGetAtTenantScope_568343, base: "",
    url: url_ProvidersGetAtTenantScope_568344, schemes: {Scheme.Https})
type
  Call_ProvidersList_568352 = ref object of OpenApiRestCall_567667
proc url_ProvidersList_568354(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersList_568353(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed returns all deployments.
  section = newJObject()
  var valid_568356 = query.getOrDefault("$expand")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "$expand", valid_568356
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  var valid_568358 = query.getOrDefault("$top")
  valid_568358 = validateParameter(valid_568358, JInt, required = false, default = nil)
  if valid_568358 != nil:
    section.add "$top", valid_568358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_ProvidersList_568352; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for a subscription.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_ProvidersList_568352; apiVersion: string;
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
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(query_568362, "$expand", newJString(Expand))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(query_568362, "$top", newJInt(Top))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var providersList* = Call_ProvidersList_568352(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_568353, base: "", url: url_ProvidersList_568354,
    schemes: {Scheme.Https})
type
  Call_DeploymentsListAtSubscriptionScope_568363 = ref object of OpenApiRestCall_567667
proc url_DeploymentsListAtSubscriptionScope_568365(protocol: Scheme; host: string;
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

proc validate_DeploymentsListAtSubscriptionScope_568364(path: JsonNode;
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
  var valid_568366 = path.getOrDefault("subscriptionId")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "subscriptionId", valid_568366
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
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  var valid_568368 = query.getOrDefault("$top")
  valid_568368 = validateParameter(valid_568368, JInt, required = false, default = nil)
  if valid_568368 != nil:
    section.add "$top", valid_568368
  var valid_568369 = query.getOrDefault("$filter")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = nil)
  if valid_568369 != nil:
    section.add "$filter", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_DeploymentsListAtSubscriptionScope_568363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a subscription.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_DeploymentsListAtSubscriptionScope_568363;
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
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(query_568373, "$top", newJInt(Top))
  add(query_568373, "$filter", newJString(Filter))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var deploymentsListAtSubscriptionScope* = Call_DeploymentsListAtSubscriptionScope_568363(
    name: "deploymentsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtSubscriptionScope_568364, base: "",
    url: url_DeploymentsListAtSubscriptionScope_568365, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568384 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCreateOrUpdateAtSubscriptionScope_568386(protocol: Scheme;
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

proc validate_DeploymentsCreateOrUpdateAtSubscriptionScope_568385(path: JsonNode;
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
  var valid_568387 = path.getOrDefault("deploymentName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "deploymentName", valid_568387
  var valid_568388 = path.getOrDefault("subscriptionId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "subscriptionId", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
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

proc call*(call_568391: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568384;
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
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  var body_568395 = newJObject()
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "deploymentName", newJString(deploymentName))
  add(path_568393, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568395 = parameters
  result = call_568392.call(path_568393, query_568394, nil, nil, body_568395)

var deploymentsCreateOrUpdateAtSubscriptionScope* = Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568384(
    name: "deploymentsCreateOrUpdateAtSubscriptionScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtSubscriptionScope_568385,
    base: "", url: url_DeploymentsCreateOrUpdateAtSubscriptionScope_568386,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtSubscriptionScope_568406 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCheckExistenceAtSubscriptionScope_568408(protocol: Scheme;
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

proc validate_DeploymentsCheckExistenceAtSubscriptionScope_568407(path: JsonNode;
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
  var valid_568409 = path.getOrDefault("deploymentName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "deploymentName", valid_568409
  var valid_568410 = path.getOrDefault("subscriptionId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "subscriptionId", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_DeploymentsCheckExistenceAtSubscriptionScope_568406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_DeploymentsCheckExistenceAtSubscriptionScope_568406;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCheckExistenceAtSubscriptionScope
  ## Checks whether the deployment exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "deploymentName", newJString(deploymentName))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var deploymentsCheckExistenceAtSubscriptionScope* = Call_DeploymentsCheckExistenceAtSubscriptionScope_568406(
    name: "deploymentsCheckExistenceAtSubscriptionScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtSubscriptionScope_568407,
    base: "", url: url_DeploymentsCheckExistenceAtSubscriptionScope_568408,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtSubscriptionScope_568374 = ref object of OpenApiRestCall_567667
proc url_DeploymentsGetAtSubscriptionScope_568376(protocol: Scheme; host: string;
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

proc validate_DeploymentsGetAtSubscriptionScope_568375(path: JsonNode;
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
  var valid_568377 = path.getOrDefault("deploymentName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "deploymentName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_DeploymentsGetAtSubscriptionScope_568374;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_DeploymentsGetAtSubscriptionScope_568374;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGetAtSubscriptionScope
  ## Gets a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "deploymentName", newJString(deploymentName))
  add(path_568382, "subscriptionId", newJString(subscriptionId))
  result = call_568381.call(path_568382, query_568383, nil, nil, nil)

var deploymentsGetAtSubscriptionScope* = Call_DeploymentsGetAtSubscriptionScope_568374(
    name: "deploymentsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtSubscriptionScope_568375, base: "",
    url: url_DeploymentsGetAtSubscriptionScope_568376, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtSubscriptionScope_568396 = ref object of OpenApiRestCall_567667
proc url_DeploymentsDeleteAtSubscriptionScope_568398(protocol: Scheme;
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

proc validate_DeploymentsDeleteAtSubscriptionScope_568397(path: JsonNode;
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
  var valid_568399 = path.getOrDefault("deploymentName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "deploymentName", valid_568399
  var valid_568400 = path.getOrDefault("subscriptionId")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "subscriptionId", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568402: Call_DeploymentsDeleteAtSubscriptionScope_568396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568402.validator(path, query, header, formData, body)
  let scheme = call_568402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568402.url(scheme.get, call_568402.host, call_568402.base,
                         call_568402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568402, url, valid)

proc call*(call_568403: Call_DeploymentsDeleteAtSubscriptionScope_568396;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDeleteAtSubscriptionScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568404 = newJObject()
  var query_568405 = newJObject()
  add(query_568405, "api-version", newJString(apiVersion))
  add(path_568404, "deploymentName", newJString(deploymentName))
  add(path_568404, "subscriptionId", newJString(subscriptionId))
  result = call_568403.call(path_568404, query_568405, nil, nil, nil)

var deploymentsDeleteAtSubscriptionScope* = Call_DeploymentsDeleteAtSubscriptionScope_568396(
    name: "deploymentsDeleteAtSubscriptionScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtSubscriptionScope_568397, base: "",
    url: url_DeploymentsDeleteAtSubscriptionScope_568398, schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtSubscriptionScope_568416 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCancelAtSubscriptionScope_568418(protocol: Scheme;
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

proc validate_DeploymentsCancelAtSubscriptionScope_568417(path: JsonNode;
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
  var valid_568419 = path.getOrDefault("deploymentName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "deploymentName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_DeploymentsCancelAtSubscriptionScope_568416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_DeploymentsCancelAtSubscriptionScope_568416;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancelAtSubscriptionScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(query_568425, "api-version", newJString(apiVersion))
  add(path_568424, "deploymentName", newJString(deploymentName))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var deploymentsCancelAtSubscriptionScope* = Call_DeploymentsCancelAtSubscriptionScope_568416(
    name: "deploymentsCancelAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtSubscriptionScope_568417, base: "",
    url: url_DeploymentsCancelAtSubscriptionScope_568418, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtSubscriptionScope_568426 = ref object of OpenApiRestCall_567667
proc url_DeploymentsExportTemplateAtSubscriptionScope_568428(protocol: Scheme;
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

proc validate_DeploymentsExportTemplateAtSubscriptionScope_568427(path: JsonNode;
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
  var valid_568429 = path.getOrDefault("deploymentName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "deploymentName", valid_568429
  var valid_568430 = path.getOrDefault("subscriptionId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "subscriptionId", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_DeploymentsExportTemplateAtSubscriptionScope_568426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_DeploymentsExportTemplateAtSubscriptionScope_568426;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsExportTemplateAtSubscriptionScope
  ## Exports the template used for specified deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "deploymentName", newJString(deploymentName))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  result = call_568433.call(path_568434, query_568435, nil, nil, nil)

var deploymentsExportTemplateAtSubscriptionScope* = Call_DeploymentsExportTemplateAtSubscriptionScope_568426(
    name: "deploymentsExportTemplateAtSubscriptionScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtSubscriptionScope_568427,
    base: "", url: url_DeploymentsExportTemplateAtSubscriptionScope_568428,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtSubscriptionScope_568436 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsListAtSubscriptionScope_568438(protocol: Scheme;
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

proc validate_DeploymentOperationsListAtSubscriptionScope_568437(path: JsonNode;
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
  var valid_568439 = path.getOrDefault("deploymentName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "deploymentName", valid_568439
  var valid_568440 = path.getOrDefault("subscriptionId")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "subscriptionId", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  var valid_568442 = query.getOrDefault("$top")
  valid_568442 = validateParameter(valid_568442, JInt, required = false, default = nil)
  if valid_568442 != nil:
    section.add "$top", valid_568442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568443: Call_DeploymentOperationsListAtSubscriptionScope_568436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568443.validator(path, query, header, formData, body)
  let scheme = call_568443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568443.url(scheme.get, call_568443.host, call_568443.base,
                         call_568443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568443, url, valid)

proc call*(call_568444: Call_DeploymentOperationsListAtSubscriptionScope_568436;
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
  var path_568445 = newJObject()
  var query_568446 = newJObject()
  add(query_568446, "api-version", newJString(apiVersion))
  add(path_568445, "deploymentName", newJString(deploymentName))
  add(path_568445, "subscriptionId", newJString(subscriptionId))
  add(query_568446, "$top", newJInt(Top))
  result = call_568444.call(path_568445, query_568446, nil, nil, nil)

var deploymentOperationsListAtSubscriptionScope* = Call_DeploymentOperationsListAtSubscriptionScope_568436(
    name: "deploymentOperationsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtSubscriptionScope_568437,
    base: "", url: url_DeploymentOperationsListAtSubscriptionScope_568438,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtSubscriptionScope_568447 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsGetAtSubscriptionScope_568449(protocol: Scheme;
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

proc validate_DeploymentOperationsGetAtSubscriptionScope_568448(path: JsonNode;
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
  var valid_568450 = path.getOrDefault("deploymentName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "deploymentName", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  var valid_568452 = path.getOrDefault("operationId")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "operationId", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568453 = query.getOrDefault("api-version")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "api-version", valid_568453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_DeploymentOperationsGetAtSubscriptionScope_568447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_DeploymentOperationsGetAtSubscriptionScope_568447;
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
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "deploymentName", newJString(deploymentName))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  add(path_568456, "operationId", newJString(operationId))
  result = call_568455.call(path_568456, query_568457, nil, nil, nil)

var deploymentOperationsGetAtSubscriptionScope* = Call_DeploymentOperationsGetAtSubscriptionScope_568447(
    name: "deploymentOperationsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtSubscriptionScope_568448,
    base: "", url: url_DeploymentOperationsGetAtSubscriptionScope_568449,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtSubscriptionScope_568458 = ref object of OpenApiRestCall_567667
proc url_DeploymentsValidateAtSubscriptionScope_568460(protocol: Scheme;
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

proc validate_DeploymentsValidateAtSubscriptionScope_568459(path: JsonNode;
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
  var valid_568461 = path.getOrDefault("deploymentName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "deploymentName", valid_568461
  var valid_568462 = path.getOrDefault("subscriptionId")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "subscriptionId", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
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

proc call*(call_568465: Call_DeploymentsValidateAtSubscriptionScope_568458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_DeploymentsValidateAtSubscriptionScope_568458;
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
  var path_568467 = newJObject()
  var query_568468 = newJObject()
  var body_568469 = newJObject()
  add(query_568468, "api-version", newJString(apiVersion))
  add(path_568467, "deploymentName", newJString(deploymentName))
  add(path_568467, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568469 = parameters
  result = call_568466.call(path_568467, query_568468, nil, nil, body_568469)

var deploymentsValidateAtSubscriptionScope* = Call_DeploymentsValidateAtSubscriptionScope_568458(
    name: "deploymentsValidateAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtSubscriptionScope_568459, base: "",
    url: url_DeploymentsValidateAtSubscriptionScope_568460,
    schemes: {Scheme.Https})
type
  Call_ProvidersGet_568470 = ref object of OpenApiRestCall_567667
proc url_ProvidersGet_568472(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersGet_568471(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568473 = path.getOrDefault("subscriptionId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "subscriptionId", valid_568473
  var valid_568474 = path.getOrDefault("resourceProviderNamespace")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "resourceProviderNamespace", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568475 = query.getOrDefault("$expand")
  valid_568475 = validateParameter(valid_568475, JString, required = false,
                                 default = nil)
  if valid_568475 != nil:
    section.add "$expand", valid_568475
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "api-version", valid_568476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568477: Call_ProvidersGet_568470; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider.
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_ProvidersGet_568470; apiVersion: string;
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
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  add(query_568480, "$expand", newJString(Expand))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  add(path_568479, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568478.call(path_568479, query_568480, nil, nil, nil)

var providersGet* = Call_ProvidersGet_568470(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_568471, base: "", url: url_ProvidersGet_568472,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_568481 = ref object of OpenApiRestCall_567667
proc url_ProvidersRegister_568483(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersRegister_568482(path: JsonNode; query: JsonNode;
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
  var valid_568484 = path.getOrDefault("subscriptionId")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "subscriptionId", valid_568484
  var valid_568485 = path.getOrDefault("resourceProviderNamespace")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceProviderNamespace", valid_568485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568486 = query.getOrDefault("api-version")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "api-version", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_ProvidersRegister_568481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a subscription with a resource provider.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_ProvidersRegister_568481; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers a subscription with a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to register.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(path_568489, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_568481(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_568482, base: "",
    url: url_ProvidersRegister_568483, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_568491 = ref object of OpenApiRestCall_567667
proc url_ProvidersUnregister_568493(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersUnregister_568492(path: JsonNode; query: JsonNode;
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
  var valid_568494 = path.getOrDefault("subscriptionId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "subscriptionId", valid_568494
  var valid_568495 = path.getOrDefault("resourceProviderNamespace")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "resourceProviderNamespace", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568497: Call_ProvidersUnregister_568491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters a subscription from a resource provider.
  ## 
  let valid = call_568497.validator(path, query, header, formData, body)
  let scheme = call_568497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568497.url(scheme.get, call_568497.host, call_568497.base,
                         call_568497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568497, url, valid)

proc call*(call_568498: Call_ProvidersUnregister_568491; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters a subscription from a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to unregister.
  var path_568499 = newJObject()
  var query_568500 = newJObject()
  add(query_568500, "api-version", newJString(apiVersion))
  add(path_568499, "subscriptionId", newJString(subscriptionId))
  add(path_568499, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568498.call(path_568499, query_568500, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_568491(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_568492, base: "",
    url: url_ProvidersUnregister_568493, schemes: {Scheme.Https})
type
  Call_ResourcesListByResourceGroup_568501 = ref object of OpenApiRestCall_567667
proc url_ResourcesListByResourceGroup_568503(protocol: Scheme; host: string;
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

proc validate_ResourcesListByResourceGroup_568502(path: JsonNode; query: JsonNode;
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
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
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
  var valid_568506 = query.getOrDefault("$expand")
  valid_568506 = validateParameter(valid_568506, JString, required = false,
                                 default = nil)
  if valid_568506 != nil:
    section.add "$expand", valid_568506
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  var valid_568508 = query.getOrDefault("$top")
  valid_568508 = validateParameter(valid_568508, JInt, required = false, default = nil)
  if valid_568508 != nil:
    section.add "$top", valid_568508
  var valid_568509 = query.getOrDefault("$filter")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "$filter", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_ResourcesListByResourceGroup_568501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources for a resource group.
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_ResourcesListByResourceGroup_568501;
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
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(query_568513, "$expand", newJString(Expand))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  add(query_568513, "$top", newJInt(Top))
  add(query_568513, "$filter", newJString(Filter))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var resourcesListByResourceGroup* = Call_ResourcesListByResourceGroup_568501(
    name: "resourcesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourcesListByResourceGroup_568502, base: "",
    url: url_ResourcesListByResourceGroup_568503, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_568514 = ref object of OpenApiRestCall_567667
proc url_ResourcesMoveResources_568516(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesMoveResources_568515(path: JsonNode; query: JsonNode;
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
  var valid_568517 = path.getOrDefault("sourceResourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "sourceResourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("subscriptionId")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "subscriptionId", valid_568518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568519 = query.getOrDefault("api-version")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "api-version", valid_568519
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

proc call*(call_568521: Call_ResourcesMoveResources_568514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_ResourcesMoveResources_568514; apiVersion: string;
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
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  var body_568525 = newJObject()
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568525 = parameters
  result = call_568522.call(path_568523, query_568524, nil, nil, body_568525)

var resourcesMoveResources* = Call_ResourcesMoveResources_568514(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_568515, base: "",
    url: url_ResourcesMoveResources_568516, schemes: {Scheme.Https})
type
  Call_ResourcesValidateMoveResources_568526 = ref object of OpenApiRestCall_567667
proc url_ResourcesValidateMoveResources_568528(protocol: Scheme; host: string;
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

proc validate_ResourcesValidateMoveResources_568527(path: JsonNode;
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
  var valid_568529 = path.getOrDefault("sourceResourceGroupName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "sourceResourceGroupName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
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

proc call*(call_568533: Call_ResourcesValidateMoveResources_568526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_ResourcesValidateMoveResources_568526;
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
  var path_568535 = newJObject()
  var query_568536 = newJObject()
  var body_568537 = newJObject()
  add(query_568536, "api-version", newJString(apiVersion))
  add(path_568535, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568535, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568537 = parameters
  result = call_568534.call(path_568535, query_568536, nil, nil, body_568537)

var resourcesValidateMoveResources* = Call_ResourcesValidateMoveResources_568526(
    name: "resourcesValidateMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/validateMoveResources",
    validator: validate_ResourcesValidateMoveResources_568527, base: "",
    url: url_ResourcesValidateMoveResources_568528, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_568538 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsList_568540(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsList_568539(path: JsonNode; query: JsonNode;
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
  var valid_568541 = path.getOrDefault("subscriptionId")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "subscriptionId", valid_568541
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
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  var valid_568543 = query.getOrDefault("$top")
  valid_568543 = validateParameter(valid_568543, JInt, required = false, default = nil)
  if valid_568543 != nil:
    section.add "$top", valid_568543
  var valid_568544 = query.getOrDefault("$filter")
  valid_568544 = validateParameter(valid_568544, JString, required = false,
                                 default = nil)
  if valid_568544 != nil:
    section.add "$filter", valid_568544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568545: Call_ResourceGroupsList_568538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the resource groups for a subscription.
  ## 
  let valid = call_568545.validator(path, query, header, formData, body)
  let scheme = call_568545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568545.url(scheme.get, call_568545.host, call_568545.base,
                         call_568545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568545, url, valid)

proc call*(call_568546: Call_ResourceGroupsList_568538; apiVersion: string;
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
  var path_568547 = newJObject()
  var query_568548 = newJObject()
  add(query_568548, "api-version", newJString(apiVersion))
  add(path_568547, "subscriptionId", newJString(subscriptionId))
  add(query_568548, "$top", newJInt(Top))
  add(query_568548, "$filter", newJString(Filter))
  result = call_568546.call(path_568547, query_568548, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_568538(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_568539, base: "",
    url: url_ResourceGroupsList_568540, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_568559 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsCreateOrUpdate_568561(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsCreateOrUpdate_568560(path: JsonNode; query: JsonNode;
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
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
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

proc call*(call_568566: Call_ResourceGroupsCreateOrUpdate_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a resource group.
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_ResourceGroupsCreateOrUpdate_568559;
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
  var path_568568 = newJObject()
  var query_568569 = newJObject()
  var body_568570 = newJObject()
  add(path_568568, "resourceGroupName", newJString(resourceGroupName))
  add(query_568569, "api-version", newJString(apiVersion))
  add(path_568568, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568570 = parameters
  result = call_568567.call(path_568568, query_568569, nil, nil, body_568570)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_568559(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_568560, base: "",
    url: url_ResourceGroupsCreateOrUpdate_568561, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_568581 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsCheckExistence_568583(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsCheckExistence_568582(path: JsonNode; query: JsonNode;
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
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("subscriptionId")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "subscriptionId", valid_568585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568586 = query.getOrDefault("api-version")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "api-version", valid_568586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568587: Call_ResourceGroupsCheckExistence_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource group exists.
  ## 
  let valid = call_568587.validator(path, query, header, formData, body)
  let scheme = call_568587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568587.url(scheme.get, call_568587.host, call_568587.base,
                         call_568587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568587, url, valid)

proc call*(call_568588: Call_ResourceGroupsCheckExistence_568581;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether a resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568589 = newJObject()
  var query_568590 = newJObject()
  add(path_568589, "resourceGroupName", newJString(resourceGroupName))
  add(query_568590, "api-version", newJString(apiVersion))
  add(path_568589, "subscriptionId", newJString(subscriptionId))
  result = call_568588.call(path_568589, query_568590, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_568581(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_568582, base: "",
    url: url_ResourceGroupsCheckExistence_568583, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_568549 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsGet_568551(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsGet_568550(path: JsonNode; query: JsonNode;
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
  var valid_568552 = path.getOrDefault("resourceGroupName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "resourceGroupName", valid_568552
  var valid_568553 = path.getOrDefault("subscriptionId")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "subscriptionId", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_ResourceGroupsGet_568549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource group.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_ResourceGroupsGet_568549; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Gets a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_568549(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_568550, base: "",
    url: url_ResourceGroupsGet_568551, schemes: {Scheme.Https})
type
  Call_ResourceGroupsUpdate_568591 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsUpdate_568593(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsUpdate_568592(path: JsonNode; query: JsonNode;
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
  var valid_568594 = path.getOrDefault("resourceGroupName")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "resourceGroupName", valid_568594
  var valid_568595 = path.getOrDefault("subscriptionId")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "subscriptionId", valid_568595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568596 = query.getOrDefault("api-version")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "api-version", valid_568596
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

proc call*(call_568598: Call_ResourceGroupsUpdate_568591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  let valid = call_568598.validator(path, query, header, formData, body)
  let scheme = call_568598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568598.url(scheme.get, call_568598.host, call_568598.base,
                         call_568598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568598, url, valid)

proc call*(call_568599: Call_ResourceGroupsUpdate_568591;
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
  var path_568600 = newJObject()
  var query_568601 = newJObject()
  var body_568602 = newJObject()
  add(path_568600, "resourceGroupName", newJString(resourceGroupName))
  add(query_568601, "api-version", newJString(apiVersion))
  add(path_568600, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568602 = parameters
  result = call_568599.call(path_568600, query_568601, nil, nil, body_568602)

var resourceGroupsUpdate* = Call_ResourceGroupsUpdate_568591(
    name: "resourceGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsUpdate_568592, base: "",
    url: url_ResourceGroupsUpdate_568593, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_568571 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsDelete_568573(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsDelete_568572(path: JsonNode; query: JsonNode;
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
  var valid_568574 = path.getOrDefault("resourceGroupName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "resourceGroupName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_ResourceGroupsDelete_568571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_ResourceGroupsDelete_568571;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  result = call_568578.call(path_568579, query_568580, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_568571(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_568572, base: "",
    url: url_ResourceGroupsDelete_568573, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_568603 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsList_568605(protocol: Scheme; host: string;
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

proc validate_DeploymentOperationsList_568604(path: JsonNode; query: JsonNode;
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
  var valid_568606 = path.getOrDefault("resourceGroupName")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "resourceGroupName", valid_568606
  var valid_568607 = path.getOrDefault("deploymentName")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "deploymentName", valid_568607
  var valid_568608 = path.getOrDefault("subscriptionId")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "subscriptionId", valid_568608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568609 = query.getOrDefault("api-version")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "api-version", valid_568609
  var valid_568610 = query.getOrDefault("$top")
  valid_568610 = validateParameter(valid_568610, JInt, required = false, default = nil)
  if valid_568610 != nil:
    section.add "$top", valid_568610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568611: Call_DeploymentOperationsList_568603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568611.validator(path, query, header, formData, body)
  let scheme = call_568611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568611.url(scheme.get, call_568611.host, call_568611.base,
                         call_568611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568611, url, valid)

proc call*(call_568612: Call_DeploymentOperationsList_568603;
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
  var path_568613 = newJObject()
  var query_568614 = newJObject()
  add(path_568613, "resourceGroupName", newJString(resourceGroupName))
  add(query_568614, "api-version", newJString(apiVersion))
  add(path_568613, "deploymentName", newJString(deploymentName))
  add(path_568613, "subscriptionId", newJString(subscriptionId))
  add(query_568614, "$top", newJInt(Top))
  result = call_568612.call(path_568613, query_568614, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_568603(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_568604, base: "",
    url: url_DeploymentOperationsList_568605, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_568615 = ref object of OpenApiRestCall_567667
proc url_DeploymentOperationsGet_568617(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentOperationsGet_568616(path: JsonNode; query: JsonNode;
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
  var valid_568618 = path.getOrDefault("resourceGroupName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "resourceGroupName", valid_568618
  var valid_568619 = path.getOrDefault("deploymentName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "deploymentName", valid_568619
  var valid_568620 = path.getOrDefault("subscriptionId")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "subscriptionId", valid_568620
  var valid_568621 = path.getOrDefault("operationId")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "operationId", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568623: Call_DeploymentOperationsGet_568615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568623.validator(path, query, header, formData, body)
  let scheme = call_568623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568623.url(scheme.get, call_568623.host, call_568623.base,
                         call_568623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568623, url, valid)

proc call*(call_568624: Call_DeploymentOperationsGet_568615;
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
  var path_568625 = newJObject()
  var query_568626 = newJObject()
  add(path_568625, "resourceGroupName", newJString(resourceGroupName))
  add(query_568626, "api-version", newJString(apiVersion))
  add(path_568625, "deploymentName", newJString(deploymentName))
  add(path_568625, "subscriptionId", newJString(subscriptionId))
  add(path_568625, "operationId", newJString(operationId))
  result = call_568624.call(path_568625, query_568626, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_568615(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_568616, base: "",
    url: url_DeploymentOperationsGet_568617, schemes: {Scheme.Https})
type
  Call_ResourceGroupsExportTemplate_568627 = ref object of OpenApiRestCall_567667
proc url_ResourceGroupsExportTemplate_568629(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsExportTemplate_568628(path: JsonNode; query: JsonNode;
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
  var valid_568630 = path.getOrDefault("resourceGroupName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "resourceGroupName", valid_568630
  var valid_568631 = path.getOrDefault("subscriptionId")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "subscriptionId", valid_568631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568632 = query.getOrDefault("api-version")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "api-version", valid_568632
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

proc call*(call_568634: Call_ResourceGroupsExportTemplate_568627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the specified resource group as a template.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_ResourceGroupsExportTemplate_568627;
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
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  var body_568638 = newJObject()
  add(path_568636, "resourceGroupName", newJString(resourceGroupName))
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568638 = parameters
  result = call_568635.call(path_568636, query_568637, nil, nil, body_568638)

var resourceGroupsExportTemplate* = Call_ResourceGroupsExportTemplate_568627(
    name: "resourceGroupsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/exportTemplate",
    validator: validate_ResourceGroupsExportTemplate_568628, base: "",
    url: url_ResourceGroupsExportTemplate_568629, schemes: {Scheme.Https})
type
  Call_DeploymentsListByResourceGroup_568639 = ref object of OpenApiRestCall_567667
proc url_DeploymentsListByResourceGroup_568641(protocol: Scheme; host: string;
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

proc validate_DeploymentsListByResourceGroup_568640(path: JsonNode;
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
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
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
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  var valid_568645 = query.getOrDefault("$top")
  valid_568645 = validateParameter(valid_568645, JInt, required = false, default = nil)
  if valid_568645 != nil:
    section.add "$top", valid_568645
  var valid_568646 = query.getOrDefault("$filter")
  valid_568646 = validateParameter(valid_568646, JString, required = false,
                                 default = nil)
  if valid_568646 != nil:
    section.add "$filter", valid_568646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568647: Call_DeploymentsListByResourceGroup_568639; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments for a resource group.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_DeploymentsListByResourceGroup_568639;
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
  var path_568649 = newJObject()
  var query_568650 = newJObject()
  add(path_568649, "resourceGroupName", newJString(resourceGroupName))
  add(query_568650, "api-version", newJString(apiVersion))
  add(path_568649, "subscriptionId", newJString(subscriptionId))
  add(query_568650, "$top", newJInt(Top))
  add(query_568650, "$filter", newJString(Filter))
  result = call_568648.call(path_568649, query_568650, nil, nil, nil)

var deploymentsListByResourceGroup* = Call_DeploymentsListByResourceGroup_568639(
    name: "deploymentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListByResourceGroup_568640, base: "",
    url: url_DeploymentsListByResourceGroup_568641, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_568662 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCreateOrUpdate_568664(protocol: Scheme; host: string;
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

proc validate_DeploymentsCreateOrUpdate_568663(path: JsonNode; query: JsonNode;
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
  var valid_568665 = path.getOrDefault("resourceGroupName")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "resourceGroupName", valid_568665
  var valid_568666 = path.getOrDefault("deploymentName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "deploymentName", valid_568666
  var valid_568667 = path.getOrDefault("subscriptionId")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "subscriptionId", valid_568667
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568668 = query.getOrDefault("api-version")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "api-version", valid_568668
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

proc call*(call_568670: Call_DeploymentsCreateOrUpdate_568662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568670.validator(path, query, header, formData, body)
  let scheme = call_568670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568670.url(scheme.get, call_568670.host, call_568670.base,
                         call_568670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568670, url, valid)

proc call*(call_568671: Call_DeploymentsCreateOrUpdate_568662;
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
  var path_568672 = newJObject()
  var query_568673 = newJObject()
  var body_568674 = newJObject()
  add(path_568672, "resourceGroupName", newJString(resourceGroupName))
  add(query_568673, "api-version", newJString(apiVersion))
  add(path_568672, "deploymentName", newJString(deploymentName))
  add(path_568672, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568674 = parameters
  result = call_568671.call(path_568672, query_568673, nil, nil, body_568674)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_568662(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_568663, base: "",
    url: url_DeploymentsCreateOrUpdate_568664, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_568686 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCheckExistence_568688(protocol: Scheme; host: string;
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

proc validate_DeploymentsCheckExistence_568687(path: JsonNode; query: JsonNode;
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
  var valid_568689 = path.getOrDefault("resourceGroupName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "resourceGroupName", valid_568689
  var valid_568690 = path.getOrDefault("deploymentName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "deploymentName", valid_568690
  var valid_568691 = path.getOrDefault("subscriptionId")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "subscriptionId", valid_568691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568692 = query.getOrDefault("api-version")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "api-version", valid_568692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568693: Call_DeploymentsCheckExistence_568686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568693.validator(path, query, header, formData, body)
  let scheme = call_568693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568693.url(scheme.get, call_568693.host, call_568693.base,
                         call_568693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568693, url, valid)

proc call*(call_568694: Call_DeploymentsCheckExistence_568686;
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
  var path_568695 = newJObject()
  var query_568696 = newJObject()
  add(path_568695, "resourceGroupName", newJString(resourceGroupName))
  add(query_568696, "api-version", newJString(apiVersion))
  add(path_568695, "deploymentName", newJString(deploymentName))
  add(path_568695, "subscriptionId", newJString(subscriptionId))
  result = call_568694.call(path_568695, query_568696, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_568686(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_568687, base: "",
    url: url_DeploymentsCheckExistence_568688, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_568651 = ref object of OpenApiRestCall_567667
proc url_DeploymentsGet_568653(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsGet_568652(path: JsonNode; query: JsonNode;
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
  var valid_568654 = path.getOrDefault("resourceGroupName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "resourceGroupName", valid_568654
  var valid_568655 = path.getOrDefault("deploymentName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "deploymentName", valid_568655
  var valid_568656 = path.getOrDefault("subscriptionId")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "subscriptionId", valid_568656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568657 = query.getOrDefault("api-version")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "api-version", valid_568657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568658: Call_DeploymentsGet_568651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568658.validator(path, query, header, formData, body)
  let scheme = call_568658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568658.url(scheme.get, call_568658.host, call_568658.base,
                         call_568658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568658, url, valid)

proc call*(call_568659: Call_DeploymentsGet_568651; resourceGroupName: string;
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
  var path_568660 = newJObject()
  var query_568661 = newJObject()
  add(path_568660, "resourceGroupName", newJString(resourceGroupName))
  add(query_568661, "api-version", newJString(apiVersion))
  add(path_568660, "deploymentName", newJString(deploymentName))
  add(path_568660, "subscriptionId", newJString(subscriptionId))
  result = call_568659.call(path_568660, query_568661, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_568651(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_568652, base: "", url: url_DeploymentsGet_568653,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_568675 = ref object of OpenApiRestCall_567667
proc url_DeploymentsDelete_568677(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsDelete_568676(path: JsonNode; query: JsonNode;
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
  var valid_568678 = path.getOrDefault("resourceGroupName")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "resourceGroupName", valid_568678
  var valid_568679 = path.getOrDefault("deploymentName")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "deploymentName", valid_568679
  var valid_568680 = path.getOrDefault("subscriptionId")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "subscriptionId", valid_568680
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568681 = query.getOrDefault("api-version")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "api-version", valid_568681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568682: Call_DeploymentsDelete_568675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568682.validator(path, query, header, formData, body)
  let scheme = call_568682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568682.url(scheme.get, call_568682.host, call_568682.base,
                         call_568682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568682, url, valid)

proc call*(call_568683: Call_DeploymentsDelete_568675; resourceGroupName: string;
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
  var path_568684 = newJObject()
  var query_568685 = newJObject()
  add(path_568684, "resourceGroupName", newJString(resourceGroupName))
  add(query_568685, "api-version", newJString(apiVersion))
  add(path_568684, "deploymentName", newJString(deploymentName))
  add(path_568684, "subscriptionId", newJString(subscriptionId))
  result = call_568683.call(path_568684, query_568685, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_568675(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_568676, base: "",
    url: url_DeploymentsDelete_568677, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_568697 = ref object of OpenApiRestCall_567667
proc url_DeploymentsCancel_568699(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsCancel_568698(path: JsonNode; query: JsonNode;
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
  var valid_568700 = path.getOrDefault("resourceGroupName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "resourceGroupName", valid_568700
  var valid_568701 = path.getOrDefault("deploymentName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "deploymentName", valid_568701
  var valid_568702 = path.getOrDefault("subscriptionId")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "subscriptionId", valid_568702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568703 = query.getOrDefault("api-version")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "api-version", valid_568703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568704: Call_DeploymentsCancel_568697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  let valid = call_568704.validator(path, query, header, formData, body)
  let scheme = call_568704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568704.url(scheme.get, call_568704.host, call_568704.base,
                         call_568704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568704, url, valid)

proc call*(call_568705: Call_DeploymentsCancel_568697; resourceGroupName: string;
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
  var path_568706 = newJObject()
  var query_568707 = newJObject()
  add(path_568706, "resourceGroupName", newJString(resourceGroupName))
  add(query_568707, "api-version", newJString(apiVersion))
  add(path_568706, "deploymentName", newJString(deploymentName))
  add(path_568706, "subscriptionId", newJString(subscriptionId))
  result = call_568705.call(path_568706, query_568707, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_568697(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_568698, base: "",
    url: url_DeploymentsCancel_568699, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplate_568708 = ref object of OpenApiRestCall_567667
proc url_DeploymentsExportTemplate_568710(protocol: Scheme; host: string;
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

proc validate_DeploymentsExportTemplate_568709(path: JsonNode; query: JsonNode;
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
  var valid_568711 = path.getOrDefault("resourceGroupName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "resourceGroupName", valid_568711
  var valid_568712 = path.getOrDefault("deploymentName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "deploymentName", valid_568712
  var valid_568713 = path.getOrDefault("subscriptionId")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "subscriptionId", valid_568713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568714 = query.getOrDefault("api-version")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "api-version", valid_568714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568715: Call_DeploymentsExportTemplate_568708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568715.validator(path, query, header, formData, body)
  let scheme = call_568715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568715.url(scheme.get, call_568715.host, call_568715.base,
                         call_568715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568715, url, valid)

proc call*(call_568716: Call_DeploymentsExportTemplate_568708;
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
  var path_568717 = newJObject()
  var query_568718 = newJObject()
  add(path_568717, "resourceGroupName", newJString(resourceGroupName))
  add(query_568718, "api-version", newJString(apiVersion))
  add(path_568717, "deploymentName", newJString(deploymentName))
  add(path_568717, "subscriptionId", newJString(subscriptionId))
  result = call_568716.call(path_568717, query_568718, nil, nil, nil)

var deploymentsExportTemplate* = Call_DeploymentsExportTemplate_568708(
    name: "deploymentsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplate_568709, base: "",
    url: url_DeploymentsExportTemplate_568710, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_568719 = ref object of OpenApiRestCall_567667
proc url_DeploymentsValidate_568721(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsValidate_568720(path: JsonNode; query: JsonNode;
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
  var valid_568722 = path.getOrDefault("resourceGroupName")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "resourceGroupName", valid_568722
  var valid_568723 = path.getOrDefault("deploymentName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "deploymentName", valid_568723
  var valid_568724 = path.getOrDefault("subscriptionId")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "subscriptionId", valid_568724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568725 = query.getOrDefault("api-version")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "api-version", valid_568725
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

proc call*(call_568727: Call_DeploymentsValidate_568719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568727.validator(path, query, header, formData, body)
  let scheme = call_568727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568727.url(scheme.get, call_568727.host, call_568727.base,
                         call_568727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568727, url, valid)

proc call*(call_568728: Call_DeploymentsValidate_568719; resourceGroupName: string;
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
  var path_568729 = newJObject()
  var query_568730 = newJObject()
  var body_568731 = newJObject()
  add(path_568729, "resourceGroupName", newJString(resourceGroupName))
  add(query_568730, "api-version", newJString(apiVersion))
  add(path_568729, "deploymentName", newJString(deploymentName))
  add(path_568729, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568731 = parameters
  result = call_568728.call(path_568729, query_568730, nil, nil, body_568731)

var deploymentsValidate* = Call_DeploymentsValidate_568719(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_568720, base: "",
    url: url_DeploymentsValidate_568721, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_568746 = ref object of OpenApiRestCall_567667
proc url_ResourcesCreateOrUpdate_568748(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesCreateOrUpdate_568747(path: JsonNode; query: JsonNode;
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
  var valid_568749 = path.getOrDefault("resourceType")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "resourceType", valid_568749
  var valid_568750 = path.getOrDefault("resourceGroupName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "resourceGroupName", valid_568750
  var valid_568751 = path.getOrDefault("subscriptionId")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "subscriptionId", valid_568751
  var valid_568752 = path.getOrDefault("resourceName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "resourceName", valid_568752
  var valid_568753 = path.getOrDefault("resourceProviderNamespace")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "resourceProviderNamespace", valid_568753
  var valid_568754 = path.getOrDefault("parentResourcePath")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "parentResourcePath", valid_568754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568755 = query.getOrDefault("api-version")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "api-version", valid_568755
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

proc call*(call_568757: Call_ResourcesCreateOrUpdate_568746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a resource.
  ## 
  let valid = call_568757.validator(path, query, header, formData, body)
  let scheme = call_568757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568757.url(scheme.get, call_568757.host, call_568757.base,
                         call_568757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568757, url, valid)

proc call*(call_568758: Call_ResourcesCreateOrUpdate_568746; resourceType: string;
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
  var path_568759 = newJObject()
  var query_568760 = newJObject()
  var body_568761 = newJObject()
  add(path_568759, "resourceType", newJString(resourceType))
  add(path_568759, "resourceGroupName", newJString(resourceGroupName))
  add(query_568760, "api-version", newJString(apiVersion))
  add(path_568759, "subscriptionId", newJString(subscriptionId))
  add(path_568759, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568761 = parameters
  add(path_568759, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568759, "parentResourcePath", newJString(parentResourcePath))
  result = call_568758.call(path_568759, query_568760, nil, nil, body_568761)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_568746(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_568747, base: "",
    url: url_ResourcesCreateOrUpdate_568748, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_568776 = ref object of OpenApiRestCall_567667
proc url_ResourcesCheckExistence_568778(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesCheckExistence_568777(path: JsonNode; query: JsonNode;
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
  var valid_568779 = path.getOrDefault("resourceType")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "resourceType", valid_568779
  var valid_568780 = path.getOrDefault("resourceGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceGroupName", valid_568780
  var valid_568781 = path.getOrDefault("subscriptionId")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "subscriptionId", valid_568781
  var valid_568782 = path.getOrDefault("resourceName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "resourceName", valid_568782
  var valid_568783 = path.getOrDefault("resourceProviderNamespace")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "resourceProviderNamespace", valid_568783
  var valid_568784 = path.getOrDefault("parentResourcePath")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "parentResourcePath", valid_568784
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568785 = query.getOrDefault("api-version")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "api-version", valid_568785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568786: Call_ResourcesCheckExistence_568776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource exists.
  ## 
  let valid = call_568786.validator(path, query, header, formData, body)
  let scheme = call_568786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568786.url(scheme.get, call_568786.host, call_568786.base,
                         call_568786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568786, url, valid)

proc call*(call_568787: Call_ResourcesCheckExistence_568776; resourceType: string;
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
  var path_568788 = newJObject()
  var query_568789 = newJObject()
  add(path_568788, "resourceType", newJString(resourceType))
  add(path_568788, "resourceGroupName", newJString(resourceGroupName))
  add(query_568789, "api-version", newJString(apiVersion))
  add(path_568788, "subscriptionId", newJString(subscriptionId))
  add(path_568788, "resourceName", newJString(resourceName))
  add(path_568788, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568788, "parentResourcePath", newJString(parentResourcePath))
  result = call_568787.call(path_568788, query_568789, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_568776(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_568777, base: "",
    url: url_ResourcesCheckExistence_568778, schemes: {Scheme.Https})
type
  Call_ResourcesGet_568732 = ref object of OpenApiRestCall_567667
proc url_ResourcesGet_568734(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesGet_568733(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568735 = path.getOrDefault("resourceType")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "resourceType", valid_568735
  var valid_568736 = path.getOrDefault("resourceGroupName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "resourceGroupName", valid_568736
  var valid_568737 = path.getOrDefault("subscriptionId")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "subscriptionId", valid_568737
  var valid_568738 = path.getOrDefault("resourceName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "resourceName", valid_568738
  var valid_568739 = path.getOrDefault("resourceProviderNamespace")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "resourceProviderNamespace", valid_568739
  var valid_568740 = path.getOrDefault("parentResourcePath")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "parentResourcePath", valid_568740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568741 = query.getOrDefault("api-version")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "api-version", valid_568741
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568742: Call_ResourcesGet_568732; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource.
  ## 
  let valid = call_568742.validator(path, query, header, formData, body)
  let scheme = call_568742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568742.url(scheme.get, call_568742.host, call_568742.base,
                         call_568742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568742, url, valid)

proc call*(call_568743: Call_ResourcesGet_568732; resourceType: string;
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
  var path_568744 = newJObject()
  var query_568745 = newJObject()
  add(path_568744, "resourceType", newJString(resourceType))
  add(path_568744, "resourceGroupName", newJString(resourceGroupName))
  add(query_568745, "api-version", newJString(apiVersion))
  add(path_568744, "subscriptionId", newJString(subscriptionId))
  add(path_568744, "resourceName", newJString(resourceName))
  add(path_568744, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568744, "parentResourcePath", newJString(parentResourcePath))
  result = call_568743.call(path_568744, query_568745, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_568732(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_568733, base: "", url: url_ResourcesGet_568734,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_568790 = ref object of OpenApiRestCall_567667
proc url_ResourcesUpdate_568792(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesUpdate_568791(path: JsonNode; query: JsonNode;
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
  var valid_568793 = path.getOrDefault("resourceType")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "resourceType", valid_568793
  var valid_568794 = path.getOrDefault("resourceGroupName")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "resourceGroupName", valid_568794
  var valid_568795 = path.getOrDefault("subscriptionId")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "subscriptionId", valid_568795
  var valid_568796 = path.getOrDefault("resourceName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "resourceName", valid_568796
  var valid_568797 = path.getOrDefault("resourceProviderNamespace")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "resourceProviderNamespace", valid_568797
  var valid_568798 = path.getOrDefault("parentResourcePath")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "parentResourcePath", valid_568798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568799 = query.getOrDefault("api-version")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "api-version", valid_568799
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

proc call*(call_568801: Call_ResourcesUpdate_568790; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_568801.validator(path, query, header, formData, body)
  let scheme = call_568801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568801.url(scheme.get, call_568801.host, call_568801.base,
                         call_568801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568801, url, valid)

proc call*(call_568802: Call_ResourcesUpdate_568790; resourceType: string;
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
  var path_568803 = newJObject()
  var query_568804 = newJObject()
  var body_568805 = newJObject()
  add(path_568803, "resourceType", newJString(resourceType))
  add(path_568803, "resourceGroupName", newJString(resourceGroupName))
  add(query_568804, "api-version", newJString(apiVersion))
  add(path_568803, "subscriptionId", newJString(subscriptionId))
  add(path_568803, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568805 = parameters
  add(path_568803, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568803, "parentResourcePath", newJString(parentResourcePath))
  result = call_568802.call(path_568803, query_568804, nil, nil, body_568805)

var resourcesUpdate* = Call_ResourcesUpdate_568790(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_568791, base: "", url: url_ResourcesUpdate_568792,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_568762 = ref object of OpenApiRestCall_567667
proc url_ResourcesDelete_568764(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesDelete_568763(path: JsonNode; query: JsonNode;
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
  var valid_568765 = path.getOrDefault("resourceType")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceType", valid_568765
  var valid_568766 = path.getOrDefault("resourceGroupName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "resourceGroupName", valid_568766
  var valid_568767 = path.getOrDefault("subscriptionId")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "subscriptionId", valid_568767
  var valid_568768 = path.getOrDefault("resourceName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "resourceName", valid_568768
  var valid_568769 = path.getOrDefault("resourceProviderNamespace")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "resourceProviderNamespace", valid_568769
  var valid_568770 = path.getOrDefault("parentResourcePath")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "parentResourcePath", valid_568770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568771 = query.getOrDefault("api-version")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "api-version", valid_568771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568772: Call_ResourcesDelete_568762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource.
  ## 
  let valid = call_568772.validator(path, query, header, formData, body)
  let scheme = call_568772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568772.url(scheme.get, call_568772.host, call_568772.base,
                         call_568772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568772, url, valid)

proc call*(call_568773: Call_ResourcesDelete_568762; resourceType: string;
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
  var path_568774 = newJObject()
  var query_568775 = newJObject()
  add(path_568774, "resourceType", newJString(resourceType))
  add(path_568774, "resourceGroupName", newJString(resourceGroupName))
  add(query_568775, "api-version", newJString(apiVersion))
  add(path_568774, "subscriptionId", newJString(subscriptionId))
  add(path_568774, "resourceName", newJString(resourceName))
  add(path_568774, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568774, "parentResourcePath", newJString(parentResourcePath))
  result = call_568773.call(path_568774, query_568775, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_568762(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_568763, base: "", url: url_ResourcesDelete_568764,
    schemes: {Scheme.Https})
type
  Call_ResourcesList_568806 = ref object of OpenApiRestCall_567667
proc url_ResourcesList_568808(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesList_568807(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568809 = path.getOrDefault("subscriptionId")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "subscriptionId", valid_568809
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
  var valid_568810 = query.getOrDefault("$expand")
  valid_568810 = validateParameter(valid_568810, JString, required = false,
                                 default = nil)
  if valid_568810 != nil:
    section.add "$expand", valid_568810
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568811 = query.getOrDefault("api-version")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "api-version", valid_568811
  var valid_568812 = query.getOrDefault("$top")
  valid_568812 = validateParameter(valid_568812, JInt, required = false, default = nil)
  if valid_568812 != nil:
    section.add "$top", valid_568812
  var valid_568813 = query.getOrDefault("$filter")
  valid_568813 = validateParameter(valid_568813, JString, required = false,
                                 default = nil)
  if valid_568813 != nil:
    section.add "$filter", valid_568813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568814: Call_ResourcesList_568806; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources in a subscription.
  ## 
  let valid = call_568814.validator(path, query, header, formData, body)
  let scheme = call_568814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568814.url(scheme.get, call_568814.host, call_568814.base,
                         call_568814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568814, url, valid)

proc call*(call_568815: Call_ResourcesList_568806; apiVersion: string;
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
  var path_568816 = newJObject()
  var query_568817 = newJObject()
  add(query_568817, "$expand", newJString(Expand))
  add(query_568817, "api-version", newJString(apiVersion))
  add(path_568816, "subscriptionId", newJString(subscriptionId))
  add(query_568817, "$top", newJInt(Top))
  add(query_568817, "$filter", newJString(Filter))
  result = call_568815.call(path_568816, query_568817, nil, nil, nil)

var resourcesList* = Call_ResourcesList_568806(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_568807, base: "", url: url_ResourcesList_568808,
    schemes: {Scheme.Https})
type
  Call_TagsList_568818 = ref object of OpenApiRestCall_567667
proc url_TagsList_568820(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsList_568819(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568821 = path.getOrDefault("subscriptionId")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "subscriptionId", valid_568821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568822 = query.getOrDefault("api-version")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "api-version", valid_568822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568823: Call_TagsList_568818; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  let valid = call_568823.validator(path, query, header, formData, body)
  let scheme = call_568823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568823.url(scheme.get, call_568823.host, call_568823.base,
                         call_568823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568823, url, valid)

proc call*(call_568824: Call_TagsList_568818; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568825 = newJObject()
  var query_568826 = newJObject()
  add(query_568826, "api-version", newJString(apiVersion))
  add(path_568825, "subscriptionId", newJString(subscriptionId))
  result = call_568824.call(path_568825, query_568826, nil, nil, nil)

var tagsList* = Call_TagsList_568818(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_568819, base: "",
                                  url: url_TagsList_568820,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_568827 = ref object of OpenApiRestCall_567667
proc url_TagsCreateOrUpdate_568829(protocol: Scheme; host: string; base: string;
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

proc validate_TagsCreateOrUpdate_568828(path: JsonNode; query: JsonNode;
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
  var valid_568830 = path.getOrDefault("tagName")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "tagName", valid_568830
  var valid_568831 = path.getOrDefault("subscriptionId")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "subscriptionId", valid_568831
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568832 = query.getOrDefault("api-version")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "api-version", valid_568832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568833: Call_TagsCreateOrUpdate_568827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  let valid = call_568833.validator(path, query, header, formData, body)
  let scheme = call_568833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568833.url(scheme.get, call_568833.host, call_568833.base,
                         call_568833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568833, url, valid)

proc call*(call_568834: Call_TagsCreateOrUpdate_568827; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568835 = newJObject()
  var query_568836 = newJObject()
  add(query_568836, "api-version", newJString(apiVersion))
  add(path_568835, "tagName", newJString(tagName))
  add(path_568835, "subscriptionId", newJString(subscriptionId))
  result = call_568834.call(path_568835, query_568836, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_568827(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_568828, base: "",
    url: url_TagsCreateOrUpdate_568829, schemes: {Scheme.Https})
type
  Call_TagsDelete_568837 = ref object of OpenApiRestCall_567667
proc url_TagsDelete_568839(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsDelete_568838(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568840 = path.getOrDefault("tagName")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "tagName", valid_568840
  var valid_568841 = path.getOrDefault("subscriptionId")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "subscriptionId", valid_568841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568842 = query.getOrDefault("api-version")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "api-version", valid_568842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568843: Call_TagsDelete_568837; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  let valid = call_568843.validator(path, query, header, formData, body)
  let scheme = call_568843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568843.url(scheme.get, call_568843.host, call_568843.base,
                         call_568843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568843, url, valid)

proc call*(call_568844: Call_TagsDelete_568837; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## You must remove all values from a resource tag before you can delete it.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568845 = newJObject()
  var query_568846 = newJObject()
  add(query_568846, "api-version", newJString(apiVersion))
  add(path_568845, "tagName", newJString(tagName))
  add(path_568845, "subscriptionId", newJString(subscriptionId))
  result = call_568844.call(path_568845, query_568846, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_568837(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_568838,
                                      base: "", url: url_TagsDelete_568839,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_568847 = ref object of OpenApiRestCall_567667
proc url_TagsCreateOrUpdateValue_568849(protocol: Scheme; host: string; base: string;
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

proc validate_TagsCreateOrUpdateValue_568848(path: JsonNode; query: JsonNode;
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
  var valid_568850 = path.getOrDefault("tagName")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "tagName", valid_568850
  var valid_568851 = path.getOrDefault("subscriptionId")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "subscriptionId", valid_568851
  var valid_568852 = path.getOrDefault("tagValue")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "tagValue", valid_568852
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568853 = query.getOrDefault("api-version")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "api-version", valid_568853
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568854: Call_TagsCreateOrUpdateValue_568847; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  let valid = call_568854.validator(path, query, header, formData, body)
  let scheme = call_568854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568854.url(scheme.get, call_568854.host, call_568854.base,
                         call_568854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568854, url, valid)

proc call*(call_568855: Call_TagsCreateOrUpdateValue_568847; apiVersion: string;
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
  var path_568856 = newJObject()
  var query_568857 = newJObject()
  add(query_568857, "api-version", newJString(apiVersion))
  add(path_568856, "tagName", newJString(tagName))
  add(path_568856, "subscriptionId", newJString(subscriptionId))
  add(path_568856, "tagValue", newJString(tagValue))
  result = call_568855.call(path_568856, query_568857, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_568847(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_568848, base: "",
    url: url_TagsCreateOrUpdateValue_568849, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_568858 = ref object of OpenApiRestCall_567667
proc url_TagsDeleteValue_568860(protocol: Scheme; host: string; base: string;
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

proc validate_TagsDeleteValue_568859(path: JsonNode; query: JsonNode;
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
  var valid_568861 = path.getOrDefault("tagName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "tagName", valid_568861
  var valid_568862 = path.getOrDefault("subscriptionId")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "subscriptionId", valid_568862
  var valid_568863 = path.getOrDefault("tagValue")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "tagValue", valid_568863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568864 = query.getOrDefault("api-version")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "api-version", valid_568864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568865: Call_TagsDeleteValue_568858; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a tag value.
  ## 
  let valid = call_568865.validator(path, query, header, formData, body)
  let scheme = call_568865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568865.url(scheme.get, call_568865.host, call_568865.base,
                         call_568865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568865, url, valid)

proc call*(call_568866: Call_TagsDeleteValue_568858; apiVersion: string;
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
  var path_568867 = newJObject()
  var query_568868 = newJObject()
  add(query_568868, "api-version", newJString(apiVersion))
  add(path_568867, "tagName", newJString(tagName))
  add(path_568867, "subscriptionId", newJString(subscriptionId))
  add(path_568867, "tagValue", newJString(tagValue))
  result = call_568866.call(path_568867, query_568868, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_568858(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_568859, base: "", url: url_TagsDeleteValue_568860,
    schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdateById_568878 = ref object of OpenApiRestCall_567667
proc url_ResourcesCreateOrUpdateById_568880(protocol: Scheme; host: string;
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

proc validate_ResourcesCreateOrUpdateById_568879(path: JsonNode; query: JsonNode;
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
  var valid_568881 = path.getOrDefault("resourceId")
  valid_568881 = validateParameter(valid_568881, JString, required = true,
                                 default = nil)
  if valid_568881 != nil:
    section.add "resourceId", valid_568881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568882 = query.getOrDefault("api-version")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = nil)
  if valid_568882 != nil:
    section.add "api-version", valid_568882
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

proc call*(call_568884: Call_ResourcesCreateOrUpdateById_568878; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource by ID.
  ## 
  let valid = call_568884.validator(path, query, header, formData, body)
  let scheme = call_568884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568884.url(scheme.get, call_568884.host, call_568884.base,
                         call_568884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568884, url, valid)

proc call*(call_568885: Call_ResourcesCreateOrUpdateById_568878;
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
  var path_568886 = newJObject()
  var query_568887 = newJObject()
  var body_568888 = newJObject()
  add(query_568887, "api-version", newJString(apiVersion))
  add(path_568886, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568888 = parameters
  result = call_568885.call(path_568886, query_568887, nil, nil, body_568888)

var resourcesCreateOrUpdateById* = Call_ResourcesCreateOrUpdateById_568878(
    name: "resourcesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCreateOrUpdateById_568879, base: "",
    url: url_ResourcesCreateOrUpdateById_568880, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistenceById_568898 = ref object of OpenApiRestCall_567667
proc url_ResourcesCheckExistenceById_568900(protocol: Scheme; host: string;
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

proc validate_ResourcesCheckExistenceById_568899(path: JsonNode; query: JsonNode;
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
  var valid_568901 = path.getOrDefault("resourceId")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "resourceId", valid_568901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568902 = query.getOrDefault("api-version")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "api-version", valid_568902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568903: Call_ResourcesCheckExistenceById_568898; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks by ID whether a resource exists.
  ## 
  let valid = call_568903.validator(path, query, header, formData, body)
  let scheme = call_568903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568903.url(scheme.get, call_568903.host, call_568903.base,
                         call_568903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568903, url, valid)

proc call*(call_568904: Call_ResourcesCheckExistenceById_568898;
          apiVersion: string; resourceId: string): Recallable =
  ## resourcesCheckExistenceById
  ## Checks by ID whether a resource exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568905 = newJObject()
  var query_568906 = newJObject()
  add(query_568906, "api-version", newJString(apiVersion))
  add(path_568905, "resourceId", newJString(resourceId))
  result = call_568904.call(path_568905, query_568906, nil, nil, nil)

var resourcesCheckExistenceById* = Call_ResourcesCheckExistenceById_568898(
    name: "resourcesCheckExistenceById", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCheckExistenceById_568899, base: "",
    url: url_ResourcesCheckExistenceById_568900, schemes: {Scheme.Https})
type
  Call_ResourcesGetById_568869 = ref object of OpenApiRestCall_567667
proc url_ResourcesGetById_568871(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesGetById_568870(path: JsonNode; query: JsonNode;
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
  var valid_568872 = path.getOrDefault("resourceId")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "resourceId", valid_568872
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568873 = query.getOrDefault("api-version")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "api-version", valid_568873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568874: Call_ResourcesGetById_568869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource by ID.
  ## 
  let valid = call_568874.validator(path, query, header, formData, body)
  let scheme = call_568874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568874.url(scheme.get, call_568874.host, call_568874.base,
                         call_568874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568874, url, valid)

proc call*(call_568875: Call_ResourcesGetById_568869; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesGetById
  ## Gets a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568876 = newJObject()
  var query_568877 = newJObject()
  add(query_568877, "api-version", newJString(apiVersion))
  add(path_568876, "resourceId", newJString(resourceId))
  result = call_568875.call(path_568876, query_568877, nil, nil, nil)

var resourcesGetById* = Call_ResourcesGetById_568869(name: "resourcesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesGetById_568870, base: "",
    url: url_ResourcesGetById_568871, schemes: {Scheme.Https})
type
  Call_ResourcesUpdateById_568907 = ref object of OpenApiRestCall_567667
proc url_ResourcesUpdateById_568909(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesUpdateById_568908(path: JsonNode; query: JsonNode;
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
  var valid_568910 = path.getOrDefault("resourceId")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "resourceId", valid_568910
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568911 = query.getOrDefault("api-version")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "api-version", valid_568911
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

proc call*(call_568913: Call_ResourcesUpdateById_568907; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource by ID.
  ## 
  let valid = call_568913.validator(path, query, header, formData, body)
  let scheme = call_568913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568913.url(scheme.get, call_568913.host, call_568913.base,
                         call_568913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568913, url, valid)

proc call*(call_568914: Call_ResourcesUpdateById_568907; apiVersion: string;
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
  var path_568915 = newJObject()
  var query_568916 = newJObject()
  var body_568917 = newJObject()
  add(query_568916, "api-version", newJString(apiVersion))
  add(path_568915, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568917 = parameters
  result = call_568914.call(path_568915, query_568916, nil, nil, body_568917)

var resourcesUpdateById* = Call_ResourcesUpdateById_568907(
    name: "resourcesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesUpdateById_568908, base: "",
    url: url_ResourcesUpdateById_568909, schemes: {Scheme.Https})
type
  Call_ResourcesDeleteById_568889 = ref object of OpenApiRestCall_567667
proc url_ResourcesDeleteById_568891(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesDeleteById_568890(path: JsonNode; query: JsonNode;
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
  var valid_568892 = path.getOrDefault("resourceId")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "resourceId", valid_568892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568893 = query.getOrDefault("api-version")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "api-version", valid_568893
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568894: Call_ResourcesDeleteById_568889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource by ID.
  ## 
  let valid = call_568894.validator(path, query, header, formData, body)
  let scheme = call_568894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568894.url(scheme.get, call_568894.host, call_568894.base,
                         call_568894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568894, url, valid)

proc call*(call_568895: Call_ResourcesDeleteById_568889; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesDeleteById
  ## Deletes a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568896 = newJObject()
  var query_568897 = newJObject()
  add(query_568897, "api-version", newJString(apiVersion))
  add(path_568896, "resourceId", newJString(resourceId))
  result = call_568895.call(path_568896, query_568897, nil, nil, nil)

var resourcesDeleteById* = Call_ResourcesDeleteById_568889(
    name: "resourcesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesDeleteById_568890, base: "",
    url: url_ResourcesDeleteById_568891, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
