
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesBackupClient
## version: 2016-12-01
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
  macServiceName = "recoveryservicesbackup-backupManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesList_567872 = ref object of OpenApiRestCall_567650
proc url_BackupEnginesList_567874(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesList_567873(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568048 = path.getOrDefault("resourceGroupName")
  valid_568048 = validateParameter(valid_568048, JString, required = true,
                                 default = nil)
  if valid_568048 != nil:
    section.add "resourceGroupName", valid_568048
  var valid_568049 = path.getOrDefault("subscriptionId")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "subscriptionId", valid_568049
  var valid_568050 = path.getOrDefault("vaultName")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "vaultName", valid_568050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  var valid_568052 = query.getOrDefault("$skipToken")
  valid_568052 = validateParameter(valid_568052, JString, required = false,
                                 default = nil)
  if valid_568052 != nil:
    section.add "$skipToken", valid_568052
  var valid_568053 = query.getOrDefault("$filter")
  valid_568053 = validateParameter(valid_568053, JString, required = false,
                                 default = nil)
  if valid_568053 != nil:
    section.add "$filter", valid_568053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568076: Call_BackupEnginesList_567872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  let valid = call_568076.validator(path, query, header, formData, body)
  let scheme = call_568076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568076.url(scheme.get, call_568076.host, call_568076.base,
                         call_568076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568076, url, valid)

proc call*(call_568147: Call_BackupEnginesList_567872; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesList
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568148 = newJObject()
  var query_568150 = newJObject()
  add(path_568148, "resourceGroupName", newJString(resourceGroupName))
  add(query_568150, "api-version", newJString(apiVersion))
  add(path_568148, "subscriptionId", newJString(subscriptionId))
  add(path_568148, "vaultName", newJString(vaultName))
  add(query_568150, "$skipToken", newJString(SkipToken))
  add(query_568150, "$filter", newJString(Filter))
  result = call_568147.call(path_568148, query_568150, nil, nil, nil)

var backupEnginesList* = Call_BackupEnginesList_567872(name: "backupEnginesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesList_567873, base: "",
    url: url_BackupEnginesList_567874, schemes: {Scheme.Https})
type
  Call_BackupEnginesGet_568189 = ref object of OpenApiRestCall_567650
proc url_BackupEnginesGet_568191(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "backupEngineName" in path,
        "`backupEngineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupEngines/"),
               (kind: VariableSegment, value: "backupEngineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupEnginesGet_568190(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   backupEngineName: JString (required)
  ##                   : Name of the backup management server.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568192 = path.getOrDefault("resourceGroupName")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "resourceGroupName", valid_568192
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  var valid_568194 = path.getOrDefault("vaultName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "vaultName", valid_568194
  var valid_568195 = path.getOrDefault("backupEngineName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "backupEngineName", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  var valid_568197 = query.getOrDefault("$skipToken")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = nil)
  if valid_568197 != nil:
    section.add "$skipToken", valid_568197
  var valid_568198 = query.getOrDefault("$filter")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = nil)
  if valid_568198 != nil:
    section.add "$filter", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_BackupEnginesGet_568189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_BackupEnginesGet_568189; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          backupEngineName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesGet
  ## Returns backup management server registered to Recovery Services Vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   backupEngineName: string (required)
  ##                   : Name of the backup management server.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(path_568201, "vaultName", newJString(vaultName))
  add(path_568201, "backupEngineName", newJString(backupEngineName))
  add(query_568202, "$skipToken", newJString(SkipToken))
  add(query_568202, "$filter", newJString(Filter))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_568189(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines/{backupEngineName}",
    validator: validate_BackupEnginesGet_568190, base: "",
    url: url_BackupEnginesGet_568191, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_568203 = ref object of OpenApiRestCall_567650
proc url_ProtectionContainerRefreshOperationResultsGet_568205(protocol: Scheme;
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

proc validate_ProtectionContainerRefreshOperationResultsGet_568204(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID associated with the operation whose result needs to be fetched.
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
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("vaultName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "vaultName", valid_568209
  var valid_568210 = path.getOrDefault("operationId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "operationId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568212: Call_ProtectionContainerRefreshOperationResultsGet_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_ProtectionContainerRefreshOperationResultsGet_568203;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string; operationId: string): Recallable =
  ## protectionContainerRefreshOperationResultsGet
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID associated with the operation whose result needs to be fetched.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "fabricName", newJString(fabricName))
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(path_568214, "vaultName", newJString(vaultName))
  add(path_568214, "operationId", newJString(operationId))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_568203(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_568204,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_568205,
    schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_568216 = ref object of OpenApiRestCall_567650
proc url_ProtectionContainersGet_568218(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionContainersGet_568217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the fabric where the container belongs.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container whose details need to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_ProtectionContainersGet_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_ProtectionContainersGet_568216; fabricName: string;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersGet
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ##   fabricName: string (required)
  ##             : Name of the fabric where the container belongs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Name of the container whose details need to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "fabricName", newJString(fabricName))
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "containerName", newJString(containerName))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  add(path_568227, "vaultName", newJString(vaultName))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_568216(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_568217, base: "",
    url: url_ProtectionContainersGet_568218, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_568229 = ref object of OpenApiRestCall_567650
proc url_ProtectionContainerOperationResultsGet_568231(protocol: Scheme;
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

proc validate_ProtectionContainerOperationResultsGet_568230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation on the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name whose information should be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568232 = path.getOrDefault("fabricName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "fabricName", valid_568232
  var valid_568233 = path.getOrDefault("resourceGroupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceGroupName", valid_568233
  var valid_568234 = path.getOrDefault("containerName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "containerName", valid_568234
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  var valid_568236 = path.getOrDefault("vaultName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "vaultName", valid_568236
  var valid_568237 = path.getOrDefault("operationId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "operationId", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ProtectionContainerOperationResultsGet_568229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the container.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ProtectionContainerOperationResultsGet_568229;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          operationId: string): Recallable =
  ## protectionContainerOperationResultsGet
  ## Fetches the result of any operation on the container.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name whose information should be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "fabricName", newJString(fabricName))
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "containerName", newJString(containerName))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "vaultName", newJString(vaultName))
  add(path_568241, "operationId", newJString(operationId))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_568229(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_568230, base: "",
    url: url_ProtectionContainerOperationResultsGet_568231,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_568258 = ref object of OpenApiRestCall_567650
proc url_ProtectedItemsCreateOrUpdate_568260(protocol: Scheme; host: string;
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

proc validate_ProtectedItemsCreateOrUpdate_568259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Item name to be backed up.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568278 = path.getOrDefault("fabricName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "fabricName", valid_568278
  var valid_568279 = path.getOrDefault("protectedItemName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "protectedItemName", valid_568279
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("containerName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "containerName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("vaultName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "vaultName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backed up item
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_ProtectedItemsCreateOrUpdate_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_ProtectedItemsCreateOrUpdate_568258;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## protectedItemsCreateOrUpdate
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Item name to be backed up.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backed up item
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  var body_568290 = newJObject()
  add(path_568288, "fabricName", newJString(fabricName))
  add(path_568288, "protectedItemName", newJString(protectedItemName))
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "containerName", newJString(containerName))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  add(path_568288, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568290 = parameters
  result = call_568287.call(path_568288, query_568289, nil, nil, body_568290)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_568258(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_568259, base: "",
    url: url_ProtectedItemsCreateOrUpdate_568260, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_568243 = ref object of OpenApiRestCall_567650
proc url_ProtectedItemsGet_568245(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsGet_568244(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose details are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568246 = path.getOrDefault("fabricName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "fabricName", valid_568246
  var valid_568247 = path.getOrDefault("protectedItemName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "protectedItemName", valid_568247
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("containerName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "containerName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  var valid_568251 = path.getOrDefault("vaultName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "vaultName", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  var valid_568253 = query.getOrDefault("$filter")
  valid_568253 = validateParameter(valid_568253, JString, required = false,
                                 default = nil)
  if valid_568253 != nil:
    section.add "$filter", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_ProtectedItemsGet_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_ProtectedItemsGet_568243; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## protectedItemsGet
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose details are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "fabricName", newJString(fabricName))
  add(path_568256, "protectedItemName", newJString(protectedItemName))
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "containerName", newJString(containerName))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(path_568256, "vaultName", newJString(vaultName))
  add(query_568257, "$filter", newJString(Filter))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_568243(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_568244, base: "",
    url: url_ProtectedItemsGet_568245, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_568291 = ref object of OpenApiRestCall_567650
proc url_ProtectedItemsDelete_568293(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsDelete_568292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the request, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item to be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568294 = path.getOrDefault("fabricName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "fabricName", valid_568294
  var valid_568295 = path.getOrDefault("protectedItemName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "protectedItemName", valid_568295
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("containerName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "containerName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  var valid_568299 = path.getOrDefault("vaultName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "vaultName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_ProtectedItemsDelete_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the request, call the GetItemOperationResult API.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_ProtectedItemsDelete_568291; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string): Recallable =
  ## protectedItemsDelete
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the request, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item to be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(path_568303, "fabricName", newJString(fabricName))
  add(path_568303, "protectedItemName", newJString(protectedItemName))
  add(path_568303, "resourceGroupName", newJString(resourceGroupName))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "containerName", newJString(containerName))
  add(path_568303, "subscriptionId", newJString(subscriptionId))
  add(path_568303, "vaultName", newJString(vaultName))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_568291(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_568292, base: "",
    url: url_ProtectedItemsDelete_568293, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_568305 = ref object of OpenApiRestCall_567650
proc url_BackupsTrigger_568307(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsTrigger_568306(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item for which backup needs to be triggered.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568308 = path.getOrDefault("fabricName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "fabricName", valid_568308
  var valid_568309 = path.getOrDefault("protectedItemName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "protectedItemName", valid_568309
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("containerName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "containerName", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  var valid_568313 = path.getOrDefault("vaultName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "vaultName", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backup request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_BackupsTrigger_568305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_BackupsTrigger_568305; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          parameters: JsonNode): Recallable =
  ## backupsTrigger
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item for which backup needs to be triggered.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backup request
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  var body_568320 = newJObject()
  add(path_568318, "fabricName", newJString(fabricName))
  add(path_568318, "protectedItemName", newJString(protectedItemName))
  add(path_568318, "resourceGroupName", newJString(resourceGroupName))
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "containerName", newJString(containerName))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(path_568318, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568320 = parameters
  result = call_568317.call(path_568318, query_568319, nil, nil, body_568320)

var backupsTrigger* = Call_BackupsTrigger_568305(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_568306, base: "", url: url_BackupsTrigger_568307,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_568321 = ref object of OpenApiRestCall_567650
proc url_ProtectedItemOperationResultsGet_568323(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationResultsGet_568322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation on the backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation whose result needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568324 = path.getOrDefault("fabricName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "fabricName", valid_568324
  var valid_568325 = path.getOrDefault("protectedItemName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "protectedItemName", valid_568325
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("containerName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "containerName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("vaultName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "vaultName", valid_568329
  var valid_568330 = path.getOrDefault("operationId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "operationId", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568332: Call_ProtectedItemOperationResultsGet_568321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the backup item.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_ProtectedItemOperationResultsGet_568321;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationResultsGet
  ## Fetches the result of any operation on the backup item.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation whose result needs to be fetched.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(path_568334, "fabricName", newJString(fabricName))
  add(path_568334, "protectedItemName", newJString(protectedItemName))
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "containerName", newJString(containerName))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "vaultName", newJString(vaultName))
  add(path_568334, "operationId", newJString(operationId))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_568321(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_568322, base: "",
    url: url_ProtectedItemOperationResultsGet_568323, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_568336 = ref object of OpenApiRestCall_567650
proc url_ProtectedItemOperationStatusesGet_568338(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationStatusesGet_568337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID represents the operation whose status needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568339 = path.getOrDefault("fabricName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "fabricName", valid_568339
  var valid_568340 = path.getOrDefault("protectedItemName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "protectedItemName", valid_568340
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("containerName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "containerName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("vaultName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "vaultName", valid_568344
  var valid_568345 = path.getOrDefault("operationId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "operationId", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_ProtectedItemOperationStatusesGet_568336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_ProtectedItemOperationStatusesGet_568336;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationStatusesGet
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID represents the operation whose status needs to be fetched.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "fabricName", newJString(fabricName))
  add(path_568349, "protectedItemName", newJString(protectedItemName))
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "containerName", newJString(containerName))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "vaultName", newJString(vaultName))
  add(path_568349, "operationId", newJString(operationId))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_568336(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_568337, base: "",
    url: url_ProtectedItemOperationStatusesGet_568338, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_568351 = ref object of OpenApiRestCall_567650
proc url_RecoveryPointsList_568353(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsList_568352(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the backup copies for the backed up item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item whose backup copies are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568354 = path.getOrDefault("fabricName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "fabricName", valid_568354
  var valid_568355 = path.getOrDefault("protectedItemName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "protectedItemName", valid_568355
  var valid_568356 = path.getOrDefault("resourceGroupName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "resourceGroupName", valid_568356
  var valid_568357 = path.getOrDefault("containerName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "containerName", valid_568357
  var valid_568358 = path.getOrDefault("subscriptionId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "subscriptionId", valid_568358
  var valid_568359 = path.getOrDefault("vaultName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "vaultName", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568360 = query.getOrDefault("api-version")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "api-version", valid_568360
  var valid_568361 = query.getOrDefault("$filter")
  valid_568361 = validateParameter(valid_568361, JString, required = false,
                                 default = nil)
  if valid_568361 != nil:
    section.add "$filter", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_RecoveryPointsList_568351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup copies for the backed up item.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_RecoveryPointsList_568351; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## recoveryPointsList
  ## Lists the backup copies for the backed up item.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item whose backup copies are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "fabricName", newJString(fabricName))
  add(path_568364, "protectedItemName", newJString(protectedItemName))
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "containerName", newJString(containerName))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "vaultName", newJString(vaultName))
  add(query_568365, "$filter", newJString(Filter))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_568351(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_568352, base: "",
    url: url_RecoveryPointsList_568353, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_568366 = ref object of OpenApiRestCall_567650
proc url_RecoveryPointsGet_568368(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_568367(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation. To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose backup data needs to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : RecoveryPointID represents the backed up data to be fetched.
  ##   containerName: JString (required)
  ##                : Container name associated with backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568369 = path.getOrDefault("fabricName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "fabricName", valid_568369
  var valid_568370 = path.getOrDefault("protectedItemName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "protectedItemName", valid_568370
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("recoveryPointId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "recoveryPointId", valid_568372
  var valid_568373 = path.getOrDefault("containerName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "containerName", valid_568373
  var valid_568374 = path.getOrDefault("subscriptionId")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "subscriptionId", valid_568374
  var valid_568375 = path.getOrDefault("vaultName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "vaultName", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_RecoveryPointsGet_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation. To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_RecoveryPointsGet_568366; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## recoveryPointsGet
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation. To know the status of the operation, call the GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose backup data needs to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : RecoveryPointID represents the backed up data to be fetched.
  ##   containerName: string (required)
  ##                : Container name associated with backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "fabricName", newJString(fabricName))
  add(path_568379, "protectedItemName", newJString(protectedItemName))
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "recoveryPointId", newJString(recoveryPointId))
  add(path_568379, "containerName", newJString(containerName))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(path_568379, "vaultName", newJString(vaultName))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_568366(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_568367, base: "",
    url: url_RecoveryPointsGet_568368, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_568381 = ref object of OpenApiRestCall_567650
proc url_ItemLevelRecoveryConnectionsProvision_568383(protocol: Scheme;
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

proc validate_ItemLevelRecoveryConnectionsProvision_568382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of provisioning, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be provisioned for this backed up data.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568384 = path.getOrDefault("fabricName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "fabricName", valid_568384
  var valid_568385 = path.getOrDefault("protectedItemName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "protectedItemName", valid_568385
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("recoveryPointId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "recoveryPointId", valid_568387
  var valid_568388 = path.getOrDefault("containerName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "containerName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  var valid_568390 = path.getOrDefault("vaultName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "vaultName", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource ILR request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_ItemLevelRecoveryConnectionsProvision_568381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of provisioning, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_ItemLevelRecoveryConnectionsProvision_568381;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; vaultName: string; parameters: JsonNode): Recallable =
  ## itemLevelRecoveryConnectionsProvision
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of provisioning, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be provisioned for this backed up data.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource ILR request
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  var body_568397 = newJObject()
  add(path_568395, "fabricName", newJString(fabricName))
  add(path_568395, "protectedItemName", newJString(protectedItemName))
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "recoveryPointId", newJString(recoveryPointId))
  add(path_568395, "containerName", newJString(containerName))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  add(path_568395, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568397 = parameters
  result = call_568394.call(path_568395, query_568396, nil, nil, body_568397)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_568381(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_568382, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_568383, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_568398 = ref object of OpenApiRestCall_567650
proc url_RestoresTrigger_568400(protocol: Scheme; host: string; base: string;
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

proc validate_RestoresTrigger_568399(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents the backed up data to be restored.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568401 = path.getOrDefault("fabricName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "fabricName", valid_568401
  var valid_568402 = path.getOrDefault("protectedItemName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "protectedItemName", valid_568402
  var valid_568403 = path.getOrDefault("resourceGroupName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "resourceGroupName", valid_568403
  var valid_568404 = path.getOrDefault("recoveryPointId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "recoveryPointId", valid_568404
  var valid_568405 = path.getOrDefault("containerName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "containerName", valid_568405
  var valid_568406 = path.getOrDefault("subscriptionId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "subscriptionId", valid_568406
  var valid_568407 = path.getOrDefault("vaultName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "vaultName", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource restore request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568410: Call_RestoresTrigger_568398; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  let valid = call_568410.validator(path, query, header, formData, body)
  let scheme = call_568410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568410.url(scheme.get, call_568410.host, call_568410.base,
                         call_568410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568410, url, valid)

proc call*(call_568411: Call_RestoresTrigger_568398; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## restoresTrigger
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents the backed up data to be restored.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource restore request
  var path_568412 = newJObject()
  var query_568413 = newJObject()
  var body_568414 = newJObject()
  add(path_568412, "fabricName", newJString(fabricName))
  add(path_568412, "protectedItemName", newJString(protectedItemName))
  add(path_568412, "resourceGroupName", newJString(resourceGroupName))
  add(query_568413, "api-version", newJString(apiVersion))
  add(path_568412, "recoveryPointId", newJString(recoveryPointId))
  add(path_568412, "containerName", newJString(containerName))
  add(path_568412, "subscriptionId", newJString(subscriptionId))
  add(path_568412, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568414 = parameters
  result = call_568411.call(path_568412, query_568413, nil, nil, body_568414)

var restoresTrigger* = Call_RestoresTrigger_568398(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_568399, base: "", url: url_RestoresTrigger_568400,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_568415 = ref object of OpenApiRestCall_567650
proc url_ItemLevelRecoveryConnectionsRevoke_568417(protocol: Scheme; host: string;
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

proc validate_ItemLevelRecoveryConnectionsRevoke_568416(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be revoked for this backed up data.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568418 = path.getOrDefault("fabricName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "fabricName", valid_568418
  var valid_568419 = path.getOrDefault("protectedItemName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "protectedItemName", valid_568419
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("recoveryPointId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "recoveryPointId", valid_568421
  var valid_568422 = path.getOrDefault("containerName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "containerName", valid_568422
  var valid_568423 = path.getOrDefault("subscriptionId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "subscriptionId", valid_568423
  var valid_568424 = path.getOrDefault("vaultName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "vaultName", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568426: Call_ItemLevelRecoveryConnectionsRevoke_568415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_ItemLevelRecoveryConnectionsRevoke_568415;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## itemLevelRecoveryConnectionsRevoke
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be revoked for this backed up data.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  add(path_568428, "fabricName", newJString(fabricName))
  add(path_568428, "protectedItemName", newJString(protectedItemName))
  add(path_568428, "resourceGroupName", newJString(resourceGroupName))
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "recoveryPointId", newJString(recoveryPointId))
  add(path_568428, "containerName", newJString(containerName))
  add(path_568428, "subscriptionId", newJString(subscriptionId))
  add(path_568428, "vaultName", newJString(vaultName))
  result = call_568427.call(path_568428, query_568429, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_568415(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_568416, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_568417, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_568430 = ref object of OpenApiRestCall_567650
proc url_ProtectionContainersRefresh_568432(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRefresh_568431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568433 = path.getOrDefault("fabricName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "fabricName", valid_568433
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("vaultName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "vaultName", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_ProtectionContainersRefresh_568430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_ProtectionContainersRefresh_568430;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersRefresh
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(path_568440, "fabricName", newJString(fabricName))
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  add(path_568440, "vaultName", newJString(vaultName))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_568430(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_568431, base: "",
    url: url_ProtectionContainersRefresh_568432, schemes: {Scheme.Https})
type
  Call_ExportJobsOperationResultsGet_568442 = ref object of OpenApiRestCall_567650
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
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the export job.
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
  ##              : Client Api Version.
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
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
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
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the export job.
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
  Call_JobCancellationsTrigger_568454 = ref object of OpenApiRestCall_567650
proc url_JobCancellationsTrigger_568456(protocol: Scheme; host: string; base: string;
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

proc validate_JobCancellationsTrigger_568455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call GetCancelOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Name of the job to cancel.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  ##              : Client Api Version.
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

proc call*(call_568462: Call_JobCancellationsTrigger_568454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call GetCancelOperationResult API.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_JobCancellationsTrigger_568454;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string): Recallable =
  ## jobCancellationsTrigger
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call GetCancelOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Name of the job to cancel.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(path_568464, "resourceGroupName", newJString(resourceGroupName))
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "subscriptionId", newJString(subscriptionId))
  add(path_568464, "jobName", newJString(jobName))
  add(path_568464, "vaultName", newJString(vaultName))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_568454(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_568455, base: "",
    url: url_JobCancellationsTrigger_568456, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_568466 = ref object of OpenApiRestCall_567650
proc url_JobOperationResultsGet_568468(protocol: Scheme; host: string; base: string;
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

proc validate_JobOperationResultsGet_568467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation.
  ##             the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job name whose operation result has to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation whose result has to be fetched.
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
  var valid_568473 = path.getOrDefault("operationId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "operationId", valid_568473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568474 = query.getOrDefault("api-version")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "api-version", valid_568474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_JobOperationResultsGet_568466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the result of any operation.
  ##             the operation.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_JobOperationResultsGet_568466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string; operationId: string): Recallable =
  ## jobOperationResultsGet
  ## Fetches the result of any operation.
  ##             the operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job name whose operation result has to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation whose result has to be fetched.
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(path_568477, "resourceGroupName", newJString(resourceGroupName))
  add(query_568478, "api-version", newJString(apiVersion))
  add(path_568477, "subscriptionId", newJString(subscriptionId))
  add(path_568477, "jobName", newJString(jobName))
  add(path_568477, "vaultName", newJString(vaultName))
  add(path_568477, "operationId", newJString(operationId))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_568466(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_568467, base: "",
    url: url_JobOperationResultsGet_568468, schemes: {Scheme.Https})
type
  Call_JobsExport_568479 = ref object of OpenApiRestCall_567650
proc url_JobsExport_568481(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsExport_568480(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Triggers export of jobs specified by filters and returns an OperationID to track.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  var valid_568484 = path.getOrDefault("vaultName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "vaultName", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  var valid_568486 = query.getOrDefault("$filter")
  valid_568486 = validateParameter(valid_568486, JString, required = false,
                                 default = nil)
  if valid_568486 != nil:
    section.add "$filter", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_JobsExport_568479; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers export of jobs specified by filters and returns an OperationID to track.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_JobsExport_568479; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## jobsExport
  ## Triggers export of jobs specified by filters and returns an OperationID to track.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(path_568489, "vaultName", newJString(vaultName))
  add(query_568490, "$filter", newJString(Filter))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var jobsExport* = Call_JobsExport_568479(name: "jobsExport",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobsExport",
                                      validator: validate_JobsExport_568480,
                                      base: "", url: url_JobsExport_568481,
                                      schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_568491 = ref object of OpenApiRestCall_567650
proc url_BackupOperationResultsGet_568493(protocol: Scheme; host: string;
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

proc validate_BackupOperationResultsGet_568492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation.
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
  var valid_568497 = path.getOrDefault("operationId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "operationId", valid_568497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568498 = query.getOrDefault("api-version")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "api-version", valid_568498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568499: Call_BackupOperationResultsGet_568491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  let valid = call_568499.validator(path, query, header, formData, body)
  let scheme = call_568499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568499.url(scheme.get, call_568499.host, call_568499.base,
                         call_568499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568499, url, valid)

proc call*(call_568500: Call_BackupOperationResultsGet_568491;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationResultsGet
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation.
  var path_568501 = newJObject()
  var query_568502 = newJObject()
  add(path_568501, "resourceGroupName", newJString(resourceGroupName))
  add(query_568502, "api-version", newJString(apiVersion))
  add(path_568501, "subscriptionId", newJString(subscriptionId))
  add(path_568501, "vaultName", newJString(vaultName))
  add(path_568501, "operationId", newJString(operationId))
  result = call_568500.call(path_568501, query_568502, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_568491(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_568492, base: "",
    url: url_BackupOperationResultsGet_568493, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_568503 = ref object of OpenApiRestCall_567650
proc url_BackupOperationStatusesGet_568505(protocol: Scheme; host: string;
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

proc validate_BackupOperationStatusesGet_568504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation.
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
  ##              : Client Api Version.
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

proc call*(call_568511: Call_BackupOperationStatusesGet_568503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_BackupOperationStatusesGet_568503;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationStatusesGet
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation.
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  add(path_568513, "vaultName", newJString(vaultName))
  add(path_568513, "operationId", newJString(operationId))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_568503(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_568504, base: "",
    url: url_BackupOperationStatusesGet_568505, schemes: {Scheme.Https})
type
  Call_BackupPoliciesList_568515 = ref object of OpenApiRestCall_567650
proc url_BackupPoliciesList_568517(protocol: Scheme; host: string; base: string;
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

proc validate_BackupPoliciesList_568516(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch scoped results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
  var valid_568522 = query.getOrDefault("$filter")
  valid_568522 = validateParameter(valid_568522, JString, required = false,
                                 default = nil)
  if valid_568522 != nil:
    section.add "$filter", valid_568522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_BackupPoliciesList_568515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch scoped results.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_BackupPoliciesList_568515; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## backupPoliciesList
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch scoped results.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  add(path_568525, "vaultName", newJString(vaultName))
  add(query_568526, "$filter", newJString(Filter))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var backupPoliciesList* = Call_BackupPoliciesList_568515(
    name: "backupPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies",
    validator: validate_BackupPoliciesList_568516, base: "",
    url: url_BackupPoliciesList_568517, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_568539 = ref object of OpenApiRestCall_567650
proc url_ProtectionPoliciesCreateOrUpdate_568541(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesCreateOrUpdate_568540(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy to be created.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backup policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568548: Call_ProtectionPoliciesCreateOrUpdate_568539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_ProtectionPoliciesCreateOrUpdate_568539;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; parameters: JsonNode): Recallable =
  ## protectionPoliciesCreateOrUpdate
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy to be created.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backup policy
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  var body_568552 = newJObject()
  add(path_568550, "resourceGroupName", newJString(resourceGroupName))
  add(query_568551, "api-version", newJString(apiVersion))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  add(path_568550, "policyName", newJString(policyName))
  add(path_568550, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568552 = parameters
  result = call_568549.call(path_568550, query_568551, nil, nil, body_568552)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_568539(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_568540, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_568541, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_568527 = ref object of OpenApiRestCall_567650
proc url_ProtectionPoliciesGet_568529(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionPoliciesGet_568528(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy information to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  var valid_568532 = path.getOrDefault("policyName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "policyName", valid_568532
  var valid_568533 = path.getOrDefault("vaultName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "vaultName", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_ProtectionPoliciesGet_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_ProtectionPoliciesGet_568527;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesGet
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy information to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  add(path_568537, "resourceGroupName", newJString(resourceGroupName))
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  add(path_568537, "policyName", newJString(policyName))
  add(path_568537, "vaultName", newJString(vaultName))
  result = call_568536.call(path_568537, query_568538, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_568527(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_568528, base: "",
    url: url_ProtectionPoliciesGet_568529, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_568553 = ref object of OpenApiRestCall_567650
proc url_ProtectionPoliciesDelete_568555(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesDelete_568554(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568556 = path.getOrDefault("resourceGroupName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "resourceGroupName", valid_568556
  var valid_568557 = path.getOrDefault("subscriptionId")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "subscriptionId", valid_568557
  var valid_568558 = path.getOrDefault("policyName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "policyName", valid_568558
  var valid_568559 = path.getOrDefault("vaultName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "vaultName", valid_568559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568560 = query.getOrDefault("api-version")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "api-version", valid_568560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568561: Call_ProtectionPoliciesDelete_568553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_568561.validator(path, query, header, formData, body)
  let scheme = call_568561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568561.url(scheme.get, call_568561.host, call_568561.base,
                         call_568561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568561, url, valid)

proc call*(call_568562: Call_ProtectionPoliciesDelete_568553;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesDelete
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568563 = newJObject()
  var query_568564 = newJObject()
  add(path_568563, "resourceGroupName", newJString(resourceGroupName))
  add(query_568564, "api-version", newJString(apiVersion))
  add(path_568563, "subscriptionId", newJString(subscriptionId))
  add(path_568563, "policyName", newJString(policyName))
  add(path_568563, "vaultName", newJString(vaultName))
  result = call_568562.call(path_568563, query_568564, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_568553(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_568554, base: "",
    url: url_ProtectionPoliciesDelete_568555, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_568565 = ref object of OpenApiRestCall_567650
proc url_ProtectionPolicyOperationResultsGet_568567(protocol: Scheme; host: string;
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

proc validate_ProtectionPolicyOperationResultsGet_568566(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the result of an operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy name whose operation's result needs to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
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
  var valid_568572 = path.getOrDefault("operationId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "operationId", valid_568572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568573 = query.getOrDefault("api-version")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "api-version", valid_568573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568574: Call_ProtectionPolicyOperationResultsGet_568565;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_568574.validator(path, query, header, formData, body)
  let scheme = call_568574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568574.url(scheme.get, call_568574.host, call_568574.base,
                         call_568574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568574, url, valid)

proc call*(call_568575: Call_ProtectionPolicyOperationResultsGet_568565;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationResultsGet
  ## Provides the result of an operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy name whose operation's result needs to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  var path_568576 = newJObject()
  var query_568577 = newJObject()
  add(path_568576, "resourceGroupName", newJString(resourceGroupName))
  add(query_568577, "api-version", newJString(apiVersion))
  add(path_568576, "subscriptionId", newJString(subscriptionId))
  add(path_568576, "policyName", newJString(policyName))
  add(path_568576, "vaultName", newJString(vaultName))
  add(path_568576, "operationId", newJString(operationId))
  result = call_568575.call(path_568576, query_568577, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_568565(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_568566, base: "",
    url: url_ProtectionPolicyOperationResultsGet_568567, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_568578 = ref object of OpenApiRestCall_567650
proc url_ProtectionPolicyOperationStatusesGet_568580(protocol: Scheme;
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

proc validate_ProtectionPolicyOperationStatusesGet_568579(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy name whose operation's status needs to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents an operation whose status needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568581 = path.getOrDefault("resourceGroupName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "resourceGroupName", valid_568581
  var valid_568582 = path.getOrDefault("subscriptionId")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "subscriptionId", valid_568582
  var valid_568583 = path.getOrDefault("policyName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "policyName", valid_568583
  var valid_568584 = path.getOrDefault("vaultName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "vaultName", valid_568584
  var valid_568585 = path.getOrDefault("operationId")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "operationId", valid_568585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568587: Call_ProtectionPolicyOperationStatusesGet_568578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with operation.
  ## 
  let valid = call_568587.validator(path, query, header, formData, body)
  let scheme = call_568587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568587.url(scheme.get, call_568587.host, call_568587.base,
                         call_568587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568587, url, valid)

proc call*(call_568588: Call_ProtectionPolicyOperationStatusesGet_568578;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationStatusesGet
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy name whose operation's status needs to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID which represents an operation whose status needs to be fetched.
  var path_568589 = newJObject()
  var query_568590 = newJObject()
  add(path_568589, "resourceGroupName", newJString(resourceGroupName))
  add(query_568590, "api-version", newJString(apiVersion))
  add(path_568589, "subscriptionId", newJString(subscriptionId))
  add(path_568589, "policyName", newJString(policyName))
  add(path_568589, "vaultName", newJString(vaultName))
  add(path_568589, "operationId", newJString(operationId))
  result = call_568588.call(path_568589, query_568590, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_568578(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_568579, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_568580, schemes: {Scheme.Https})
type
  Call_BackupProtectableItemsList_568591 = ref object of OpenApiRestCall_567650
proc url_BackupProtectableItemsList_568593(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_BackupProtectableItemsList_568592(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the pagination parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  var valid_568596 = path.getOrDefault("vaultName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "vaultName", valid_568596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568597 = query.getOrDefault("api-version")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "api-version", valid_568597
  var valid_568598 = query.getOrDefault("$skipToken")
  valid_568598 = validateParameter(valid_568598, JString, required = false,
                                 default = nil)
  if valid_568598 != nil:
    section.add "$skipToken", valid_568598
  var valid_568599 = query.getOrDefault("$filter")
  valid_568599 = validateParameter(valid_568599, JString, required = false,
                                 default = nil)
  if valid_568599 != nil:
    section.add "$filter", valid_568599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568600: Call_BackupProtectableItemsList_568591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the pagination parameters.
  ## 
  let valid = call_568600.validator(path, query, header, formData, body)
  let scheme = call_568600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568600.url(scheme.get, call_568600.host, call_568600.base,
                         call_568600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568600, url, valid)

proc call*(call_568601: Call_BackupProtectableItemsList_568591;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupProtectableItemsList
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the pagination parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568602 = newJObject()
  var query_568603 = newJObject()
  add(path_568602, "resourceGroupName", newJString(resourceGroupName))
  add(query_568603, "api-version", newJString(apiVersion))
  add(path_568602, "subscriptionId", newJString(subscriptionId))
  add(path_568602, "vaultName", newJString(vaultName))
  add(query_568603, "$skipToken", newJString(SkipToken))
  add(query_568603, "$filter", newJString(Filter))
  result = call_568601.call(path_568602, query_568603, nil, nil, nil)

var backupProtectableItemsList* = Call_BackupProtectableItemsList_568591(
    name: "backupProtectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_BackupProtectableItemsList_568592, base: "",
    url: url_BackupProtectableItemsList_568593, schemes: {Scheme.Https})
type
  Call_BackupProtectedItemsList_568604 = ref object of OpenApiRestCall_567650
proc url_BackupProtectedItemsList_568606(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/backupProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupProtectedItemsList_568605(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of all items that are backed up within a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568607 = path.getOrDefault("resourceGroupName")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "resourceGroupName", valid_568607
  var valid_568608 = path.getOrDefault("subscriptionId")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "subscriptionId", valid_568608
  var valid_568609 = path.getOrDefault("vaultName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "vaultName", valid_568609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568610 = query.getOrDefault("api-version")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "api-version", valid_568610
  var valid_568611 = query.getOrDefault("$skipToken")
  valid_568611 = validateParameter(valid_568611, JString, required = false,
                                 default = nil)
  if valid_568611 != nil:
    section.add "$skipToken", valid_568611
  var valid_568612 = query.getOrDefault("$filter")
  valid_568612 = validateParameter(valid_568612, JString, required = false,
                                 default = nil)
  if valid_568612 != nil:
    section.add "$filter", valid_568612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568613: Call_BackupProtectedItemsList_568604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all items that are backed up within a vault.
  ## 
  let valid = call_568613.validator(path, query, header, formData, body)
  let scheme = call_568613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568613.url(scheme.get, call_568613.host, call_568613.base,
                         call_568613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568613, url, valid)

proc call*(call_568614: Call_BackupProtectedItemsList_568604;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupProtectedItemsList
  ## Provides a pageable list of all items that are backed up within a vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568615 = newJObject()
  var query_568616 = newJObject()
  add(path_568615, "resourceGroupName", newJString(resourceGroupName))
  add(query_568616, "api-version", newJString(apiVersion))
  add(path_568615, "subscriptionId", newJString(subscriptionId))
  add(path_568615, "vaultName", newJString(vaultName))
  add(query_568616, "$skipToken", newJString(SkipToken))
  add(query_568616, "$filter", newJString(Filter))
  result = call_568614.call(path_568615, query_568616, nil, nil, nil)

var backupProtectedItemsList* = Call_BackupProtectedItemsList_568604(
    name: "backupProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectedItems",
    validator: validate_BackupProtectedItemsList_568605, base: "",
    url: url_BackupProtectedItemsList_568606, schemes: {Scheme.Https})
type
  Call_BackupProtectionContainersList_568617 = ref object of OpenApiRestCall_567650
proc url_BackupProtectionContainersList_568619(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_BackupProtectionContainersList_568618(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568620 = path.getOrDefault("resourceGroupName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "resourceGroupName", valid_568620
  var valid_568621 = path.getOrDefault("subscriptionId")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "subscriptionId", valid_568621
  var valid_568622 = path.getOrDefault("vaultName")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "vaultName", valid_568622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568623 = query.getOrDefault("api-version")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "api-version", valid_568623
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

proc call*(call_568625: Call_BackupProtectionContainersList_568617; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  let valid = call_568625.validator(path, query, header, formData, body)
  let scheme = call_568625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568625.url(scheme.get, call_568625.host, call_568625.base,
                         call_568625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568625, url, valid)

proc call*(call_568626: Call_BackupProtectionContainersList_568617;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## backupProtectionContainersList
  ## Lists the containers registered to Recovery Services Vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568627 = newJObject()
  var query_568628 = newJObject()
  add(path_568627, "resourceGroupName", newJString(resourceGroupName))
  add(query_568628, "api-version", newJString(apiVersion))
  add(path_568627, "subscriptionId", newJString(subscriptionId))
  add(path_568627, "vaultName", newJString(vaultName))
  add(query_568628, "$filter", newJString(Filter))
  result = call_568626.call(path_568627, query_568628, nil, nil, nil)

var backupProtectionContainersList* = Call_BackupProtectionContainersList_568617(
    name: "backupProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_BackupProtectionContainersList_568618, base: "",
    url: url_BackupProtectionContainersList_568619, schemes: {Scheme.Https})
type
  Call_SecurityPINsGet_568629 = ref object of OpenApiRestCall_567650
proc url_SecurityPINsGet_568631(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backupSecurityPIN")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityPINsGet_568630(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the security PIN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "api-version", valid_568635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568636: Call_SecurityPINsGet_568629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security PIN.
  ## 
  let valid = call_568636.validator(path, query, header, formData, body)
  let scheme = call_568636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568636.url(scheme.get, call_568636.host, call_568636.base,
                         call_568636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568636, url, valid)

proc call*(call_568637: Call_SecurityPINsGet_568629; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string): Recallable =
  ## securityPINsGet
  ## Get the security PIN.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568638 = newJObject()
  var query_568639 = newJObject()
  add(path_568638, "resourceGroupName", newJString(resourceGroupName))
  add(query_568639, "api-version", newJString(apiVersion))
  add(path_568638, "subscriptionId", newJString(subscriptionId))
  add(path_568638, "vaultName", newJString(vaultName))
  result = call_568637.call(path_568638, query_568639, nil, nil, nil)

var securityPINsGet* = Call_SecurityPINsGet_568629(name: "securityPINsGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupSecurityPIN",
    validator: validate_SecurityPINsGet_568630, base: "", url: url_SecurityPINsGet_568631,
    schemes: {Scheme.Https})
type
  Call_BackupUsageSummariesList_568640 = ref object of OpenApiRestCall_567650
proc url_BackupUsageSummariesList_568642(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/backupUsageSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupUsageSummariesList_568641(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the backup management usage summaries of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568643 = path.getOrDefault("resourceGroupName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "resourceGroupName", valid_568643
  var valid_568644 = path.getOrDefault("subscriptionId")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "subscriptionId", valid_568644
  var valid_568645 = path.getOrDefault("vaultName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "vaultName", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568646 = query.getOrDefault("api-version")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "api-version", valid_568646
  var valid_568647 = query.getOrDefault("$skipToken")
  valid_568647 = validateParameter(valid_568647, JString, required = false,
                                 default = nil)
  if valid_568647 != nil:
    section.add "$skipToken", valid_568647
  var valid_568648 = query.getOrDefault("$filter")
  valid_568648 = validateParameter(valid_568648, JString, required = false,
                                 default = nil)
  if valid_568648 != nil:
    section.add "$filter", valid_568648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568649: Call_BackupUsageSummariesList_568640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the backup management usage summaries of the vault.
  ## 
  let valid = call_568649.validator(path, query, header, formData, body)
  let scheme = call_568649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568649.url(scheme.get, call_568649.host, call_568649.base,
                         call_568649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568649, url, valid)

proc call*(call_568650: Call_BackupUsageSummariesList_568640;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupUsageSummariesList
  ## Fetches the backup management usage summaries of the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568651 = newJObject()
  var query_568652 = newJObject()
  add(path_568651, "resourceGroupName", newJString(resourceGroupName))
  add(query_568652, "api-version", newJString(apiVersion))
  add(path_568651, "subscriptionId", newJString(subscriptionId))
  add(path_568651, "vaultName", newJString(vaultName))
  add(query_568652, "$skipToken", newJString(SkipToken))
  add(query_568652, "$filter", newJString(Filter))
  result = call_568650.call(path_568651, query_568652, nil, nil, nil)

var backupUsageSummariesList* = Call_BackupUsageSummariesList_568640(
    name: "backupUsageSummariesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupUsageSummaries",
    validator: validate_BackupUsageSummariesList_568641, base: "",
    url: url_BackupUsageSummariesList_568642, schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsGet_568653 = ref object of OpenApiRestCall_567650
proc url_BackupResourceVaultConfigsGet_568655(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/backupconfig/vaultconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceVaultConfigsGet_568654(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches resource vault config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568656 = path.getOrDefault("resourceGroupName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "resourceGroupName", valid_568656
  var valid_568657 = path.getOrDefault("subscriptionId")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "subscriptionId", valid_568657
  var valid_568658 = path.getOrDefault("vaultName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "vaultName", valid_568658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568659 = query.getOrDefault("api-version")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "api-version", valid_568659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568660: Call_BackupResourceVaultConfigsGet_568653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches resource vault config.
  ## 
  let valid = call_568660.validator(path, query, header, formData, body)
  let scheme = call_568660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568660.url(scheme.get, call_568660.host, call_568660.base,
                         call_568660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568660, url, valid)

proc call*(call_568661: Call_BackupResourceVaultConfigsGet_568653;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## backupResourceVaultConfigsGet
  ## Fetches resource vault config.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568662 = newJObject()
  var query_568663 = newJObject()
  add(path_568662, "resourceGroupName", newJString(resourceGroupName))
  add(query_568663, "api-version", newJString(apiVersion))
  add(path_568662, "subscriptionId", newJString(subscriptionId))
  add(path_568662, "vaultName", newJString(vaultName))
  result = call_568661.call(path_568662, query_568663, nil, nil, nil)

var backupResourceVaultConfigsGet* = Call_BackupResourceVaultConfigsGet_568653(
    name: "backupResourceVaultConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsGet_568654, base: "",
    url: url_BackupResourceVaultConfigsGet_568655, schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsUpdate_568664 = ref object of OpenApiRestCall_567650
proc url_BackupResourceVaultConfigsUpdate_568666(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/backupconfig/vaultconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceVaultConfigsUpdate_568665(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault security config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568667 = path.getOrDefault("resourceGroupName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "resourceGroupName", valid_568667
  var valid_568668 = path.getOrDefault("subscriptionId")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "subscriptionId", valid_568668
  var valid_568669 = path.getOrDefault("vaultName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "vaultName", valid_568669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568670 = query.getOrDefault("api-version")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "api-version", valid_568670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource config request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568672: Call_BackupResourceVaultConfigsUpdate_568664;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault security config.
  ## 
  let valid = call_568672.validator(path, query, header, formData, body)
  let scheme = call_568672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568672.url(scheme.get, call_568672.host, call_568672.base,
                         call_568672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568672, url, valid)

proc call*(call_568673: Call_BackupResourceVaultConfigsUpdate_568664;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## backupResourceVaultConfigsUpdate
  ## Updates vault security config.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource config request
  var path_568674 = newJObject()
  var query_568675 = newJObject()
  var body_568676 = newJObject()
  add(path_568674, "resourceGroupName", newJString(resourceGroupName))
  add(query_568675, "api-version", newJString(apiVersion))
  add(path_568674, "subscriptionId", newJString(subscriptionId))
  add(path_568674, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568676 = parameters
  result = call_568673.call(path_568674, query_568675, nil, nil, body_568676)

var backupResourceVaultConfigsUpdate* = Call_BackupResourceVaultConfigsUpdate_568664(
    name: "backupResourceVaultConfigsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsUpdate_568665, base: "",
    url: url_BackupResourceVaultConfigsUpdate_568666, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsGet_568677 = ref object of OpenApiRestCall_567650
proc url_BackupResourceStorageConfigsGet_568679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/backupstorageconfig/vaultstorageconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceStorageConfigsGet_568678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches resource storage config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568680 = path.getOrDefault("resourceGroupName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "resourceGroupName", valid_568680
  var valid_568681 = path.getOrDefault("subscriptionId")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "subscriptionId", valid_568681
  var valid_568682 = path.getOrDefault("vaultName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "vaultName", valid_568682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568683 = query.getOrDefault("api-version")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "api-version", valid_568683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568684: Call_BackupResourceStorageConfigsGet_568677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches resource storage config.
  ## 
  let valid = call_568684.validator(path, query, header, formData, body)
  let scheme = call_568684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568684.url(scheme.get, call_568684.host, call_568684.base,
                         call_568684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568684, url, valid)

proc call*(call_568685: Call_BackupResourceStorageConfigsGet_568677;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## backupResourceStorageConfigsGet
  ## Fetches resource storage config.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568686 = newJObject()
  var query_568687 = newJObject()
  add(path_568686, "resourceGroupName", newJString(resourceGroupName))
  add(query_568687, "api-version", newJString(apiVersion))
  add(path_568686, "subscriptionId", newJString(subscriptionId))
  add(path_568686, "vaultName", newJString(vaultName))
  result = call_568685.call(path_568686, query_568687, nil, nil, nil)

var backupResourceStorageConfigsGet* = Call_BackupResourceStorageConfigsGet_568677(
    name: "backupResourceStorageConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsGet_568678, base: "",
    url: url_BackupResourceStorageConfigsGet_568679, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsUpdate_568688 = ref object of OpenApiRestCall_567650
proc url_BackupResourceStorageConfigsUpdate_568690(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/backupstorageconfig/vaultstorageconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceStorageConfigsUpdate_568689(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault storage model type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568691 = path.getOrDefault("resourceGroupName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "resourceGroupName", valid_568691
  var valid_568692 = path.getOrDefault("subscriptionId")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "subscriptionId", valid_568692
  var valid_568693 = path.getOrDefault("vaultName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "vaultName", valid_568693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568694 = query.getOrDefault("api-version")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "api-version", valid_568694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568695: Call_BackupResourceStorageConfigsUpdate_568688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_568695.validator(path, query, header, formData, body)
  let scheme = call_568695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568695.url(scheme.get, call_568695.host, call_568695.base,
                         call_568695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568695, url, valid)

proc call*(call_568696: Call_BackupResourceStorageConfigsUpdate_568688;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## backupResourceStorageConfigsUpdate
  ## Updates vault storage model type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568697 = newJObject()
  var query_568698 = newJObject()
  add(path_568697, "resourceGroupName", newJString(resourceGroupName))
  add(query_568698, "api-version", newJString(apiVersion))
  add(path_568697, "subscriptionId", newJString(subscriptionId))
  add(path_568697, "vaultName", newJString(vaultName))
  result = call_568696.call(path_568697, query_568698, nil, nil, nil)

var backupResourceStorageConfigsUpdate* = Call_BackupResourceStorageConfigsUpdate_568688(
    name: "backupResourceStorageConfigsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsUpdate_568689, base: "",
    url: url_BackupResourceStorageConfigsUpdate_568690, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
