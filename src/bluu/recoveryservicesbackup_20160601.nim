
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesBackupClient
## version: 2016-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567651 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567651](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567651): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesGet_567873 = ref object of OpenApiRestCall_567651
proc url_BackupEnginesGet_567875(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupEngines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupEnginesGet_567874(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568049 = path.getOrDefault("resourceGroupName")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "resourceGroupName", valid_568049
  var valid_568050 = path.getOrDefault("subscriptionId")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "subscriptionId", valid_568050
  var valid_568051 = path.getOrDefault("vaultName")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "vaultName", valid_568051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   $filter: JString
  ##          : Use this filter to choose the specific backup management server. backupManagementType { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568052 = query.getOrDefault("api-version")
  valid_568052 = validateParameter(valid_568052, JString, required = true,
                                 default = nil)
  if valid_568052 != nil:
    section.add "api-version", valid_568052
  var valid_568053 = query.getOrDefault("$skipToken")
  valid_568053 = validateParameter(valid_568053, JString, required = false,
                                 default = nil)
  if valid_568053 != nil:
    section.add "$skipToken", valid_568053
  var valid_568054 = query.getOrDefault("$filter")
  valid_568054 = validateParameter(valid_568054, JString, required = false,
                                 default = nil)
  if valid_568054 != nil:
    section.add "$filter", valid_568054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568077: Call_BackupEnginesGet_567873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ## 
  let valid = call_568077.validator(path, query, header, formData, body)
  let scheme = call_568077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568077.url(scheme.get, call_568077.host, call_568077.base,
                         call_568077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568077, url, valid)

proc call*(call_568148: Call_BackupEnginesGet_567873; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesGet
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   Filter: string
  ##         : Use this filter to choose the specific backup management server. backupManagementType { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_568149 = newJObject()
  var query_568151 = newJObject()
  add(path_568149, "resourceGroupName", newJString(resourceGroupName))
  add(query_568151, "api-version", newJString(apiVersion))
  add(path_568149, "subscriptionId", newJString(subscriptionId))
  add(path_568149, "vaultName", newJString(vaultName))
  add(query_568151, "$skipToken", newJString(SkipToken))
  add(query_568151, "$filter", newJString(Filter))
  result = call_568148.call(path_568149, query_568151, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_567873(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesGet_567874, base: "",
    url: url_BackupEnginesGet_567875, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_568190 = ref object of OpenApiRestCall_567651
proc url_ProtectionContainerRefreshOperationResultsGet_568192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainerRefreshOperationResultsGet_568191(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The operation ID used for this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568193 = path.getOrDefault("fabricName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "fabricName", valid_568193
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  var valid_568196 = path.getOrDefault("vaultName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "vaultName", valid_568196
  var valid_568197 = path.getOrDefault("operationId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "operationId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_ProtectionContainerRefreshOperationResultsGet_568190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_ProtectionContainerRefreshOperationResultsGet_568190;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string; operationId: string): Recallable =
  ## protectionContainerRefreshOperationResultsGet
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The operation ID used for this GET operation.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "fabricName", newJString(fabricName))
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(path_568201, "vaultName", newJString(vaultName))
  add(path_568201, "operationId", newJString(operationId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_568190(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_568191,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_568192,
    schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_568203 = ref object of OpenApiRestCall_567651
proc url_ProtectionContainersGet_568205(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersGet_568204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specific container registered to your Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568206 = path.getOrDefault("fabricName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "fabricName", valid_568206
  var valid_568207 = path.getOrDefault("resourceGroupName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "resourceGroupName", valid_568207
  var valid_568208 = path.getOrDefault("containerName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "containerName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  var valid_568210 = path.getOrDefault("vaultName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "vaultName", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_ProtectionContainersGet_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services vault.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_ProtectionContainersGet_568203; fabricName: string;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersGet
  ## Gets details of the specific container registered to your Recovery Services vault.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "fabricName", newJString(fabricName))
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "containerName", newJString(containerName))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(path_568214, "vaultName", newJString(vaultName))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_568203(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_568204, base: "",
    url: url_ProtectionContainersGet_568205, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_568216 = ref object of OpenApiRestCall_567651
proc url_ProtectionContainerOperationResultsGet_568218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainerOperationResultsGet_568217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of any operation on the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The operation ID used for this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568219 = path.getOrDefault("fabricName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "fabricName", valid_568219
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("containerName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "containerName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("vaultName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "vaultName", valid_568223
  var valid_568224 = path.getOrDefault("operationId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "operationId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_ProtectionContainerOperationResultsGet_568216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the result of any operation on the container.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_ProtectionContainerOperationResultsGet_568216;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          operationId: string): Recallable =
  ## protectionContainerOperationResultsGet
  ## Gets the result of any operation on the container.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The operation ID used for this GET operation.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(path_568228, "fabricName", newJString(fabricName))
  add(path_568228, "resourceGroupName", newJString(resourceGroupName))
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "containerName", newJString(containerName))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(path_568228, "vaultName", newJString(vaultName))
  add(path_568228, "operationId", newJString(operationId))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_568216(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_568217, base: "",
    url: url_ProtectionContainerOperationResultsGet_568218,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_568245 = ref object of OpenApiRestCall_567651
proc url_ProtectedItemsCreateOrUpdate_568247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsCreateOrUpdate_568246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568265 = path.getOrDefault("fabricName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "fabricName", valid_568265
  var valid_568266 = path.getOrDefault("protectedItemName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "protectedItemName", valid_568266
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("containerName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "containerName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("vaultName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "vaultName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceProtectedItem: JObject (required)
  ##                        : The resource backup item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_ProtectedItemsCreateOrUpdate_568245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_ProtectedItemsCreateOrUpdate_568245;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          resourceProtectedItem: JsonNode; vaultName: string): Recallable =
  ## protectedItemsCreateOrUpdate
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceProtectedItem: JObject (required)
  ##                        : The resource backup item.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  var body_568277 = newJObject()
  add(path_568275, "fabricName", newJString(fabricName))
  add(path_568275, "protectedItemName", newJString(protectedItemName))
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "containerName", newJString(containerName))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  if resourceProtectedItem != nil:
    body_568277 = resourceProtectedItem
  add(path_568275, "vaultName", newJString(vaultName))
  result = call_568274.call(path_568275, query_568276, nil, nil, body_568277)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_568245(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_568246, base: "",
    url: url_ProtectedItemsCreateOrUpdate_568247, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_568230 = ref object of OpenApiRestCall_567651
proc url_ProtectedItemsGet_568232(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsGet_568231(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The backup item name used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568233 = path.getOrDefault("fabricName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "fabricName", valid_568233
  var valid_568234 = path.getOrDefault("protectedItemName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "protectedItemName", valid_568234
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
  var valid_568236 = path.getOrDefault("containerName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "containerName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("vaultName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "vaultName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : expand eq {extendedInfo}. This filter enables you to choose (or filter) specific items in the list of backup items.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  var valid_568240 = query.getOrDefault("$filter")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "$filter", valid_568240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_ProtectedItemsGet_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_ProtectedItemsGet_568230; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## protectedItemsGet
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The backup item name used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : expand eq {extendedInfo}. This filter enables you to choose (or filter) specific items in the list of backup items.
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  add(path_568243, "fabricName", newJString(fabricName))
  add(path_568243, "protectedItemName", newJString(protectedItemName))
  add(path_568243, "resourceGroupName", newJString(resourceGroupName))
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "containerName", newJString(containerName))
  add(path_568243, "subscriptionId", newJString(subscriptionId))
  add(path_568243, "vaultName", newJString(vaultName))
  add(query_568244, "$filter", newJString(Filter))
  result = call_568242.call(path_568243, query_568244, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_568230(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_568231, base: "",
    url: url_ProtectedItemsGet_568232, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_568278 = ref object of OpenApiRestCall_567651
proc url_ProtectedItemsDelete_568280(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsDelete_568279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             :  The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The backup item to be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568281 = path.getOrDefault("fabricName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "fabricName", valid_568281
  var valid_568282 = path.getOrDefault("protectedItemName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "protectedItemName", valid_568282
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("containerName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "containerName", valid_568284
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
  var valid_568286 = path.getOrDefault("vaultName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "vaultName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568288: Call_ProtectedItemsDelete_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_ProtectedItemsDelete_568278; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string): Recallable =
  ## protectedItemsDelete
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             :  The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The backup item to be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(path_568290, "fabricName", newJString(fabricName))
  add(path_568290, "protectedItemName", newJString(protectedItemName))
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "containerName", newJString(containerName))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "vaultName", newJString(vaultName))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_568278(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_568279, base: "",
    url: url_ProtectedItemsDelete_568280, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_568292 = ref object of OpenApiRestCall_567651
proc url_BackupsTrigger_568294(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsTrigger_568293(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this POST operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568295 = path.getOrDefault("fabricName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "fabricName", valid_568295
  var valid_568296 = path.getOrDefault("protectedItemName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "protectedItemName", valid_568296
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("containerName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "containerName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("vaultName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "vaultName", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceBackupRequest: JObject (required)
  ##                        : The resource backup request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_BackupsTrigger_568292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_BackupsTrigger_568292; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; resourceBackupRequest: JsonNode;
          subscriptionId: string; vaultName: string): Recallable =
  ## backupsTrigger
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this POST operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   resourceBackupRequest: JObject (required)
  ##                        : The resource backup request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  var body_568307 = newJObject()
  add(path_568305, "fabricName", newJString(fabricName))
  add(path_568305, "protectedItemName", newJString(protectedItemName))
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "containerName", newJString(containerName))
  if resourceBackupRequest != nil:
    body_568307 = resourceBackupRequest
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  add(path_568305, "vaultName", newJString(vaultName))
  result = call_568304.call(path_568305, query_568306, nil, nil, body_568307)

var backupsTrigger* = Call_BackupsTrigger_568292(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_568293, base: "", url: url_BackupsTrigger_568294,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_568308 = ref object of OpenApiRestCall_567651
proc url_ProtectedItemOperationResultsGet_568310(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemOperationResultsGet_568309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of any operation on the backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The OperationID used in this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568311 = path.getOrDefault("fabricName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "fabricName", valid_568311
  var valid_568312 = path.getOrDefault("protectedItemName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "protectedItemName", valid_568312
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("containerName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "containerName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568316 = path.getOrDefault("vaultName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "vaultName", valid_568316
  var valid_568317 = path.getOrDefault("operationId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "operationId", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_ProtectedItemOperationResultsGet_568308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the result of any operation on the backup item.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_ProtectedItemOperationResultsGet_568308;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationResultsGet
  ## Gets the result of any operation on the backup item.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The OperationID used in this GET operation.
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(path_568321, "fabricName", newJString(fabricName))
  add(path_568321, "protectedItemName", newJString(protectedItemName))
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "containerName", newJString(containerName))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  add(path_568321, "vaultName", newJString(vaultName))
  add(path_568321, "operationId", newJString(operationId))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_568308(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_568309, base: "",
    url: url_ProtectedItemOperationResultsGet_568310, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_568323 = ref object of OpenApiRestCall_567651
proc url_ProtectedItemOperationStatusesGet_568325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/operationsStatus/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemOperationStatusesGet_568324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The OperationID used in this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568326 = path.getOrDefault("fabricName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "fabricName", valid_568326
  var valid_568327 = path.getOrDefault("protectedItemName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "protectedItemName", valid_568327
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("containerName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "containerName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("vaultName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "vaultName", valid_568331
  var valid_568332 = path.getOrDefault("operationId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "operationId", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_ProtectedItemOperationStatusesGet_568323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ProtectedItemOperationStatusesGet_568323;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationStatusesGet
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The OperationID used in this GET operation.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "fabricName", newJString(fabricName))
  add(path_568336, "protectedItemName", newJString(protectedItemName))
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "containerName", newJString(containerName))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "vaultName", newJString(vaultName))
  add(path_568336, "operationId", newJString(operationId))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_568323(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_568324, base: "",
    url: url_ProtectedItemOperationStatusesGet_568325, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_568338 = ref object of OpenApiRestCall_567651
proc url_RecoveryPointsList_568340(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsList_568339(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568341 = path.getOrDefault("fabricName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "fabricName", valid_568341
  var valid_568342 = path.getOrDefault("protectedItemName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "protectedItemName", valid_568342
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("containerName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "containerName", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("vaultName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "vaultName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : startDate eq {yyyy-mm-dd hh:mm:ss PM} and endDate { yyyy-mm-dd hh:mm:ss PM}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  var valid_568348 = query.getOrDefault("$filter")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "$filter", valid_568348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_RecoveryPointsList_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_RecoveryPointsList_568338; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## recoveryPointsList
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : startDate eq {yyyy-mm-dd hh:mm:ss PM} and endDate { yyyy-mm-dd hh:mm:ss PM}.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(path_568351, "fabricName", newJString(fabricName))
  add(path_568351, "protectedItemName", newJString(protectedItemName))
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "containerName", newJString(containerName))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  add(path_568351, "vaultName", newJString(vaultName))
  add(query_568352, "$filter", newJString(Filter))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_568338(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_568339, base: "",
    url: url_RecoveryPointsList_568340, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_568353 = ref object of OpenApiRestCall_567651
proc url_RecoveryPointsGet_568355(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsGet_568354(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The RecoveryPointID associated with this GET operation.
  ##   containerName: JString (required)
  ##                : The container name associated with backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568356 = path.getOrDefault("fabricName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "fabricName", valid_568356
  var valid_568357 = path.getOrDefault("protectedItemName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "protectedItemName", valid_568357
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("recoveryPointId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "recoveryPointId", valid_568359
  var valid_568360 = path.getOrDefault("containerName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "containerName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  var valid_568362 = path.getOrDefault("vaultName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "vaultName", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_RecoveryPointsGet_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_RecoveryPointsGet_568353; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## recoveryPointsGet
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The RecoveryPointID associated with this GET operation.
  ##   containerName: string (required)
  ##                : The container name associated with backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "fabricName", newJString(fabricName))
  add(path_568366, "protectedItemName", newJString(protectedItemName))
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "recoveryPointId", newJString(recoveryPointId))
  add(path_568366, "containerName", newJString(containerName))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "vaultName", newJString(vaultName))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_568353(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_568354, base: "",
    url: url_RecoveryPointsGet_568355, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_568368 = ref object of OpenApiRestCall_567651
proc url_ItemLevelRecoveryConnectionsProvision_568370(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId"),
               (kind: ConstantSegment, value: "/provisionInstantItemRecovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ItemLevelRecoveryConnectionsProvision_568369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item whose files or folders are to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The recovery point ID for backup data. The iSCSI connection will be provisioned for this backup data.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568371 = path.getOrDefault("fabricName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "fabricName", valid_568371
  var valid_568372 = path.getOrDefault("protectedItemName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "protectedItemName", valid_568372
  var valid_568373 = path.getOrDefault("resourceGroupName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "resourceGroupName", valid_568373
  var valid_568374 = path.getOrDefault("recoveryPointId")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "recoveryPointId", valid_568374
  var valid_568375 = path.getOrDefault("containerName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "containerName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("vaultName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "vaultName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   resourceILRRequest: JObject (required)
  ##                     : The resource Item Level Recovery (ILR) request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_ItemLevelRecoveryConnectionsProvision_568368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_ItemLevelRecoveryConnectionsProvision_568368;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; resourceILRRequest: JsonNode; vaultName: string): Recallable =
  ## itemLevelRecoveryConnectionsProvision
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item whose files or folders are to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The recovery point ID for backup data. The iSCSI connection will be provisioned for this backup data.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceILRRequest: JObject (required)
  ##                     : The resource Item Level Recovery (ILR) request.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  var body_568384 = newJObject()
  add(path_568382, "fabricName", newJString(fabricName))
  add(path_568382, "protectedItemName", newJString(protectedItemName))
  add(path_568382, "resourceGroupName", newJString(resourceGroupName))
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "recoveryPointId", newJString(recoveryPointId))
  add(path_568382, "containerName", newJString(containerName))
  add(path_568382, "subscriptionId", newJString(subscriptionId))
  if resourceILRRequest != nil:
    body_568384 = resourceILRRequest
  add(path_568382, "vaultName", newJString(vaultName))
  result = call_568381.call(path_568382, query_568383, nil, nil, body_568384)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_568368(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_568369, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_568370, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_568385 = ref object of OpenApiRestCall_567651
proc url_RestoresTrigger_568387(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RestoresTrigger_568386(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: JString (required)
  ##                    : The backup item to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The recovery point ID for the backup data to be restored.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568388 = path.getOrDefault("fabricName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "fabricName", valid_568388
  var valid_568389 = path.getOrDefault("protectedItemName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "protectedItemName", valid_568389
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("recoveryPointId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "recoveryPointId", valid_568391
  var valid_568392 = path.getOrDefault("containerName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "containerName", valid_568392
  var valid_568393 = path.getOrDefault("subscriptionId")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "subscriptionId", valid_568393
  var valid_568394 = path.getOrDefault("vaultName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "vaultName", valid_568394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568395 = query.getOrDefault("api-version")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "api-version", valid_568395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceRestoreRequest: JObject (required)
  ##                         : The resource restore request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568397: Call_RestoresTrigger_568385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_RestoresTrigger_568385; fabricName: string;
          protectedItemName: string; resourceGroupName: string;
          resourceRestoreRequest: JsonNode; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## restoresTrigger
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: string (required)
  ##                    : The backup item to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   resourceRestoreRequest: JObject (required)
  ##                         : The resource restore request.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The recovery point ID for the backup data to be restored.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  var body_568401 = newJObject()
  add(path_568399, "fabricName", newJString(fabricName))
  add(path_568399, "protectedItemName", newJString(protectedItemName))
  add(path_568399, "resourceGroupName", newJString(resourceGroupName))
  if resourceRestoreRequest != nil:
    body_568401 = resourceRestoreRequest
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "recoveryPointId", newJString(recoveryPointId))
  add(path_568399, "containerName", newJString(containerName))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  add(path_568399, "vaultName", newJString(vaultName))
  result = call_568398.call(path_568399, query_568400, nil, nil, body_568401)

var restoresTrigger* = Call_RestoresTrigger_568385(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_568386, base: "", url: url_RestoresTrigger_568387,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_568402 = ref object of OpenApiRestCall_567651
proc url_ItemLevelRecoveryConnectionsRevoke_568404(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId"),
               (kind: ConstantSegment, value: "/revokeInstantItemRecovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ItemLevelRecoveryConnectionsRevoke_568403(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items. The value allowed is Azure.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup items whose files or folders will be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The string that identifies the recovery point. The iSCSI connection will be revoked for this protected data.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568405 = path.getOrDefault("fabricName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "fabricName", valid_568405
  var valid_568406 = path.getOrDefault("protectedItemName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "protectedItemName", valid_568406
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("recoveryPointId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "recoveryPointId", valid_568408
  var valid_568409 = path.getOrDefault("containerName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "containerName", valid_568409
  var valid_568410 = path.getOrDefault("subscriptionId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "subscriptionId", valid_568410
  var valid_568411 = path.getOrDefault("vaultName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "vaultName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_ItemLevelRecoveryConnectionsRevoke_568402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_ItemLevelRecoveryConnectionsRevoke_568402;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## itemLevelRecoveryConnectionsRevoke
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items. The value allowed is Azure.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup items whose files or folders will be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The string that identifies the recovery point. The iSCSI connection will be revoked for this protected data.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(path_568415, "fabricName", newJString(fabricName))
  add(path_568415, "protectedItemName", newJString(protectedItemName))
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "recoveryPointId", newJString(recoveryPointId))
  add(path_568415, "containerName", newJString(containerName))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  add(path_568415, "vaultName", newJString(vaultName))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_568402(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_568403, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_568404, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_568417 = ref object of OpenApiRestCall_567651
proc url_ProtectionContainersRefresh_568419(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/refreshContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersRefresh_568418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568420 = path.getOrDefault("fabricName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "fabricName", valid_568420
  var valid_568421 = path.getOrDefault("resourceGroupName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "resourceGroupName", valid_568421
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("vaultName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "vaultName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_ProtectionContainersRefresh_568417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_ProtectionContainersRefresh_568417;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersRefresh
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  add(path_568427, "fabricName", newJString(fabricName))
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  add(path_568427, "vaultName", newJString(vaultName))
  result = call_568426.call(path_568427, query_568428, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_568417(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_568418, base: "",
    url: url_ProtectionContainersRefresh_568419, schemes: {Scheme.Https})
type
  Call_JobsList_568429 = ref object of OpenApiRestCall_567651
proc url_JobsList_568431(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsList_568430(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("subscriptionId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "subscriptionId", valid_568433
  var valid_568434 = path.getOrDefault("vaultName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "vaultName", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   $filter: JString
  ##          : The following equation can be used to filter the list of jobs based on status, type, start date, and end date. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  var valid_568436 = query.getOrDefault("$skipToken")
  valid_568436 = validateParameter(valid_568436, JString, required = false,
                                 default = nil)
  if valid_568436 != nil:
    section.add "$skipToken", valid_568436
  var valid_568437 = query.getOrDefault("$filter")
  valid_568437 = validateParameter(valid_568437, JString, required = false,
                                 default = nil)
  if valid_568437 != nil:
    section.add "$filter", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_JobsList_568429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of jobs.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_JobsList_568429; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## jobsList
  ## Provides a pageable list of jobs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   Filter: string
  ##         : The following equation can be used to filter the list of jobs based on status, type, start date, and end date. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  add(path_568440, "vaultName", newJString(vaultName))
  add(query_568441, "$skipToken", newJString(SkipToken))
  add(query_568441, "$filter", newJString(Filter))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var jobsList* = Call_JobsList_568429(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs",
                                  validator: validate_JobsList_568430, base: "",
                                  url: url_JobsList_568431,
                                  schemes: {Scheme.Https})
type
  Call_ExportJobsOperationResultsGet_568442 = ref object of OpenApiRestCall_567651
proc url_ExportJobsOperationResultsGet_568444(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportJobsOperationResultsGet_568443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of the operation triggered by the ExportJob API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with the export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568445 = path.getOrDefault("resourceGroupName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "resourceGroupName", valid_568445
  var valid_568446 = path.getOrDefault("subscriptionId")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "subscriptionId", valid_568446
  var valid_568447 = path.getOrDefault("vaultName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "vaultName", valid_568447
  var valid_568448 = path.getOrDefault("operationId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "operationId", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_ExportJobsOperationResultsGet_568442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the result of the operation triggered by the ExportJob API.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_ExportJobsOperationResultsGet_568442;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## exportJobsOperationResultsGet
  ## Gets the result of the operation triggered by the ExportJob API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID associated with the export job.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  add(path_568452, "vaultName", newJString(vaultName))
  add(path_568452, "operationId", newJString(operationId))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var exportJobsOperationResultsGet* = Call_ExportJobsOperationResultsGet_568442(
    name: "exportJobsOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/operationResults/{operationId}",
    validator: validate_ExportJobsOperationResultsGet_568443, base: "",
    url: url_ExportJobsOperationResultsGet_568444, schemes: {Scheme.Https})
type
  Call_JobDetailsGet_568454 = ref object of OpenApiRestCall_567651
proc url_JobDetailsGet_568456(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDetailsGet_568455(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets extended information associated with the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   jobName: JString (required)
  ##          : Name of the job associated with this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  var valid_568459 = path.getOrDefault("jobName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "jobName", valid_568459
  var valid_568460 = path.getOrDefault("vaultName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "vaultName", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_JobDetailsGet_568454; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets extended information associated with the job.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_JobDetailsGet_568454; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          vaultName: string): Recallable =
  ## jobDetailsGet
  ## Gets extended information associated with the job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   jobName: string (required)
  ##          : Name of the job associated with this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(path_568464, "resourceGroupName", newJString(resourceGroupName))
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "subscriptionId", newJString(subscriptionId))
  add(path_568464, "jobName", newJString(jobName))
  add(path_568464, "vaultName", newJString(vaultName))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var jobDetailsGet* = Call_JobDetailsGet_568454(name: "jobDetailsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}",
    validator: validate_JobDetailsGet_568455, base: "", url: url_JobDetailsGet_568456,
    schemes: {Scheme.Https})
type
  Call_JobCancellationsTrigger_568466 = ref object of OpenApiRestCall_567651
proc url_JobCancellationsTrigger_568468(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCancellationsTrigger_568467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   jobName: JString (required)
  ##          : Name of the job to cancel.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("jobName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "jobName", valid_568471
  var valid_568472 = path.getOrDefault("vaultName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "vaultName", valid_568472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568473 = query.getOrDefault("api-version")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "api-version", valid_568473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_JobCancellationsTrigger_568466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_JobCancellationsTrigger_568466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string): Recallable =
  ## jobCancellationsTrigger
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   jobName: string (required)
  ##          : Name of the job to cancel.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  add(path_568476, "jobName", newJString(jobName))
  add(path_568476, "vaultName", newJString(vaultName))
  result = call_568475.call(path_568476, query_568477, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_568466(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_568467, base: "",
    url: url_JobCancellationsTrigger_568468, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_568478 = ref object of OpenApiRestCall_567651
proc url_JobOperationResultsGet_568480(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobOperationResultsGet_568479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   jobName: JString (required)
  ##          : Job name associated with this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : OperationID associated with this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568481 = path.getOrDefault("resourceGroupName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "resourceGroupName", valid_568481
  var valid_568482 = path.getOrDefault("subscriptionId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "subscriptionId", valid_568482
  var valid_568483 = path.getOrDefault("jobName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "jobName", valid_568483
  var valid_568484 = path.getOrDefault("vaultName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "vaultName", valid_568484
  var valid_568485 = path.getOrDefault("operationId")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "operationId", valid_568485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568487: Call_JobOperationResultsGet_568478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the result of the operation.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_JobOperationResultsGet_568478;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string; operationId: string): Recallable =
  ## jobOperationResultsGet
  ## Gets the result of the operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   jobName: string (required)
  ##          : Job name associated with this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : OperationID associated with this GET operation.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(path_568489, "jobName", newJString(jobName))
  add(path_568489, "vaultName", newJString(vaultName))
  add(path_568489, "operationId", newJString(operationId))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_568478(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_568479, base: "",
    url: url_JobOperationResultsGet_568480, schemes: {Scheme.Https})
type
  Call_JobsExport_568491 = ref object of OpenApiRestCall_567651
proc url_JobsExport_568493(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobsExport")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsExport_568492(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("subscriptionId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "subscriptionId", valid_568495
  var valid_568496 = path.getOrDefault("vaultName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "vaultName", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The OData filter options. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  var valid_568498 = query.getOrDefault("$filter")
  valid_568498 = validateParameter(valid_568498, JString, required = false,
                                 default = nil)
  if valid_568498 != nil:
    section.add "$filter", valid_568498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568499: Call_JobsExport_568491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ## 
  let valid = call_568499.validator(path, query, header, formData, body)
  let scheme = call_568499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568499.url(scheme.get, call_568499.host, call_568499.base,
                         call_568499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568499, url, valid)

proc call*(call_568500: Call_JobsExport_568491; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## jobsExport
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : The OData filter options. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  var path_568501 = newJObject()
  var query_568502 = newJObject()
  add(path_568501, "resourceGroupName", newJString(resourceGroupName))
  add(query_568502, "api-version", newJString(apiVersion))
  add(path_568501, "subscriptionId", newJString(subscriptionId))
  add(path_568501, "vaultName", newJString(vaultName))
  add(query_568502, "$filter", newJString(Filter))
  result = call_568500.call(path_568501, query_568502, nil, nil, nil)

var jobsExport* = Call_JobsExport_568491(name: "jobsExport",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobsExport",
                                      validator: validate_JobsExport_568492,
                                      base: "", url: url_JobsExport_568493,
                                      schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_568503 = ref object of OpenApiRestCall_567651
proc url_BackupOperationResultsGet_568505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupOperationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupOperationResultsGet_568504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID of the operation.
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
  var valid_568508 = path.getOrDefault("vaultName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "vaultName", valid_568508
  var valid_568509 = path.getOrDefault("operationId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "operationId", valid_568509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568510 = query.getOrDefault("api-version")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "api-version", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_BackupOperationResultsGet_568503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_BackupOperationResultsGet_568503;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationResultsGet
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID of the operation.
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  add(path_568513, "vaultName", newJString(vaultName))
  add(path_568513, "operationId", newJString(operationId))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_568503(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_568504, base: "",
    url: url_BackupOperationResultsGet_568505, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_568515 = ref object of OpenApiRestCall_567651
proc url_BackupOperationStatusesGet_568517(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupOperations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupOperationStatusesGet_568516(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID of the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("subscriptionId")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "subscriptionId", valid_568519
  var valid_568520 = path.getOrDefault("vaultName")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "vaultName", valid_568520
  var valid_568521 = path.getOrDefault("operationId")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "operationId", valid_568521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568522 = query.getOrDefault("api-version")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "api-version", valid_568522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_BackupOperationStatusesGet_568515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_BackupOperationStatusesGet_568515;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationStatusesGet
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID of the operation.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  add(path_568525, "vaultName", newJString(vaultName))
  add(path_568525, "operationId", newJString(operationId))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_568515(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_568516, base: "",
    url: url_BackupOperationStatusesGet_568517, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesList_568527 = ref object of OpenApiRestCall_567651
proc url_ProtectionPoliciesList_568529(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesList_568528(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("subscriptionId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "subscriptionId", valid_568531
  var valid_568532 = path.getOrDefault("vaultName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "vaultName", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation can be used to filter the list of backup policies. backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  var valid_568534 = query.getOrDefault("$filter")
  valid_568534 = validateParameter(valid_568534, JString, required = false,
                                 default = nil)
  if valid_568534 != nil:
    section.add "$filter", valid_568534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_ProtectionPoliciesList_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ## 
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_ProtectionPoliciesList_568527;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## protectionPoliciesList
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation can be used to filter the list of backup policies. backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  add(path_568537, "resourceGroupName", newJString(resourceGroupName))
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  add(path_568537, "vaultName", newJString(vaultName))
  add(query_568538, "$filter", newJString(Filter))
  result = call_568536.call(path_568537, query_568538, nil, nil, nil)

var protectionPoliciesList* = Call_ProtectionPoliciesList_568527(
    name: "protectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies",
    validator: validate_ProtectionPoliciesList_568528, base: "",
    url: url_ProtectionPoliciesList_568529, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_568551 = ref object of OpenApiRestCall_567651
proc url_ProtectionPoliciesCreateOrUpdate_568553(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesCreateOrUpdate_568552(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy to be created.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568554 = path.getOrDefault("resourceGroupName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "resourceGroupName", valid_568554
  var valid_568555 = path.getOrDefault("subscriptionId")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "subscriptionId", valid_568555
  var valid_568556 = path.getOrDefault("policyName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "policyName", valid_568556
  var valid_568557 = path.getOrDefault("vaultName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "vaultName", valid_568557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568558 = query.getOrDefault("api-version")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "api-version", valid_568558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceProtectionPolicy: JObject (required)
  ##                           : The resource backup policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568560: Call_ProtectionPoliciesCreateOrUpdate_568551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_568560.validator(path, query, header, formData, body)
  let scheme = call_568560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568560.url(scheme.get, call_568560.host, call_568560.base,
                         call_568560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568560, url, valid)

proc call*(call_568561: Call_ProtectionPoliciesCreateOrUpdate_568551;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; resourceProtectionPolicy: JsonNode): Recallable =
  ## protectionPoliciesCreateOrUpdate
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy to be created.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   resourceProtectionPolicy: JObject (required)
  ##                           : The resource backup policy.
  var path_568562 = newJObject()
  var query_568563 = newJObject()
  var body_568564 = newJObject()
  add(path_568562, "resourceGroupName", newJString(resourceGroupName))
  add(query_568563, "api-version", newJString(apiVersion))
  add(path_568562, "subscriptionId", newJString(subscriptionId))
  add(path_568562, "policyName", newJString(policyName))
  add(path_568562, "vaultName", newJString(vaultName))
  if resourceProtectionPolicy != nil:
    body_568564 = resourceProtectionPolicy
  result = call_568561.call(path_568562, query_568563, nil, nil, body_568564)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_568551(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_568552, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_568553, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_568539 = ref object of OpenApiRestCall_567651
proc url_ProtectionPoliciesGet_568541(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesGet_568540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("subscriptionId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "subscriptionId", valid_568543
  var valid_568544 = path.getOrDefault("policyName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "policyName", valid_568544
  var valid_568545 = path.getOrDefault("vaultName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "vaultName", valid_568545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568546 = query.getOrDefault("api-version")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "api-version", valid_568546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568547: Call_ProtectionPoliciesGet_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_568547.validator(path, query, header, formData, body)
  let scheme = call_568547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568547.url(scheme.get, call_568547.host, call_568547.base,
                         call_568547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568547, url, valid)

proc call*(call_568548: Call_ProtectionPoliciesGet_568539;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesGet
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568549 = newJObject()
  var query_568550 = newJObject()
  add(path_568549, "resourceGroupName", newJString(resourceGroupName))
  add(query_568550, "api-version", newJString(apiVersion))
  add(path_568549, "subscriptionId", newJString(subscriptionId))
  add(path_568549, "policyName", newJString(policyName))
  add(path_568549, "vaultName", newJString(vaultName))
  result = call_568548.call(path_568549, query_568550, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_568539(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_568540, base: "",
    url: url_ProtectionPoliciesGet_568541, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_568565 = ref object of OpenApiRestCall_567651
proc url_ProtectionPoliciesDelete_568567(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesDelete_568566(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The name of the backup policy to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568568 = path.getOrDefault("resourceGroupName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "resourceGroupName", valid_568568
  var valid_568569 = path.getOrDefault("subscriptionId")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "subscriptionId", valid_568569
  var valid_568570 = path.getOrDefault("policyName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "policyName", valid_568570
  var valid_568571 = path.getOrDefault("vaultName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "vaultName", valid_568571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568572 = query.getOrDefault("api-version")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "api-version", valid_568572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568573: Call_ProtectionPoliciesDelete_568565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_568573.validator(path, query, header, formData, body)
  let scheme = call_568573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568573.url(scheme.get, call_568573.host, call_568573.base,
                         call_568573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568573, url, valid)

proc call*(call_568574: Call_ProtectionPoliciesDelete_568565;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesDelete
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The name of the backup policy to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568575 = newJObject()
  var query_568576 = newJObject()
  add(path_568575, "resourceGroupName", newJString(resourceGroupName))
  add(query_568576, "api-version", newJString(apiVersion))
  add(path_568575, "subscriptionId", newJString(subscriptionId))
  add(path_568575, "policyName", newJString(policyName))
  add(path_568575, "vaultName", newJString(vaultName))
  result = call_568574.call(path_568575, query_568576, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_568565(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_568566, base: "",
    url: url_ProtectionPoliciesDelete_568567, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_568577 = ref object of OpenApiRestCall_567651
proc url_ProtectionPolicyOperationResultsGet_568579(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPolicyOperationResultsGet_568578(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the result of an operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568580 = path.getOrDefault("resourceGroupName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "resourceGroupName", valid_568580
  var valid_568581 = path.getOrDefault("subscriptionId")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "subscriptionId", valid_568581
  var valid_568582 = path.getOrDefault("policyName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "policyName", valid_568582
  var valid_568583 = path.getOrDefault("vaultName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "vaultName", valid_568583
  var valid_568584 = path.getOrDefault("operationId")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "operationId", valid_568584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568585 = query.getOrDefault("api-version")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "api-version", valid_568585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568586: Call_ProtectionPolicyOperationResultsGet_568577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_568586.validator(path, query, header, formData, body)
  let scheme = call_568586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568586.url(scheme.get, call_568586.host, call_568586.base,
                         call_568586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568586, url, valid)

proc call*(call_568587: Call_ProtectionPolicyOperationResultsGet_568577;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationResultsGet
  ## Provides the result of an operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID associated with this GET operation.
  var path_568588 = newJObject()
  var query_568589 = newJObject()
  add(path_568588, "resourceGroupName", newJString(resourceGroupName))
  add(query_568589, "api-version", newJString(apiVersion))
  add(path_568588, "subscriptionId", newJString(subscriptionId))
  add(path_568588, "policyName", newJString(policyName))
  add(path_568588, "vaultName", newJString(vaultName))
  add(path_568588, "operationId", newJString(operationId))
  result = call_568587.call(path_568588, query_568589, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_568577(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_568578, base: "",
    url: url_ProtectionPolicyOperationResultsGet_568579, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_568590 = ref object of OpenApiRestCall_567651
proc url_ProtectionPolicyOperationStatusesGet_568592(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPolicyOperationStatusesGet_568591(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568593 = path.getOrDefault("resourceGroupName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "resourceGroupName", valid_568593
  var valid_568594 = path.getOrDefault("subscriptionId")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "subscriptionId", valid_568594
  var valid_568595 = path.getOrDefault("policyName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "policyName", valid_568595
  var valid_568596 = path.getOrDefault("vaultName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "vaultName", valid_568596
  var valid_568597 = path.getOrDefault("operationId")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "operationId", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568599: Call_ProtectionPolicyOperationStatusesGet_568590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_568599.validator(path, query, header, formData, body)
  let scheme = call_568599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568599.url(scheme.get, call_568599.host, call_568599.base,
                         call_568599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568599, url, valid)

proc call*(call_568600: Call_ProtectionPolicyOperationStatusesGet_568590;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationStatusesGet
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID associated with this GET operation.
  var path_568601 = newJObject()
  var query_568602 = newJObject()
  add(path_568601, "resourceGroupName", newJString(resourceGroupName))
  add(query_568602, "api-version", newJString(apiVersion))
  add(path_568601, "subscriptionId", newJString(subscriptionId))
  add(path_568601, "policyName", newJString(policyName))
  add(path_568601, "vaultName", newJString(vaultName))
  add(path_568601, "operationId", newJString(operationId))
  result = call_568600.call(path_568601, query_568602, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_568590(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_568591, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_568592, schemes: {Scheme.Https})
type
  Call_ProtectableItemsList_568603 = ref object of OpenApiRestCall_567651
proc url_ProtectableItemsList_568605(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupProtectableItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectableItemsList_568604(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568606 = path.getOrDefault("resourceGroupName")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "resourceGroupName", valid_568606
  var valid_568607 = path.getOrDefault("subscriptionId")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "subscriptionId", valid_568607
  var valid_568608 = path.getOrDefault("vaultName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "vaultName", valid_568608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   $filter: JString
  ##          : Using the following query filters, you can sort a specific backup item based on: type of backup item, status, name of the item, and more.  providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and status eq { NotProtected , Protecting , Protected } and friendlyName {name} and skipToken eq {string which provides the next set of list} and topToken eq {int} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568609 = query.getOrDefault("api-version")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "api-version", valid_568609
  var valid_568610 = query.getOrDefault("$skipToken")
  valid_568610 = validateParameter(valid_568610, JString, required = false,
                                 default = nil)
  if valid_568610 != nil:
    section.add "$skipToken", valid_568610
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

proc call*(call_568612: Call_ProtectableItemsList_568603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ## 
  let valid = call_568612.validator(path, query, header, formData, body)
  let scheme = call_568612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568612.url(scheme.get, call_568612.host, call_568612.base,
                         call_568612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568612, url, valid)

proc call*(call_568613: Call_ProtectableItemsList_568603;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## protectableItemsList
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   Filter: string
  ##         : Using the following query filters, you can sort a specific backup item based on: type of backup item, status, name of the item, and more.  providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and status eq { NotProtected , Protecting , Protected } and friendlyName {name} and skipToken eq {string which provides the next set of list} and topToken eq {int} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_568614 = newJObject()
  var query_568615 = newJObject()
  add(path_568614, "resourceGroupName", newJString(resourceGroupName))
  add(query_568615, "api-version", newJString(apiVersion))
  add(path_568614, "subscriptionId", newJString(subscriptionId))
  add(path_568614, "vaultName", newJString(vaultName))
  add(query_568615, "$skipToken", newJString(SkipToken))
  add(query_568615, "$filter", newJString(Filter))
  result = call_568613.call(path_568614, query_568615, nil, nil, nil)

var protectableItemsList* = Call_ProtectableItemsList_568603(
    name: "protectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_ProtectableItemsList_568604, base: "",
    url: url_ProtectableItemsList_568605, schemes: {Scheme.Https})
type
  Call_ProtectedItemsList_568616 = ref object of OpenApiRestCall_567651
proc url_ProtectedItemsList_568618(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsList_568617(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568619 = path.getOrDefault("resourceGroupName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "resourceGroupName", valid_568619
  var valid_568620 = path.getOrDefault("subscriptionId")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "subscriptionId", valid_568620
  var valid_568621 = path.getOrDefault("vaultName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "vaultName", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             :  The Skip Token filter.
  ##   $filter: JString
  ##          :  itemType eq { VM , FileFolder , AzureSqlDb , SQLDB , Exchange , Sharepoint , DPMUnknown } and providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and policyName eq {policyName} and containerName eq {containername} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  var valid_568623 = query.getOrDefault("$skipToken")
  valid_568623 = validateParameter(valid_568623, JString, required = false,
                                 default = nil)
  if valid_568623 != nil:
    section.add "$skipToken", valid_568623
  var valid_568624 = query.getOrDefault("$filter")
  valid_568624 = validateParameter(valid_568624, JString, required = false,
                                 default = nil)
  if valid_568624 != nil:
    section.add "$filter", valid_568624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568625: Call_ProtectedItemsList_568616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ## 
  let valid = call_568625.validator(path, query, header, formData, body)
  let scheme = call_568625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568625.url(scheme.get, call_568625.host, call_568625.base,
                         call_568625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568625, url, valid)

proc call*(call_568626: Call_ProtectedItemsList_568616; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## protectedItemsList
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            :  The Skip Token filter.
  ##   Filter: string
  ##         :  itemType eq { VM , FileFolder , AzureSqlDb , SQLDB , Exchange , Sharepoint , DPMUnknown } and providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and policyName eq {policyName} and containerName eq {containername} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_568627 = newJObject()
  var query_568628 = newJObject()
  add(path_568627, "resourceGroupName", newJString(resourceGroupName))
  add(query_568628, "api-version", newJString(apiVersion))
  add(path_568627, "subscriptionId", newJString(subscriptionId))
  add(path_568627, "vaultName", newJString(vaultName))
  add(query_568628, "$skipToken", newJString(SkipToken))
  add(query_568628, "$filter", newJString(Filter))
  result = call_568626.call(path_568627, query_568628, nil, nil, nil)

var protectedItemsList* = Call_ProtectedItemsList_568616(
    name: "protectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectedItems",
    validator: validate_ProtectedItemsList_568617, base: "",
    url: url_ProtectedItemsList_568618, schemes: {Scheme.Https})
type
  Call_ProtectionContainersList_568629 = ref object of OpenApiRestCall_567651
proc url_ProtectionContainersList_568631(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupProtectionContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersList_568630(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers registered to the Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568632 = path.getOrDefault("resourceGroupName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "resourceGroupName", valid_568632
  var valid_568633 = path.getOrDefault("subscriptionId")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "subscriptionId", valid_568633
  var valid_568634 = path.getOrDefault("vaultName")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "vaultName", valid_568634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation is used to sort or filter the containers registered to the vault. providerType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql} and status eq {Unknown, NotRegistered, Registered, Registering} and friendlyName eq {containername} and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "api-version", valid_568635
  var valid_568636 = query.getOrDefault("$filter")
  valid_568636 = validateParameter(valid_568636, JString, required = false,
                                 default = nil)
  if valid_568636 != nil:
    section.add "$filter", valid_568636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568637: Call_ProtectionContainersList_568629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to the Recovery Services vault.
  ## 
  let valid = call_568637.validator(path, query, header, formData, body)
  let scheme = call_568637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568637.url(scheme.get, call_568637.host, call_568637.base,
                         call_568637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568637, url, valid)

proc call*(call_568638: Call_ProtectionContainersList_568629;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## protectionContainersList
  ## Lists the containers registered to the Recovery Services vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation is used to sort or filter the containers registered to the vault. providerType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql} and status eq {Unknown, NotRegistered, Registered, Registering} and friendlyName eq {containername} and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  var path_568639 = newJObject()
  var query_568640 = newJObject()
  add(path_568639, "resourceGroupName", newJString(resourceGroupName))
  add(query_568640, "api-version", newJString(apiVersion))
  add(path_568639, "subscriptionId", newJString(subscriptionId))
  add(path_568639, "vaultName", newJString(vaultName))
  add(query_568640, "$filter", newJString(Filter))
  result = call_568638.call(path_568639, query_568640, nil, nil, nil)

var protectionContainersList* = Call_ProtectionContainersList_568629(
    name: "protectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_ProtectionContainersList_568630, base: "",
    url: url_ProtectionContainersList_568631, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
