
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup-bms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesList_563787 = ref object of OpenApiRestCall_563565
proc url_BackupEnginesList_563789(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesList_563788(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_563965 = path.getOrDefault("vaultName")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "vaultName", valid_563965
  var valid_563966 = path.getOrDefault("subscriptionId")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "subscriptionId", valid_563966
  var valid_563967 = path.getOrDefault("resourceGroupName")
  valid_563967 = validateParameter(valid_563967, JString, required = true,
                                 default = nil)
  if valid_563967 != nil:
    section.add "resourceGroupName", valid_563967
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_563968 = query.getOrDefault("$skipToken")
  valid_563968 = validateParameter(valid_563968, JString, required = false,
                                 default = nil)
  if valid_563968 != nil:
    section.add "$skipToken", valid_563968
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563969 = query.getOrDefault("api-version")
  valid_563969 = validateParameter(valid_563969, JString, required = true,
                                 default = nil)
  if valid_563969 != nil:
    section.add "api-version", valid_563969
  var valid_563970 = query.getOrDefault("$filter")
  valid_563970 = validateParameter(valid_563970, JString, required = false,
                                 default = nil)
  if valid_563970 != nil:
    section.add "$filter", valid_563970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563993: Call_BackupEnginesList_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  let valid = call_563993.validator(path, query, header, formData, body)
  let scheme = call_563993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563993.url(scheme.get, call_563993.host, call_563993.base,
                         call_563993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563993, url, valid)

proc call*(call_564064: Call_BackupEnginesList_563787; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesList
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  var path_564065 = newJObject()
  var query_564067 = newJObject()
  add(query_564067, "$skipToken", newJString(SkipToken))
  add(path_564065, "vaultName", newJString(vaultName))
  add(query_564067, "api-version", newJString(apiVersion))
  add(path_564065, "subscriptionId", newJString(subscriptionId))
  add(path_564065, "resourceGroupName", newJString(resourceGroupName))
  add(query_564067, "$filter", newJString(Filter))
  result = call_564064.call(path_564065, query_564067, nil, nil, nil)

var backupEnginesList* = Call_BackupEnginesList_563787(name: "backupEnginesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesList_563788, base: "",
    url: url_BackupEnginesList_563789, schemes: {Scheme.Https})
type
  Call_BackupEnginesGet_564106 = ref object of OpenApiRestCall_563565
proc url_BackupEnginesGet_564108(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesGet_564107(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   backupEngineName: JString (required)
  ##                   : Name of the backup management server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564109 = path.getOrDefault("vaultName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "vaultName", valid_564109
  var valid_564110 = path.getOrDefault("backupEngineName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "backupEngineName", valid_564110
  var valid_564111 = path.getOrDefault("subscriptionId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "subscriptionId", valid_564111
  var valid_564112 = path.getOrDefault("resourceGroupName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceGroupName", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_564113 = query.getOrDefault("$skipToken")
  valid_564113 = validateParameter(valid_564113, JString, required = false,
                                 default = nil)
  if valid_564113 != nil:
    section.add "$skipToken", valid_564113
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  var valid_564115 = query.getOrDefault("$filter")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "$filter", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_BackupEnginesGet_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_BackupEnginesGet_564106; vaultName: string;
          backupEngineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesGet
  ## Returns backup management server registered to Recovery Services Vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   backupEngineName: string (required)
  ##                   : Name of the backup management server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "$skipToken", newJString(SkipToken))
  add(path_564118, "vaultName", newJString(vaultName))
  add(path_564118, "backupEngineName", newJString(backupEngineName))
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(query_564119, "$filter", newJString(Filter))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_564106(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines/{backupEngineName}",
    validator: validate_BackupEnginesGet_564107, base: "",
    url: url_BackupEnginesGet_564108, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_564120 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainerRefreshOperationResultsGet_564122(protocol: Scheme;
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

proc validate_ProtectionContainerRefreshOperationResultsGet_564121(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID associated with the operation whose result needs to be fetched.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564123 = path.getOrDefault("vaultName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "vaultName", valid_564123
  var valid_564124 = path.getOrDefault("operationId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "operationId", valid_564124
  var valid_564125 = path.getOrDefault("fabricName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "fabricName", valid_564125
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("resourceGroupName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "resourceGroupName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_ProtectionContainerRefreshOperationResultsGet_564120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_ProtectionContainerRefreshOperationResultsGet_564120;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## protectionContainerRefreshOperationResultsGet
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : Operation ID associated with the operation whose result needs to be fetched.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(path_564131, "vaultName", newJString(vaultName))
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "operationId", newJString(operationId))
  add(path_564131, "fabricName", newJString(fabricName))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "resourceGroupName", newJString(resourceGroupName))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_564120(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_564121,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_564122,
    schemes: {Scheme.Https})
type
  Call_ProtectableContainersList_564133 = ref object of OpenApiRestCall_563565
proc url_ProtectableContainersList_564135(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/protectableContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectableContainersList_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers that can be registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564136 = path.getOrDefault("vaultName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "vaultName", valid_564136
  var valid_564137 = path.getOrDefault("fabricName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "fabricName", valid_564137
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("resourceGroupName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceGroupName", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  var valid_564141 = query.getOrDefault("$filter")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "$filter", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_ProtectableContainersList_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers that can be registered to Recovery Services Vault.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_ProtectableContainersList_564133; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; Filter: string = ""): Recallable =
  ## protectableContainersList
  ## Lists the containers that can be registered to Recovery Services Vault.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(path_564144, "vaultName", newJString(vaultName))
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "fabricName", newJString(fabricName))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  add(path_564144, "resourceGroupName", newJString(resourceGroupName))
  add(query_564145, "$filter", newJString(Filter))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var protectableContainersList* = Call_ProtectableContainersList_564133(
    name: "protectableContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectableContainers",
    validator: validate_ProtectableContainersList_564134, base: "",
    url: url_ProtectableContainersList_564135, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRegister_564159 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainersRegister_564161(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRegister_564160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container to be registered.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564179 = path.getOrDefault("vaultName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "vaultName", valid_564179
  var valid_564180 = path.getOrDefault("fabricName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "fabricName", valid_564180
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  var valid_564183 = path.getOrDefault("containerName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "containerName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request body for operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_ProtectionContainersRegister_564159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_ProtectionContainersRegister_564159;
          vaultName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          parameters: JsonNode): Recallable =
  ## protectionContainersRegister
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Name of the container to be registered.
  ##   parameters: JObject (required)
  ##             : Request body for operation
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  var body_564190 = newJObject()
  add(path_564188, "vaultName", newJString(vaultName))
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "fabricName", newJString(fabricName))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  add(path_564188, "resourceGroupName", newJString(resourceGroupName))
  add(path_564188, "containerName", newJString(containerName))
  if parameters != nil:
    body_564190 = parameters
  result = call_564187.call(path_564188, query_564189, nil, nil, body_564190)

var protectionContainersRegister* = Call_ProtectionContainersRegister_564159(
    name: "protectionContainersRegister", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersRegister_564160, base: "",
    url: url_ProtectionContainersRegister_564161, schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_564146 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainersGet_564148(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionContainersGet_564147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Name of the fabric where the container belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container whose details need to be fetched.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564149 = path.getOrDefault("vaultName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "vaultName", valid_564149
  var valid_564150 = path.getOrDefault("fabricName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "fabricName", valid_564150
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  var valid_564153 = path.getOrDefault("containerName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "containerName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_ProtectionContainersGet_564146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_ProtectionContainersGet_564146; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## protectionContainersGet
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Name of the fabric where the container belongs.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Name of the container whose details need to be fetched.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(path_564157, "vaultName", newJString(vaultName))
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "fabricName", newJString(fabricName))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  add(path_564157, "containerName", newJString(containerName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_564146(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_564147, base: "",
    url: url_ProtectionContainersGet_564148, schemes: {Scheme.Https})
type
  Call_ProtectionContainersUnregister_564191 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainersUnregister_564193(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersUnregister_564192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Name of the fabric where the container belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container which needs to be unregistered from the Recovery Services Vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564194 = path.getOrDefault("vaultName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "vaultName", valid_564194
  var valid_564195 = path.getOrDefault("fabricName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "fabricName", valid_564195
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  var valid_564198 = path.getOrDefault("containerName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "containerName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_ProtectionContainersUnregister_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_ProtectionContainersUnregister_564191;
          vaultName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string): Recallable =
  ## protectionContainersUnregister
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Name of the fabric where the container belongs.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Name of the container which needs to be unregistered from the Recovery Services Vault.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(path_564202, "vaultName", newJString(vaultName))
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "fabricName", newJString(fabricName))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  add(path_564202, "containerName", newJString(containerName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var protectionContainersUnregister* = Call_ProtectionContainersUnregister_564191(
    name: "protectionContainersUnregister", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersUnregister_564192, base: "",
    url: url_ProtectionContainersUnregister_564193, schemes: {Scheme.Https})
type
  Call_ProtectionContainersInquire_564204 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainersInquire_564206(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/inquire")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersInquire_564205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric Name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container in which inquiry needs to be triggered.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564207 = path.getOrDefault("vaultName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "vaultName", valid_564207
  var valid_564208 = path.getOrDefault("fabricName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "fabricName", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("containerName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "containerName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  var valid_564213 = query.getOrDefault("$filter")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "$filter", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_ProtectionContainersInquire_564204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_ProtectionContainersInquire_564204; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string; Filter: string = ""): Recallable =
  ## protectionContainersInquire
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric Name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Name of the container in which inquiry needs to be triggered.
  ##   Filter: string
  ##         : OData filter options.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(path_564216, "vaultName", newJString(vaultName))
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "fabricName", newJString(fabricName))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  add(path_564216, "containerName", newJString(containerName))
  add(query_564217, "$filter", newJString(Filter))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var protectionContainersInquire* = Call_ProtectionContainersInquire_564204(
    name: "protectionContainersInquire", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/inquire",
    validator: validate_ProtectionContainersInquire_564205, base: "",
    url: url_ProtectionContainersInquire_564206, schemes: {Scheme.Https})
type
  Call_BackupWorkloadItemsList_564218 = ref object of OpenApiRestCall_563565
proc url_BackupWorkloadItemsList_564220(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/items")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupWorkloadItemsList_564219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564221 = path.getOrDefault("vaultName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "vaultName", valid_564221
  var valid_564222 = path.getOrDefault("fabricName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "fabricName", valid_564222
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  var valid_564225 = path.getOrDefault("containerName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "containerName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_564226 = query.getOrDefault("$skipToken")
  valid_564226 = validateParameter(valid_564226, JString, required = false,
                                 default = nil)
  if valid_564226 != nil:
    section.add "$skipToken", valid_564226
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564227 = query.getOrDefault("api-version")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "api-version", valid_564227
  var valid_564228 = query.getOrDefault("$filter")
  valid_564228 = validateParameter(valid_564228, JString, required = false,
                                 default = nil)
  if valid_564228 != nil:
    section.add "$filter", valid_564228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564229: Call_BackupWorkloadItemsList_564218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ## 
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_BackupWorkloadItemsList_564218; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## backupWorkloadItemsList
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Name of the container.
  ##   Filter: string
  ##         : OData filter options.
  var path_564231 = newJObject()
  var query_564232 = newJObject()
  add(query_564232, "$skipToken", newJString(SkipToken))
  add(path_564231, "vaultName", newJString(vaultName))
  add(query_564232, "api-version", newJString(apiVersion))
  add(path_564231, "fabricName", newJString(fabricName))
  add(path_564231, "subscriptionId", newJString(subscriptionId))
  add(path_564231, "resourceGroupName", newJString(resourceGroupName))
  add(path_564231, "containerName", newJString(containerName))
  add(query_564232, "$filter", newJString(Filter))
  result = call_564230.call(path_564231, query_564232, nil, nil, nil)

var backupWorkloadItemsList* = Call_BackupWorkloadItemsList_564218(
    name: "backupWorkloadItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/items",
    validator: validate_BackupWorkloadItemsList_564219, base: "",
    url: url_BackupWorkloadItemsList_564220, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_564233 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainerOperationResultsGet_564235(protocol: Scheme;
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

proc validate_ProtectionContainerOperationResultsGet_564234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation on the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name whose information should be fetched.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564236 = path.getOrDefault("vaultName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "vaultName", valid_564236
  var valid_564237 = path.getOrDefault("operationId")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "operationId", valid_564237
  var valid_564238 = path.getOrDefault("fabricName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "fabricName", valid_564238
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
  var valid_564241 = path.getOrDefault("containerName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "containerName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564243: Call_ProtectionContainerOperationResultsGet_564233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the container.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_ProtectionContainerOperationResultsGet_564233;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          containerName: string): Recallable =
  ## protectionContainerOperationResultsGet
  ## Fetches the result of any operation on the container.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name whose information should be fetched.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(path_564245, "vaultName", newJString(vaultName))
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "operationId", newJString(operationId))
  add(path_564245, "fabricName", newJString(fabricName))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "resourceGroupName", newJString(resourceGroupName))
  add(path_564245, "containerName", newJString(containerName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_564233(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_564234, base: "",
    url: url_ProtectionContainerOperationResultsGet_564235,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_564262 = ref object of OpenApiRestCall_563565
proc url_ProtectedItemsCreateOrUpdate_564264(protocol: Scheme; host: string;
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

proc validate_ProtectedItemsCreateOrUpdate_564263(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Item name to be backed up.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564265 = path.getOrDefault("vaultName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "vaultName", valid_564265
  var valid_564266 = path.getOrDefault("fabricName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "fabricName", valid_564266
  var valid_564267 = path.getOrDefault("protectedItemName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "protectedItemName", valid_564267
  var valid_564268 = path.getOrDefault("subscriptionId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "subscriptionId", valid_564268
  var valid_564269 = path.getOrDefault("resourceGroupName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "resourceGroupName", valid_564269
  var valid_564270 = path.getOrDefault("containerName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "containerName", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "api-version", valid_564271
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

proc call*(call_564273: Call_ProtectedItemsCreateOrUpdate_564262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_ProtectedItemsCreateOrUpdate_564262;
          vaultName: string; apiVersion: string; fabricName: string;
          protectedItemName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string; parameters: JsonNode): Recallable =
  ## protectedItemsCreateOrUpdate
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Item name to be backed up.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   parameters: JObject (required)
  ##             : resource backed up item
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  var body_564277 = newJObject()
  add(path_564275, "vaultName", newJString(vaultName))
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "fabricName", newJString(fabricName))
  add(path_564275, "protectedItemName", newJString(protectedItemName))
  add(path_564275, "subscriptionId", newJString(subscriptionId))
  add(path_564275, "resourceGroupName", newJString(resourceGroupName))
  add(path_564275, "containerName", newJString(containerName))
  if parameters != nil:
    body_564277 = parameters
  result = call_564274.call(path_564275, query_564276, nil, nil, body_564277)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_564262(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_564263, base: "",
    url: url_ProtectedItemsCreateOrUpdate_564264, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_564247 = ref object of OpenApiRestCall_563565
proc url_ProtectedItemsGet_564249(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsGet_564248(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose details are to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564250 = path.getOrDefault("vaultName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "vaultName", valid_564250
  var valid_564251 = path.getOrDefault("fabricName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "fabricName", valid_564251
  var valid_564252 = path.getOrDefault("protectedItemName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "protectedItemName", valid_564252
  var valid_564253 = path.getOrDefault("subscriptionId")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "subscriptionId", valid_564253
  var valid_564254 = path.getOrDefault("resourceGroupName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "resourceGroupName", valid_564254
  var valid_564255 = path.getOrDefault("containerName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "containerName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  var valid_564257 = query.getOrDefault("$filter")
  valid_564257 = validateParameter(valid_564257, JString, required = false,
                                 default = nil)
  if valid_564257 != nil:
    section.add "$filter", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_ProtectedItemsGet_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ProtectedItemsGet_564247; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          Filter: string = ""): Recallable =
  ## protectedItemsGet
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose details are to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   Filter: string
  ##         : OData filter options.
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(path_564260, "vaultName", newJString(vaultName))
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "fabricName", newJString(fabricName))
  add(path_564260, "protectedItemName", newJString(protectedItemName))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "resourceGroupName", newJString(resourceGroupName))
  add(path_564260, "containerName", newJString(containerName))
  add(query_564261, "$filter", newJString(Filter))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_564247(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_564248, base: "",
    url: url_ProtectedItemsGet_564249, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_564278 = ref object of OpenApiRestCall_563565
proc url_ProtectedItemsDelete_564280(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsDelete_564279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564281 = path.getOrDefault("vaultName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "vaultName", valid_564281
  var valid_564282 = path.getOrDefault("fabricName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "fabricName", valid_564282
  var valid_564283 = path.getOrDefault("protectedItemName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "protectedItemName", valid_564283
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("resourceGroupName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "resourceGroupName", valid_564285
  var valid_564286 = path.getOrDefault("containerName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "containerName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_ProtectedItemsDelete_564278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_ProtectedItemsDelete_564278; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string): Recallable =
  ## protectedItemsDelete
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(path_564290, "vaultName", newJString(vaultName))
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "fabricName", newJString(fabricName))
  add(path_564290, "protectedItemName", newJString(protectedItemName))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  add(path_564290, "containerName", newJString(containerName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_564278(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_564279, base: "",
    url: url_ProtectedItemsDelete_564280, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_564292 = ref object of OpenApiRestCall_563565
proc url_BackupsTrigger_564294(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsTrigger_564293(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item for which backup needs to be triggered.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564295 = path.getOrDefault("vaultName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "vaultName", valid_564295
  var valid_564296 = path.getOrDefault("fabricName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "fabricName", valid_564296
  var valid_564297 = path.getOrDefault("protectedItemName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "protectedItemName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("containerName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "containerName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
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

proc call*(call_564303: Call_BackupsTrigger_564292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_BackupsTrigger_564292; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          parameters: JsonNode): Recallable =
  ## backupsTrigger
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item for which backup needs to be triggered.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   parameters: JObject (required)
  ##             : resource backup request
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  add(path_564305, "vaultName", newJString(vaultName))
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "fabricName", newJString(fabricName))
  add(path_564305, "protectedItemName", newJString(protectedItemName))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "containerName", newJString(containerName))
  if parameters != nil:
    body_564307 = parameters
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var backupsTrigger* = Call_BackupsTrigger_564292(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_564293, base: "", url: url_BackupsTrigger_564294,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_564308 = ref object of OpenApiRestCall_563565
proc url_ProtectedItemOperationResultsGet_564310(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationResultsGet_564309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation on the backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation whose result needs to be fetched.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564311 = path.getOrDefault("vaultName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "vaultName", valid_564311
  var valid_564312 = path.getOrDefault("operationId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "operationId", valid_564312
  var valid_564313 = path.getOrDefault("fabricName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "fabricName", valid_564313
  var valid_564314 = path.getOrDefault("protectedItemName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "protectedItemName", valid_564314
  var valid_564315 = path.getOrDefault("subscriptionId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "subscriptionId", valid_564315
  var valid_564316 = path.getOrDefault("resourceGroupName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "resourceGroupName", valid_564316
  var valid_564317 = path.getOrDefault("containerName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "containerName", valid_564317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564318 = query.getOrDefault("api-version")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "api-version", valid_564318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564319: Call_ProtectedItemOperationResultsGet_564308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the backup item.
  ## 
  let valid = call_564319.validator(path, query, header, formData, body)
  let scheme = call_564319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564319.url(scheme.get, call_564319.host, call_564319.base,
                         call_564319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564319, url, valid)

proc call*(call_564320: Call_ProtectedItemOperationResultsGet_564308;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; protectedItemName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## protectedItemOperationResultsGet
  ## Fetches the result of any operation on the backup item.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation whose result needs to be fetched.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  var path_564321 = newJObject()
  var query_564322 = newJObject()
  add(path_564321, "vaultName", newJString(vaultName))
  add(query_564322, "api-version", newJString(apiVersion))
  add(path_564321, "operationId", newJString(operationId))
  add(path_564321, "fabricName", newJString(fabricName))
  add(path_564321, "protectedItemName", newJString(protectedItemName))
  add(path_564321, "subscriptionId", newJString(subscriptionId))
  add(path_564321, "resourceGroupName", newJString(resourceGroupName))
  add(path_564321, "containerName", newJString(containerName))
  result = call_564320.call(path_564321, query_564322, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_564308(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_564309, base: "",
    url: url_ProtectedItemOperationResultsGet_564310, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_564323 = ref object of OpenApiRestCall_563565
proc url_ProtectedItemOperationStatusesGet_564325(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationStatusesGet_564324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID represents the operation whose status needs to be fetched.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564326 = path.getOrDefault("vaultName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "vaultName", valid_564326
  var valid_564327 = path.getOrDefault("operationId")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "operationId", valid_564327
  var valid_564328 = path.getOrDefault("fabricName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "fabricName", valid_564328
  var valid_564329 = path.getOrDefault("protectedItemName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "protectedItemName", valid_564329
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
  var valid_564332 = path.getOrDefault("containerName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "containerName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_ProtectedItemOperationStatusesGet_564323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_ProtectedItemOperationStatusesGet_564323;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; protectedItemName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## protectedItemOperationStatusesGet
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : OperationID represents the operation whose status needs to be fetched.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(path_564336, "vaultName", newJString(vaultName))
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "operationId", newJString(operationId))
  add(path_564336, "fabricName", newJString(fabricName))
  add(path_564336, "protectedItemName", newJString(protectedItemName))
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  add(path_564336, "containerName", newJString(containerName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_564323(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_564324, base: "",
    url: url_ProtectedItemOperationStatusesGet_564325, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_564338 = ref object of OpenApiRestCall_563565
proc url_RecoveryPointsList_564340(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsList_564339(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the backup copies for the backed up item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item whose backup copies are to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564341 = path.getOrDefault("vaultName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "vaultName", valid_564341
  var valid_564342 = path.getOrDefault("fabricName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "fabricName", valid_564342
  var valid_564343 = path.getOrDefault("protectedItemName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "protectedItemName", valid_564343
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
  var valid_564346 = path.getOrDefault("containerName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "containerName", valid_564346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564347 = query.getOrDefault("api-version")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "api-version", valid_564347
  var valid_564348 = query.getOrDefault("$filter")
  valid_564348 = validateParameter(valid_564348, JString, required = false,
                                 default = nil)
  if valid_564348 != nil:
    section.add "$filter", valid_564348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_RecoveryPointsList_564338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup copies for the backed up item.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_RecoveryPointsList_564338; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          Filter: string = ""): Recallable =
  ## recoveryPointsList
  ## Lists the backup copies for the backed up item.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item whose backup copies are to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   Filter: string
  ##         : OData filter options.
  var path_564351 = newJObject()
  var query_564352 = newJObject()
  add(path_564351, "vaultName", newJString(vaultName))
  add(query_564352, "api-version", newJString(apiVersion))
  add(path_564351, "fabricName", newJString(fabricName))
  add(path_564351, "protectedItemName", newJString(protectedItemName))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  add(path_564351, "resourceGroupName", newJString(resourceGroupName))
  add(path_564351, "containerName", newJString(containerName))
  add(query_564352, "$filter", newJString(Filter))
  result = call_564350.call(path_564351, query_564352, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_564338(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_564339, base: "",
    url: url_RecoveryPointsList_564340, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_564353 = ref object of OpenApiRestCall_563565
proc url_RecoveryPointsGet_564355(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_564354(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose backup data needs to be fetched.
  ##   recoveryPointId: JString (required)
  ##                  : RecoveryPointID represents the backed up data to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with backed up item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564356 = path.getOrDefault("vaultName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "vaultName", valid_564356
  var valid_564357 = path.getOrDefault("fabricName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "fabricName", valid_564357
  var valid_564358 = path.getOrDefault("protectedItemName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "protectedItemName", valid_564358
  var valid_564359 = path.getOrDefault("recoveryPointId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "recoveryPointId", valid_564359
  var valid_564360 = path.getOrDefault("subscriptionId")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "subscriptionId", valid_564360
  var valid_564361 = path.getOrDefault("resourceGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceGroupName", valid_564361
  var valid_564362 = path.getOrDefault("containerName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "containerName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564363 = query.getOrDefault("api-version")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "api-version", valid_564363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_RecoveryPointsGet_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_RecoveryPointsGet_564353; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          recoveryPointId: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## recoveryPointsGet
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose backup data needs to be fetched.
  ##   recoveryPointId: string (required)
  ##                  : RecoveryPointID represents the backed up data to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with backed up item.
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  add(path_564366, "vaultName", newJString(vaultName))
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "fabricName", newJString(fabricName))
  add(path_564366, "protectedItemName", newJString(protectedItemName))
  add(path_564366, "recoveryPointId", newJString(recoveryPointId))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  add(path_564366, "containerName", newJString(containerName))
  result = call_564365.call(path_564366, query_564367, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_564353(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_564354, base: "",
    url: url_RecoveryPointsGet_564355, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_564368 = ref object of OpenApiRestCall_563565
proc url_ItemLevelRecoveryConnectionsProvision_564370(protocol: Scheme;
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

proc validate_ItemLevelRecoveryConnectionsProvision_564369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be provisioned
  ## for this backed up data.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564371 = path.getOrDefault("vaultName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "vaultName", valid_564371
  var valid_564372 = path.getOrDefault("fabricName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "fabricName", valid_564372
  var valid_564373 = path.getOrDefault("protectedItemName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "protectedItemName", valid_564373
  var valid_564374 = path.getOrDefault("recoveryPointId")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "recoveryPointId", valid_564374
  var valid_564375 = path.getOrDefault("subscriptionId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "subscriptionId", valid_564375
  var valid_564376 = path.getOrDefault("resourceGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "resourceGroupName", valid_564376
  var valid_564377 = path.getOrDefault("containerName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "containerName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
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

proc call*(call_564380: Call_ItemLevelRecoveryConnectionsProvision_564368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_ItemLevelRecoveryConnectionsProvision_564368;
          vaultName: string; apiVersion: string; fabricName: string;
          protectedItemName: string; recoveryPointId: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          parameters: JsonNode): Recallable =
  ## itemLevelRecoveryConnectionsProvision
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be provisioned
  ## for this backed up data.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   parameters: JObject (required)
  ##             : resource ILR request
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  var body_564384 = newJObject()
  add(path_564382, "vaultName", newJString(vaultName))
  add(query_564383, "api-version", newJString(apiVersion))
  add(path_564382, "fabricName", newJString(fabricName))
  add(path_564382, "protectedItemName", newJString(protectedItemName))
  add(path_564382, "recoveryPointId", newJString(recoveryPointId))
  add(path_564382, "subscriptionId", newJString(subscriptionId))
  add(path_564382, "resourceGroupName", newJString(resourceGroupName))
  add(path_564382, "containerName", newJString(containerName))
  if parameters != nil:
    body_564384 = parameters
  result = call_564381.call(path_564382, query_564383, nil, nil, body_564384)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_564368(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_564369, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_564370, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_564385 = ref object of OpenApiRestCall_563565
proc url_RestoresTrigger_564387(protocol: Scheme; host: string; base: string;
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

proc validate_RestoresTrigger_564386(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item to be restored.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents the backed up data to be restored.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564388 = path.getOrDefault("vaultName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "vaultName", valid_564388
  var valid_564389 = path.getOrDefault("fabricName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "fabricName", valid_564389
  var valid_564390 = path.getOrDefault("protectedItemName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "protectedItemName", valid_564390
  var valid_564391 = path.getOrDefault("recoveryPointId")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "recoveryPointId", valid_564391
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("resourceGroupName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "resourceGroupName", valid_564393
  var valid_564394 = path.getOrDefault("containerName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "containerName", valid_564394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564395 = query.getOrDefault("api-version")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "api-version", valid_564395
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

proc call*(call_564397: Call_RestoresTrigger_564385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ## 
  let valid = call_564397.validator(path, query, header, formData, body)
  let scheme = call_564397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564397.url(scheme.get, call_564397.host, call_564397.base,
                         call_564397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564397, url, valid)

proc call*(call_564398: Call_RestoresTrigger_564385; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          recoveryPointId: string; subscriptionId: string;
          resourceGroupName: string; containerName: string; parameters: JsonNode): Recallable =
  ## restoresTrigger
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item to be restored.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents the backed up data to be restored.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   parameters: JObject (required)
  ##             : resource restore request
  var path_564399 = newJObject()
  var query_564400 = newJObject()
  var body_564401 = newJObject()
  add(path_564399, "vaultName", newJString(vaultName))
  add(query_564400, "api-version", newJString(apiVersion))
  add(path_564399, "fabricName", newJString(fabricName))
  add(path_564399, "protectedItemName", newJString(protectedItemName))
  add(path_564399, "recoveryPointId", newJString(recoveryPointId))
  add(path_564399, "subscriptionId", newJString(subscriptionId))
  add(path_564399, "resourceGroupName", newJString(resourceGroupName))
  add(path_564399, "containerName", newJString(containerName))
  if parameters != nil:
    body_564401 = parameters
  result = call_564398.call(path_564399, query_564400, nil, nil, body_564401)

var restoresTrigger* = Call_RestoresTrigger_564385(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_564386, base: "", url: url_RestoresTrigger_564387,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_564402 = ref object of OpenApiRestCall_563565
proc url_ItemLevelRecoveryConnectionsRevoke_564404(protocol: Scheme; host: string;
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

proc validate_ItemLevelRecoveryConnectionsRevoke_564403(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be revoked for
  ## this backed up data.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564405 = path.getOrDefault("vaultName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "vaultName", valid_564405
  var valid_564406 = path.getOrDefault("fabricName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "fabricName", valid_564406
  var valid_564407 = path.getOrDefault("protectedItemName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "protectedItemName", valid_564407
  var valid_564408 = path.getOrDefault("recoveryPointId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "recoveryPointId", valid_564408
  var valid_564409 = path.getOrDefault("subscriptionId")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "subscriptionId", valid_564409
  var valid_564410 = path.getOrDefault("resourceGroupName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "resourceGroupName", valid_564410
  var valid_564411 = path.getOrDefault("containerName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "containerName", valid_564411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564412 = query.getOrDefault("api-version")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "api-version", valid_564412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_ItemLevelRecoveryConnectionsRevoke_564402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_ItemLevelRecoveryConnectionsRevoke_564402;
          vaultName: string; apiVersion: string; fabricName: string;
          protectedItemName: string; recoveryPointId: string;
          subscriptionId: string; resourceGroupName: string; containerName: string): Recallable =
  ## itemLevelRecoveryConnectionsRevoke
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be revoked for
  ## this backed up data.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  add(path_564415, "vaultName", newJString(vaultName))
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "fabricName", newJString(fabricName))
  add(path_564415, "protectedItemName", newJString(protectedItemName))
  add(path_564415, "recoveryPointId", newJString(recoveryPointId))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  add(path_564415, "containerName", newJString(containerName))
  result = call_564414.call(path_564415, query_564416, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_564402(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_564403, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_564404, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_564417 = ref object of OpenApiRestCall_563565
proc url_ProtectionContainersRefresh_564419(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRefresh_564418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   fabricName: JString (required)
  ##             : Fabric name associated the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564420 = path.getOrDefault("vaultName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "vaultName", valid_564420
  var valid_564421 = path.getOrDefault("fabricName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "fabricName", valid_564421
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
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  var valid_564425 = query.getOrDefault("$filter")
  valid_564425 = validateParameter(valid_564425, JString, required = false,
                                 default = nil)
  if valid_564425 != nil:
    section.add "$filter", valid_564425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_ProtectionContainersRefresh_564417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_ProtectionContainersRefresh_564417; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; Filter: string = ""): Recallable =
  ## protectionContainersRefresh
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name associated the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  add(path_564428, "vaultName", newJString(vaultName))
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "fabricName", newJString(fabricName))
  add(path_564428, "subscriptionId", newJString(subscriptionId))
  add(path_564428, "resourceGroupName", newJString(resourceGroupName))
  add(query_564429, "$filter", newJString(Filter))
  result = call_564427.call(path_564428, query_564429, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_564417(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_564418, base: "",
    url: url_ProtectionContainersRefresh_564419, schemes: {Scheme.Https})
type
  Call_JobCancellationsTrigger_564430 = ref object of OpenApiRestCall_563565
proc url_JobCancellationsTrigger_564432(protocol: Scheme; host: string; base: string;
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

proc validate_JobCancellationsTrigger_564431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   jobName: JString (required)
  ##          : Name of the job to cancel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564433 = path.getOrDefault("vaultName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "vaultName", valid_564433
  var valid_564434 = path.getOrDefault("subscriptionId")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "subscriptionId", valid_564434
  var valid_564435 = path.getOrDefault("resourceGroupName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "resourceGroupName", valid_564435
  var valid_564436 = path.getOrDefault("jobName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "jobName", valid_564436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564437 = query.getOrDefault("api-version")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "api-version", valid_564437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564438: Call_JobCancellationsTrigger_564430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_JobCancellationsTrigger_564430; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## jobCancellationsTrigger
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   jobName: string (required)
  ##          : Name of the job to cancel.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  add(path_564440, "vaultName", newJString(vaultName))
  add(query_564441, "api-version", newJString(apiVersion))
  add(path_564440, "subscriptionId", newJString(subscriptionId))
  add(path_564440, "resourceGroupName", newJString(resourceGroupName))
  add(path_564440, "jobName", newJString(jobName))
  result = call_564439.call(path_564440, query_564441, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_564430(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_564431, base: "",
    url: url_JobCancellationsTrigger_564432, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_564442 = ref object of OpenApiRestCall_563565
proc url_JobOperationResultsGet_564444(protocol: Scheme; host: string; base: string;
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

proc validate_JobOperationResultsGet_564443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation.
  ## the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation whose result has to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   jobName: JString (required)
  ##          : Job name whose operation result has to be fetched.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564445 = path.getOrDefault("vaultName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "vaultName", valid_564445
  var valid_564446 = path.getOrDefault("operationId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "operationId", valid_564446
  var valid_564447 = path.getOrDefault("subscriptionId")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "subscriptionId", valid_564447
  var valid_564448 = path.getOrDefault("resourceGroupName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "resourceGroupName", valid_564448
  var valid_564449 = path.getOrDefault("jobName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "jobName", valid_564449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564450 = query.getOrDefault("api-version")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "api-version", valid_564450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564451: Call_JobOperationResultsGet_564442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the result of any operation.
  ## the operation.
  ## 
  let valid = call_564451.validator(path, query, header, formData, body)
  let scheme = call_564451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564451.url(scheme.get, call_564451.host, call_564451.base,
                         call_564451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564451, url, valid)

proc call*(call_564452: Call_JobOperationResultsGet_564442; vaultName: string;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobOperationResultsGet
  ## Fetches the result of any operation.
  ## the operation.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation whose result has to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   jobName: string (required)
  ##          : Job name whose operation result has to be fetched.
  var path_564453 = newJObject()
  var query_564454 = newJObject()
  add(path_564453, "vaultName", newJString(vaultName))
  add(query_564454, "api-version", newJString(apiVersion))
  add(path_564453, "operationId", newJString(operationId))
  add(path_564453, "subscriptionId", newJString(subscriptionId))
  add(path_564453, "resourceGroupName", newJString(resourceGroupName))
  add(path_564453, "jobName", newJString(jobName))
  result = call_564452.call(path_564453, query_564454, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_564442(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_564443, base: "",
    url: url_JobOperationResultsGet_564444, schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_564455 = ref object of OpenApiRestCall_563565
proc url_BackupOperationResultsGet_564457(protocol: Scheme; host: string;
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

proc validate_BackupOperationResultsGet_564456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564458 = path.getOrDefault("vaultName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "vaultName", valid_564458
  var valid_564459 = path.getOrDefault("operationId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "operationId", valid_564459
  var valid_564460 = path.getOrDefault("subscriptionId")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "subscriptionId", valid_564460
  var valid_564461 = path.getOrDefault("resourceGroupName")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "resourceGroupName", valid_564461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564462 = query.getOrDefault("api-version")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "api-version", valid_564462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564463: Call_BackupOperationResultsGet_564455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ## 
  let valid = call_564463.validator(path, query, header, formData, body)
  let scheme = call_564463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564463.url(scheme.get, call_564463.host, call_564463.base,
                         call_564463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564463, url, valid)

proc call*(call_564464: Call_BackupOperationResultsGet_564455; vaultName: string;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## backupOperationResultsGet
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564465 = newJObject()
  var query_564466 = newJObject()
  add(path_564465, "vaultName", newJString(vaultName))
  add(query_564466, "api-version", newJString(apiVersion))
  add(path_564465, "operationId", newJString(operationId))
  add(path_564465, "subscriptionId", newJString(subscriptionId))
  add(path_564465, "resourceGroupName", newJString(resourceGroupName))
  result = call_564464.call(path_564465, query_564466, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_564455(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_564456, base: "",
    url: url_BackupOperationResultsGet_564457, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_564467 = ref object of OpenApiRestCall_563565
proc url_BackupOperationStatusesGet_564469(protocol: Scheme; host: string;
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

proc validate_BackupOperationStatusesGet_564468(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564470 = path.getOrDefault("vaultName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "vaultName", valid_564470
  var valid_564471 = path.getOrDefault("operationId")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "operationId", valid_564471
  var valid_564472 = path.getOrDefault("subscriptionId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "subscriptionId", valid_564472
  var valid_564473 = path.getOrDefault("resourceGroupName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "resourceGroupName", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564475: Call_BackupOperationStatusesGet_564467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_564475.validator(path, query, header, formData, body)
  let scheme = call_564475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564475.url(scheme.get, call_564475.host, call_564475.base,
                         call_564475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564475, url, valid)

proc call*(call_564476: Call_BackupOperationStatusesGet_564467; vaultName: string;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## backupOperationStatusesGet
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564477 = newJObject()
  var query_564478 = newJObject()
  add(path_564477, "vaultName", newJString(vaultName))
  add(query_564478, "api-version", newJString(apiVersion))
  add(path_564477, "operationId", newJString(operationId))
  add(path_564477, "subscriptionId", newJString(subscriptionId))
  add(path_564477, "resourceGroupName", newJString(resourceGroupName))
  result = call_564476.call(path_564477, query_564478, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_564467(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_564468, base: "",
    url: url_BackupOperationStatusesGet_564469, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_564491 = ref object of OpenApiRestCall_563565
proc url_ProtectionPoliciesCreateOrUpdate_564493(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesCreateOrUpdate_564492(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Backup policy to be created.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564494 = path.getOrDefault("policyName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "policyName", valid_564494
  var valid_564495 = path.getOrDefault("vaultName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "vaultName", valid_564495
  var valid_564496 = path.getOrDefault("subscriptionId")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "subscriptionId", valid_564496
  var valid_564497 = path.getOrDefault("resourceGroupName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "resourceGroupName", valid_564497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564498 = query.getOrDefault("api-version")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "api-version", valid_564498
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

proc call*(call_564500: Call_ProtectionPoliciesCreateOrUpdate_564491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ## 
  let valid = call_564500.validator(path, query, header, formData, body)
  let scheme = call_564500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564500.url(scheme.get, call_564500.host, call_564500.base,
                         call_564500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564500, url, valid)

proc call*(call_564501: Call_ProtectionPoliciesCreateOrUpdate_564491;
          policyName: string; vaultName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## protectionPoliciesCreateOrUpdate
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ##   policyName: string (required)
  ##             : Backup policy to be created.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   parameters: JObject (required)
  ##             : resource backup policy
  var path_564502 = newJObject()
  var query_564503 = newJObject()
  var body_564504 = newJObject()
  add(path_564502, "policyName", newJString(policyName))
  add(path_564502, "vaultName", newJString(vaultName))
  add(query_564503, "api-version", newJString(apiVersion))
  add(path_564502, "subscriptionId", newJString(subscriptionId))
  add(path_564502, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564504 = parameters
  result = call_564501.call(path_564502, query_564503, nil, nil, body_564504)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_564491(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_564492, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_564493, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_564479 = ref object of OpenApiRestCall_563565
proc url_ProtectionPoliciesGet_564481(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionPoliciesGet_564480(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Backup policy information to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564482 = path.getOrDefault("policyName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "policyName", valid_564482
  var valid_564483 = path.getOrDefault("vaultName")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "vaultName", valid_564483
  var valid_564484 = path.getOrDefault("subscriptionId")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "subscriptionId", valid_564484
  var valid_564485 = path.getOrDefault("resourceGroupName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "resourceGroupName", valid_564485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564486 = query.getOrDefault("api-version")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "api-version", valid_564486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564487: Call_ProtectionPoliciesGet_564479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_564487.validator(path, query, header, formData, body)
  let scheme = call_564487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564487.url(scheme.get, call_564487.host, call_564487.base,
                         call_564487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564487, url, valid)

proc call*(call_564488: Call_ProtectionPoliciesGet_564479; policyName: string;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## protectionPoliciesGet
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ##   policyName: string (required)
  ##             : Backup policy information to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564489 = newJObject()
  var query_564490 = newJObject()
  add(path_564489, "policyName", newJString(policyName))
  add(path_564489, "vaultName", newJString(vaultName))
  add(query_564490, "api-version", newJString(apiVersion))
  add(path_564489, "subscriptionId", newJString(subscriptionId))
  add(path_564489, "resourceGroupName", newJString(resourceGroupName))
  result = call_564488.call(path_564489, query_564490, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_564479(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_564480, base: "",
    url: url_ProtectionPoliciesGet_564481, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_564505 = ref object of OpenApiRestCall_563565
proc url_ProtectionPoliciesDelete_564507(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesDelete_564506(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Backup policy to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564508 = path.getOrDefault("policyName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "policyName", valid_564508
  var valid_564509 = path.getOrDefault("vaultName")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "vaultName", valid_564509
  var valid_564510 = path.getOrDefault("subscriptionId")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "subscriptionId", valid_564510
  var valid_564511 = path.getOrDefault("resourceGroupName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "resourceGroupName", valid_564511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564512 = query.getOrDefault("api-version")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "api-version", valid_564512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564513: Call_ProtectionPoliciesDelete_564505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_564513.validator(path, query, header, formData, body)
  let scheme = call_564513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564513.url(scheme.get, call_564513.host, call_564513.base,
                         call_564513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564513, url, valid)

proc call*(call_564514: Call_ProtectionPoliciesDelete_564505; policyName: string;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## protectionPoliciesDelete
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ##   policyName: string (required)
  ##             : Backup policy to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564515 = newJObject()
  var query_564516 = newJObject()
  add(path_564515, "policyName", newJString(policyName))
  add(path_564515, "vaultName", newJString(vaultName))
  add(query_564516, "api-version", newJString(apiVersion))
  add(path_564515, "subscriptionId", newJString(subscriptionId))
  add(path_564515, "resourceGroupName", newJString(resourceGroupName))
  result = call_564514.call(path_564515, query_564516, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_564505(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_564506, base: "",
    url: url_ProtectionPoliciesDelete_564507, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_564517 = ref object of OpenApiRestCall_563565
proc url_ProtectionPolicyOperationResultsGet_564519(protocol: Scheme; host: string;
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

proc validate_ProtectionPolicyOperationResultsGet_564518(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the result of an operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Backup policy name whose operation's result needs to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564520 = path.getOrDefault("policyName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "policyName", valid_564520
  var valid_564521 = path.getOrDefault("vaultName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "vaultName", valid_564521
  var valid_564522 = path.getOrDefault("operationId")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "operationId", valid_564522
  var valid_564523 = path.getOrDefault("subscriptionId")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "subscriptionId", valid_564523
  var valid_564524 = path.getOrDefault("resourceGroupName")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "resourceGroupName", valid_564524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564525 = query.getOrDefault("api-version")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "api-version", valid_564525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564526: Call_ProtectionPolicyOperationResultsGet_564517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_564526.validator(path, query, header, formData, body)
  let scheme = call_564526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564526.url(scheme.get, call_564526.host, call_564526.base,
                         call_564526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564526, url, valid)

proc call*(call_564527: Call_ProtectionPolicyOperationResultsGet_564517;
          policyName: string; vaultName: string; apiVersion: string;
          operationId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## protectionPolicyOperationResultsGet
  ## Provides the result of an operation.
  ##   policyName: string (required)
  ##             : Backup policy name whose operation's result needs to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564528 = newJObject()
  var query_564529 = newJObject()
  add(path_564528, "policyName", newJString(policyName))
  add(path_564528, "vaultName", newJString(vaultName))
  add(query_564529, "api-version", newJString(apiVersion))
  add(path_564528, "operationId", newJString(operationId))
  add(path_564528, "subscriptionId", newJString(subscriptionId))
  add(path_564528, "resourceGroupName", newJString(resourceGroupName))
  result = call_564527.call(path_564528, query_564529, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_564517(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_564518, base: "",
    url: url_ProtectionPolicyOperationResultsGet_564519, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_564530 = ref object of OpenApiRestCall_563565
proc url_ProtectionPolicyOperationStatusesGet_564532(protocol: Scheme;
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

proc validate_ProtectionPolicyOperationStatusesGet_564531(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Backup policy name whose operation's status needs to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents an operation whose status needs to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564533 = path.getOrDefault("policyName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "policyName", valid_564533
  var valid_564534 = path.getOrDefault("vaultName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "vaultName", valid_564534
  var valid_564535 = path.getOrDefault("operationId")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "operationId", valid_564535
  var valid_564536 = path.getOrDefault("subscriptionId")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "subscriptionId", valid_564536
  var valid_564537 = path.getOrDefault("resourceGroupName")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "resourceGroupName", valid_564537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564538 = query.getOrDefault("api-version")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "api-version", valid_564538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564539: Call_ProtectionPolicyOperationStatusesGet_564530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ## 
  let valid = call_564539.validator(path, query, header, formData, body)
  let scheme = call_564539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564539.url(scheme.get, call_564539.host, call_564539.base,
                         call_564539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564539, url, valid)

proc call*(call_564540: Call_ProtectionPolicyOperationStatusesGet_564530;
          policyName: string; vaultName: string; apiVersion: string;
          operationId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## protectionPolicyOperationStatusesGet
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ##   policyName: string (required)
  ##             : Backup policy name whose operation's status needs to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationId: string (required)
  ##              : Operation ID which represents an operation whose status needs to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564541 = newJObject()
  var query_564542 = newJObject()
  add(path_564541, "policyName", newJString(policyName))
  add(path_564541, "vaultName", newJString(vaultName))
  add(query_564542, "api-version", newJString(apiVersion))
  add(path_564541, "operationId", newJString(operationId))
  add(path_564541, "subscriptionId", newJString(subscriptionId))
  add(path_564541, "resourceGroupName", newJString(resourceGroupName))
  result = call_564540.call(path_564541, query_564542, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_564530(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_564531, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_564532, schemes: {Scheme.Https})
type
  Call_BackupProtectableItemsList_564543 = ref object of OpenApiRestCall_563565
proc url_BackupProtectableItemsList_564545(protocol: Scheme; host: string;
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

proc validate_BackupProtectableItemsList_564544(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564546 = path.getOrDefault("vaultName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "vaultName", valid_564546
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
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_564549 = query.getOrDefault("$skipToken")
  valid_564549 = validateParameter(valid_564549, JString, required = false,
                                 default = nil)
  if valid_564549 != nil:
    section.add "$skipToken", valid_564549
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564550 = query.getOrDefault("api-version")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "api-version", valid_564550
  var valid_564551 = query.getOrDefault("$filter")
  valid_564551 = validateParameter(valid_564551, JString, required = false,
                                 default = nil)
  if valid_564551 != nil:
    section.add "$filter", valid_564551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564552: Call_BackupProtectableItemsList_564543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ## 
  let valid = call_564552.validator(path, query, header, formData, body)
  let scheme = call_564552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564552.url(scheme.get, call_564552.host, call_564552.base,
                         call_564552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564552, url, valid)

proc call*(call_564553: Call_BackupProtectableItemsList_564543; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupProtectableItemsList
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  var path_564554 = newJObject()
  var query_564555 = newJObject()
  add(query_564555, "$skipToken", newJString(SkipToken))
  add(path_564554, "vaultName", newJString(vaultName))
  add(query_564555, "api-version", newJString(apiVersion))
  add(path_564554, "subscriptionId", newJString(subscriptionId))
  add(path_564554, "resourceGroupName", newJString(resourceGroupName))
  add(query_564555, "$filter", newJString(Filter))
  result = call_564553.call(path_564554, query_564555, nil, nil, nil)

var backupProtectableItemsList* = Call_BackupProtectableItemsList_564543(
    name: "backupProtectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_BackupProtectableItemsList_564544, base: "",
    url: url_BackupProtectableItemsList_564545, schemes: {Scheme.Https})
type
  Call_BackupProtectionContainersList_564556 = ref object of OpenApiRestCall_563565
proc url_BackupProtectionContainersList_564558(protocol: Scheme; host: string;
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

proc validate_BackupProtectionContainersList_564557(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564559 = path.getOrDefault("vaultName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "vaultName", valid_564559
  var valid_564560 = path.getOrDefault("subscriptionId")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "subscriptionId", valid_564560
  var valid_564561 = path.getOrDefault("resourceGroupName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "resourceGroupName", valid_564561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564562 = query.getOrDefault("api-version")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "api-version", valid_564562
  var valid_564563 = query.getOrDefault("$filter")
  valid_564563 = validateParameter(valid_564563, JString, required = false,
                                 default = nil)
  if valid_564563 != nil:
    section.add "$filter", valid_564563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564564: Call_BackupProtectionContainersList_564556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  let valid = call_564564.validator(path, query, header, formData, body)
  let scheme = call_564564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564564.url(scheme.get, call_564564.host, call_564564.base,
                         call_564564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564564, url, valid)

proc call*(call_564565: Call_BackupProtectionContainersList_564556;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; Filter: string = ""): Recallable =
  ## backupProtectionContainersList
  ## Lists the containers registered to Recovery Services Vault.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  var path_564566 = newJObject()
  var query_564567 = newJObject()
  add(path_564566, "vaultName", newJString(vaultName))
  add(query_564567, "api-version", newJString(apiVersion))
  add(path_564566, "subscriptionId", newJString(subscriptionId))
  add(path_564566, "resourceGroupName", newJString(resourceGroupName))
  add(query_564567, "$filter", newJString(Filter))
  result = call_564565.call(path_564566, query_564567, nil, nil, nil)

var backupProtectionContainersList* = Call_BackupProtectionContainersList_564556(
    name: "backupProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_BackupProtectionContainersList_564557, base: "",
    url: url_BackupProtectionContainersList_564558, schemes: {Scheme.Https})
type
  Call_SecurityPINsGet_564568 = ref object of OpenApiRestCall_563565
proc url_SecurityPINsGet_564570(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityPINsGet_564569(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the security PIN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564571 = path.getOrDefault("vaultName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "vaultName", valid_564571
  var valid_564572 = path.getOrDefault("subscriptionId")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "subscriptionId", valid_564572
  var valid_564573 = path.getOrDefault("resourceGroupName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "resourceGroupName", valid_564573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564574 = query.getOrDefault("api-version")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "api-version", valid_564574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_SecurityPINsGet_564568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security PIN.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_SecurityPINsGet_564568; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## securityPINsGet
  ## Get the security PIN.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  add(path_564577, "vaultName", newJString(vaultName))
  add(query_564578, "api-version", newJString(apiVersion))
  add(path_564577, "subscriptionId", newJString(subscriptionId))
  add(path_564577, "resourceGroupName", newJString(resourceGroupName))
  result = call_564576.call(path_564577, query_564578, nil, nil, nil)

var securityPINsGet* = Call_SecurityPINsGet_564568(name: "securityPINsGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupSecurityPIN",
    validator: validate_SecurityPINsGet_564569, base: "", url: url_SecurityPINsGet_564570,
    schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsGet_564579 = ref object of OpenApiRestCall_563565
proc url_BackupResourceVaultConfigsGet_564581(protocol: Scheme; host: string;
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

proc validate_BackupResourceVaultConfigsGet_564580(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches resource vault config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564582 = path.getOrDefault("vaultName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "vaultName", valid_564582
  var valid_564583 = path.getOrDefault("subscriptionId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "subscriptionId", valid_564583
  var valid_564584 = path.getOrDefault("resourceGroupName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "resourceGroupName", valid_564584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564586: Call_BackupResourceVaultConfigsGet_564579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches resource vault config.
  ## 
  let valid = call_564586.validator(path, query, header, formData, body)
  let scheme = call_564586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564586.url(scheme.get, call_564586.host, call_564586.base,
                         call_564586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564586, url, valid)

proc call*(call_564587: Call_BackupResourceVaultConfigsGet_564579;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## backupResourceVaultConfigsGet
  ## Fetches resource vault config.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564588 = newJObject()
  var query_564589 = newJObject()
  add(path_564588, "vaultName", newJString(vaultName))
  add(query_564589, "api-version", newJString(apiVersion))
  add(path_564588, "subscriptionId", newJString(subscriptionId))
  add(path_564588, "resourceGroupName", newJString(resourceGroupName))
  result = call_564587.call(path_564588, query_564589, nil, nil, nil)

var backupResourceVaultConfigsGet* = Call_BackupResourceVaultConfigsGet_564579(
    name: "backupResourceVaultConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsGet_564580, base: "",
    url: url_BackupResourceVaultConfigsGet_564581, schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsUpdate_564590 = ref object of OpenApiRestCall_563565
proc url_BackupResourceVaultConfigsUpdate_564592(protocol: Scheme; host: string;
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

proc validate_BackupResourceVaultConfigsUpdate_564591(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault security config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564593 = path.getOrDefault("vaultName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "vaultName", valid_564593
  var valid_564594 = path.getOrDefault("subscriptionId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "subscriptionId", valid_564594
  var valid_564595 = path.getOrDefault("resourceGroupName")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "resourceGroupName", valid_564595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564596 = query.getOrDefault("api-version")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "api-version", valid_564596
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

proc call*(call_564598: Call_BackupResourceVaultConfigsUpdate_564590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault security config.
  ## 
  let valid = call_564598.validator(path, query, header, formData, body)
  let scheme = call_564598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564598.url(scheme.get, call_564598.host, call_564598.base,
                         call_564598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564598, url, valid)

proc call*(call_564599: Call_BackupResourceVaultConfigsUpdate_564590;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## backupResourceVaultConfigsUpdate
  ## Updates vault security config.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   parameters: JObject (required)
  ##             : resource config request
  var path_564600 = newJObject()
  var query_564601 = newJObject()
  var body_564602 = newJObject()
  add(path_564600, "vaultName", newJString(vaultName))
  add(query_564601, "api-version", newJString(apiVersion))
  add(path_564600, "subscriptionId", newJString(subscriptionId))
  add(path_564600, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564602 = parameters
  result = call_564599.call(path_564600, query_564601, nil, nil, body_564602)

var backupResourceVaultConfigsUpdate* = Call_BackupResourceVaultConfigsUpdate_564590(
    name: "backupResourceVaultConfigsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsUpdate_564591, base: "",
    url: url_BackupResourceVaultConfigsUpdate_564592, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsUpdate_564614 = ref object of OpenApiRestCall_563565
proc url_BackupResourceStorageConfigsUpdate_564616(protocol: Scheme; host: string;
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

proc validate_BackupResourceStorageConfigsUpdate_564615(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault storage model type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564617 = path.getOrDefault("vaultName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "vaultName", valid_564617
  var valid_564618 = path.getOrDefault("subscriptionId")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "subscriptionId", valid_564618
  var valid_564619 = path.getOrDefault("resourceGroupName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "resourceGroupName", valid_564619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564620 = query.getOrDefault("api-version")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "api-version", valid_564620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564622: Call_BackupResourceStorageConfigsUpdate_564614;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_564622.validator(path, query, header, formData, body)
  let scheme = call_564622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564622.url(scheme.get, call_564622.host, call_564622.base,
                         call_564622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564622, url, valid)

proc call*(call_564623: Call_BackupResourceStorageConfigsUpdate_564614;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## backupResourceStorageConfigsUpdate
  ## Updates vault storage model type.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  var path_564624 = newJObject()
  var query_564625 = newJObject()
  var body_564626 = newJObject()
  add(path_564624, "vaultName", newJString(vaultName))
  add(query_564625, "api-version", newJString(apiVersion))
  add(path_564624, "subscriptionId", newJString(subscriptionId))
  add(path_564624, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564626 = parameters
  result = call_564623.call(path_564624, query_564625, nil, nil, body_564626)

var backupResourceStorageConfigsUpdate* = Call_BackupResourceStorageConfigsUpdate_564614(
    name: "backupResourceStorageConfigsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsUpdate_564615, base: "",
    url: url_BackupResourceStorageConfigsUpdate_564616, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsGet_564603 = ref object of OpenApiRestCall_563565
proc url_BackupResourceStorageConfigsGet_564605(protocol: Scheme; host: string;
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

proc validate_BackupResourceStorageConfigsGet_564604(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches resource storage config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564606 = path.getOrDefault("vaultName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "vaultName", valid_564606
  var valid_564607 = path.getOrDefault("subscriptionId")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "subscriptionId", valid_564607
  var valid_564608 = path.getOrDefault("resourceGroupName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "resourceGroupName", valid_564608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "api-version", valid_564609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564610: Call_BackupResourceStorageConfigsGet_564603;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches resource storage config.
  ## 
  let valid = call_564610.validator(path, query, header, formData, body)
  let scheme = call_564610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564610.url(scheme.get, call_564610.host, call_564610.base,
                         call_564610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564610, url, valid)

proc call*(call_564611: Call_BackupResourceStorageConfigsGet_564603;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## backupResourceStorageConfigsGet
  ## Fetches resource storage config.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564612 = newJObject()
  var query_564613 = newJObject()
  add(path_564612, "vaultName", newJString(vaultName))
  add(query_564613, "api-version", newJString(apiVersion))
  add(path_564612, "subscriptionId", newJString(subscriptionId))
  add(path_564612, "resourceGroupName", newJString(resourceGroupName))
  result = call_564611.call(path_564612, query_564613, nil, nil, nil)

var backupResourceStorageConfigsGet* = Call_BackupResourceStorageConfigsGet_564603(
    name: "backupResourceStorageConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsGet_564604, base: "",
    url: url_BackupResourceStorageConfigsGet_564605, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsPatch_564627 = ref object of OpenApiRestCall_563565
proc url_BackupResourceStorageConfigsPatch_564629(protocol: Scheme; host: string;
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

proc validate_BackupResourceStorageConfigsPatch_564628(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault storage model type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564630 = path.getOrDefault("vaultName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "vaultName", valid_564630
  var valid_564631 = path.getOrDefault("subscriptionId")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "subscriptionId", valid_564631
  var valid_564632 = path.getOrDefault("resourceGroupName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "resourceGroupName", valid_564632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564633 = query.getOrDefault("api-version")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "api-version", valid_564633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564635: Call_BackupResourceStorageConfigsPatch_564627;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_564635.validator(path, query, header, formData, body)
  let scheme = call_564635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564635.url(scheme.get, call_564635.host, call_564635.base,
                         call_564635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564635, url, valid)

proc call*(call_564636: Call_BackupResourceStorageConfigsPatch_564627;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## backupResourceStorageConfigsPatch
  ## Updates vault storage model type.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  var path_564637 = newJObject()
  var query_564638 = newJObject()
  var body_564639 = newJObject()
  add(path_564637, "vaultName", newJString(vaultName))
  add(query_564638, "api-version", newJString(apiVersion))
  add(path_564637, "subscriptionId", newJString(subscriptionId))
  add(path_564637, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564639 = parameters
  result = call_564636.call(path_564637, query_564638, nil, nil, body_564639)

var backupResourceStorageConfigsPatch* = Call_BackupResourceStorageConfigsPatch_564627(
    name: "backupResourceStorageConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsPatch_564628, base: "",
    url: url_BackupResourceStorageConfigsPatch_564629, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
