
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesBackupClient
## version: 2017-07-01
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
  macServiceName = "recoveryservicesbackup-bms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProtectionIntentValidate_567889 = ref object of OpenApiRestCall_567667
proc url_ProtectionIntentValidate_567891(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "azureRegion" in path, "`azureRegion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/locations/"),
               (kind: VariableSegment, value: "azureRegion"),
               (kind: ConstantSegment, value: "/backupPreValidateProtection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionIntentValidate_567890(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   azureRegion: JString (required)
  ##              : Azure region to hit Api
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568064 = path.getOrDefault("subscriptionId")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = nil)
  if valid_568064 != nil:
    section.add "subscriptionId", valid_568064
  var valid_568065 = path.getOrDefault("azureRegion")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "azureRegion", valid_568065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568066 = query.getOrDefault("api-version")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "api-version", valid_568066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Enable backup validation request on Virtual Machine
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568090: Call_ProtectionIntentValidate_567889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568090.validator(path, query, header, formData, body)
  let scheme = call_568090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568090.url(scheme.get, call_568090.host, call_568090.base,
                         call_568090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568090, url, valid)

proc call*(call_568161: Call_ProtectionIntentValidate_567889; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; azureRegion: string): Recallable =
  ## protectionIntentValidate
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   parameters: JObject (required)
  ##             : Enable backup validation request on Virtual Machine
  ##   azureRegion: string (required)
  ##              : Azure region to hit Api
  var path_568162 = newJObject()
  var query_568164 = newJObject()
  var body_568165 = newJObject()
  add(query_568164, "api-version", newJString(apiVersion))
  add(path_568162, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568165 = parameters
  add(path_568162, "azureRegion", newJString(azureRegion))
  result = call_568161.call(path_568162, query_568164, nil, nil, body_568165)

var protectionIntentValidate* = Call_ProtectionIntentValidate_567889(
    name: "protectionIntentValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/locations/{azureRegion}/backupPreValidateProtection",
    validator: validate_ProtectionIntentValidate_567890, base: "",
    url: url_ProtectionIntentValidate_567891, schemes: {Scheme.Https})
type
  Call_BackupStatusGet_568204 = ref object of OpenApiRestCall_567667
proc url_BackupStatusGet_568206(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "azureRegion" in path, "`azureRegion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/locations/"),
               (kind: VariableSegment, value: "azureRegion"),
               (kind: ConstantSegment, value: "/backupStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupStatusGet_568205(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   azureRegion: JString (required)
  ##              : Azure region to hit Api
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  var valid_568208 = path.getOrDefault("azureRegion")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "azureRegion", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Container Backup Status Request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_BackupStatusGet_568204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_BackupStatusGet_568204; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; azureRegion: string): Recallable =
  ## backupStatusGet
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   parameters: JObject (required)
  ##             : Container Backup Status Request
  ##   azureRegion: string (required)
  ##              : Azure region to hit Api
  var path_568213 = newJObject()
  var query_568214 = newJObject()
  var body_568215 = newJObject()
  add(query_568214, "api-version", newJString(apiVersion))
  add(path_568213, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568215 = parameters
  add(path_568213, "azureRegion", newJString(azureRegion))
  result = call_568212.call(path_568213, query_568214, nil, nil, body_568215)

var backupStatusGet* = Call_BackupStatusGet_568204(name: "backupStatusGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/locations/{azureRegion}/backupStatus",
    validator: validate_BackupStatusGet_568205, base: "", url: url_BackupStatusGet_568206,
    schemes: {Scheme.Https})
type
  Call_FeatureSupportValidate_568216 = ref object of OpenApiRestCall_567667
proc url_FeatureSupportValidate_568218(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "azureRegion" in path, "`azureRegion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/locations/"),
               (kind: VariableSegment, value: "azureRegion"),
               (kind: ConstantSegment, value: "/backupValidateFeatures")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeatureSupportValidate_568217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   azureRegion: JString (required)
  ##              : Azure region to hit Api
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("azureRegion")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "azureRegion", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Feature support request object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_FeatureSupportValidate_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_FeatureSupportValidate_568216; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; azureRegion: string): Recallable =
  ## featureSupportValidate
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   parameters: JObject (required)
  ##             : Feature support request object
  ##   azureRegion: string (required)
  ##              : Azure region to hit Api
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568227 = parameters
  add(path_568225, "azureRegion", newJString(azureRegion))
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var featureSupportValidate* = Call_FeatureSupportValidate_568216(
    name: "featureSupportValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/locations/{azureRegion}/backupValidateFeatures",
    validator: validate_FeatureSupportValidate_568217, base: "",
    url: url_FeatureSupportValidate_568218, schemes: {Scheme.Https})
type
  Call_ProtectionIntentCreateOrUpdate_568241 = ref object of OpenApiRestCall_567667
proc url_ProtectionIntentCreateOrUpdate_568243(protocol: Scheme; host: string;
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
  assert "intentObjectName" in path,
        "`intentObjectName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/backupProtectionIntent/"),
               (kind: VariableSegment, value: "intentObjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionIntentCreateOrUpdate_568242(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Intent for Enabling backup of an item. This is a synchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   intentObjectName: JString (required)
  ##                   : Intent object name.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568261 = path.getOrDefault("fabricName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "fabricName", valid_568261
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("intentObjectName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "intentObjectName", valid_568264
  var valid_568265 = path.getOrDefault("vaultName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "vaultName", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
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

proc call*(call_568268: Call_ProtectionIntentCreateOrUpdate_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Intent for Enabling backup of an item. This is a synchronous operation.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_ProtectionIntentCreateOrUpdate_568241;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; intentObjectName: string; vaultName: string;
          parameters: JsonNode): Recallable =
  ## protectionIntentCreateOrUpdate
  ## Create Intent for Enabling backup of an item. This is a synchronous operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   intentObjectName: string (required)
  ##                   : Intent object name.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backed up item
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(path_568270, "fabricName", newJString(fabricName))
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(path_568270, "intentObjectName", newJString(intentObjectName))
  add(path_568270, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568272 = parameters
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var protectionIntentCreateOrUpdate* = Call_ProtectionIntentCreateOrUpdate_568241(
    name: "protectionIntentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/backupProtectionIntent/{intentObjectName}",
    validator: validate_ProtectionIntentCreateOrUpdate_568242, base: "",
    url: url_ProtectionIntentCreateOrUpdate_568243, schemes: {Scheme.Https})
type
  Call_ProtectionIntentGet_568228 = ref object of OpenApiRestCall_567667
proc url_ProtectionIntentGet_568230(protocol: Scheme; host: string; base: string;
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
  assert "intentObjectName" in path,
        "`intentObjectName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/backupProtectionIntent/"),
               (kind: VariableSegment, value: "intentObjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionIntentGet_568229(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Provides the details of the protection intent up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   intentObjectName: JString (required)
  ##                   : Backed up item name whose details are to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568231 = path.getOrDefault("fabricName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "fabricName", valid_568231
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("intentObjectName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "intentObjectName", valid_568234
  var valid_568235 = path.getOrDefault("vaultName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "vaultName", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_ProtectionIntentGet_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the protection intent up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_ProtectionIntentGet_568228; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          intentObjectName: string; vaultName: string): Recallable =
  ## protectionIntentGet
  ## Provides the details of the protection intent up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   intentObjectName: string (required)
  ##                   : Backed up item name whose details are to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(path_568239, "fabricName", newJString(fabricName))
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  add(path_568239, "intentObjectName", newJString(intentObjectName))
  add(path_568239, "vaultName", newJString(vaultName))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var protectionIntentGet* = Call_ProtectionIntentGet_568228(
    name: "protectionIntentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/backupProtectionIntent/{intentObjectName}",
    validator: validate_ProtectionIntentGet_568229, base: "",
    url: url_ProtectionIntentGet_568230, schemes: {Scheme.Https})
type
  Call_ProtectionIntentDelete_568273 = ref object of OpenApiRestCall_567667
proc url_ProtectionIntentDelete_568275(protocol: Scheme; host: string; base: string;
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
  assert "intentObjectName" in path,
        "`intentObjectName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/backupProtectionIntent/"),
               (kind: VariableSegment, value: "intentObjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionIntentDelete_568274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to remove intent from an item
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the intent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   intentObjectName: JString (required)
  ##                   : Intent to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568276 = path.getOrDefault("fabricName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "fabricName", valid_568276
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("intentObjectName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "intentObjectName", valid_568279
  var valid_568280 = path.getOrDefault("vaultName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "vaultName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568282: Call_ProtectionIntentDelete_568273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to remove intent from an item
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_ProtectionIntentDelete_568273; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          intentObjectName: string; vaultName: string): Recallable =
  ## protectionIntentDelete
  ## Used to remove intent from an item
  ##   fabricName: string (required)
  ##             : Fabric name associated with the intent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   intentObjectName: string (required)
  ##                   : Intent to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  add(path_568284, "fabricName", newJString(fabricName))
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(path_568284, "intentObjectName", newJString(intentObjectName))
  add(path_568284, "vaultName", newJString(vaultName))
  result = call_568283.call(path_568284, query_568285, nil, nil, nil)

var protectionIntentDelete* = Call_ProtectionIntentDelete_568273(
    name: "protectionIntentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/backupProtectionIntent/{intentObjectName}",
    validator: validate_ProtectionIntentDelete_568274, base: "",
    url: url_ProtectionIntentDelete_568275, schemes: {Scheme.Https})
type
  Call_BackupJobsList_568286 = ref object of OpenApiRestCall_567667
proc url_BackupJobsList_568288(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backupJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupJobsList_568287(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Provides a pageable list of jobs.
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
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("vaultName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "vaultName", valid_568292
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
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  var valid_568294 = query.getOrDefault("$skipToken")
  valid_568294 = validateParameter(valid_568294, JString, required = false,
                                 default = nil)
  if valid_568294 != nil:
    section.add "$skipToken", valid_568294
  var valid_568295 = query.getOrDefault("$filter")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "$filter", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_BackupJobsList_568286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of jobs.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_BackupJobsList_568286; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupJobsList
  ## Provides a pageable list of jobs.
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
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "vaultName", newJString(vaultName))
  add(query_568299, "$skipToken", newJString(SkipToken))
  add(query_568299, "$filter", newJString(Filter))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var backupJobsList* = Call_BackupJobsList_568286(name: "backupJobsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs",
    validator: validate_BackupJobsList_568287, base: "", url: url_BackupJobsList_568288,
    schemes: {Scheme.Https})
type
  Call_ExportJobsOperationResultsGet_568300 = ref object of OpenApiRestCall_567667
proc url_ExportJobsOperationResultsGet_568302(protocol: Scheme; host: string;
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

proc validate_ExportJobsOperationResultsGet_568301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also
  ## contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
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
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("vaultName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "vaultName", valid_568305
  var valid_568306 = path.getOrDefault("operationId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "operationId", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568307 = query.getOrDefault("api-version")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "api-version", valid_568307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_ExportJobsOperationResultsGet_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also
  ## contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_ExportJobsOperationResultsGet_568300;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## exportJobsOperationResultsGet
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also
  ## contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
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
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(path_568310, "vaultName", newJString(vaultName))
  add(path_568310, "operationId", newJString(operationId))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var exportJobsOperationResultsGet* = Call_ExportJobsOperationResultsGet_568300(
    name: "exportJobsOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/operationResults/{operationId}",
    validator: validate_ExportJobsOperationResultsGet_568301, base: "",
    url: url_ExportJobsOperationResultsGet_568302, schemes: {Scheme.Https})
type
  Call_JobDetailsGet_568312 = ref object of OpenApiRestCall_567667
proc url_JobDetailsGet_568314(protocol: Scheme; host: string; base: string;
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

proc validate_JobDetailsGet_568313(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets extended information associated with the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Name of the job whose details are to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
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
  var valid_568317 = path.getOrDefault("jobName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "jobName", valid_568317
  var valid_568318 = path.getOrDefault("vaultName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "vaultName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568320: Call_JobDetailsGet_568312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets extended information associated with the job.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_JobDetailsGet_568312; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          vaultName: string): Recallable =
  ## jobDetailsGet
  ## Gets extended information associated with the job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Name of the job whose details are to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "jobName", newJString(jobName))
  add(path_568322, "vaultName", newJString(vaultName))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var jobDetailsGet* = Call_JobDetailsGet_568312(name: "jobDetailsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}",
    validator: validate_JobDetailsGet_568313, base: "", url: url_JobDetailsGet_568314,
    schemes: {Scheme.Https})
type
  Call_JobsExport_568324 = ref object of OpenApiRestCall_567667
proc url_JobsExport_568326(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsExport_568325(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  var valid_568331 = query.getOrDefault("$filter")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "$filter", valid_568331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_JobsExport_568324; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers export of jobs specified by filters and returns an OperationID to track.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_JobsExport_568324; resourceGroupName: string;
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
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "vaultName", newJString(vaultName))
  add(query_568335, "$filter", newJString(Filter))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var jobsExport* = Call_JobsExport_568324(name: "jobsExport",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobsExport",
                                      validator: validate_JobsExport_568325,
                                      base: "", url: url_JobsExport_568326,
                                      schemes: {Scheme.Https})
type
  Call_BackupPoliciesList_568336 = ref object of OpenApiRestCall_567667
proc url_BackupPoliciesList_568338(protocol: Scheme; host: string; base: string;
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

proc validate_BackupPoliciesList_568337(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch
  ## scoped results.
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
  var valid_568341 = path.getOrDefault("vaultName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "vaultName", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  var valid_568343 = query.getOrDefault("$filter")
  valid_568343 = validateParameter(valid_568343, JString, required = false,
                                 default = nil)
  if valid_568343 != nil:
    section.add "$filter", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_BackupPoliciesList_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch
  ## scoped results.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_BackupPoliciesList_568336; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## backupPoliciesList
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch
  ## scoped results.
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
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  add(path_568346, "vaultName", newJString(vaultName))
  add(query_568347, "$filter", newJString(Filter))
  result = call_568345.call(path_568346, query_568347, nil, nil, nil)

var backupPoliciesList* = Call_BackupPoliciesList_568336(
    name: "backupPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies",
    validator: validate_BackupPoliciesList_568337, base: "",
    url: url_BackupPoliciesList_568338, schemes: {Scheme.Https})
type
  Call_BackupProtectedItemsList_568348 = ref object of OpenApiRestCall_567667
proc url_BackupProtectedItemsList_568350(protocol: Scheme; host: string;
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

proc validate_BackupProtectedItemsList_568349(path: JsonNode; query: JsonNode;
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
  var valid_568351 = path.getOrDefault("resourceGroupName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceGroupName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  var valid_568353 = path.getOrDefault("vaultName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "vaultName", valid_568353
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
  var valid_568354 = query.getOrDefault("api-version")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "api-version", valid_568354
  var valid_568355 = query.getOrDefault("$skipToken")
  valid_568355 = validateParameter(valid_568355, JString, required = false,
                                 default = nil)
  if valid_568355 != nil:
    section.add "$skipToken", valid_568355
  var valid_568356 = query.getOrDefault("$filter")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "$filter", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_BackupProtectedItemsList_568348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all items that are backed up within a vault.
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_BackupProtectedItemsList_568348;
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
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  add(path_568359, "vaultName", newJString(vaultName))
  add(query_568360, "$skipToken", newJString(SkipToken))
  add(query_568360, "$filter", newJString(Filter))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var backupProtectedItemsList* = Call_BackupProtectedItemsList_568348(
    name: "backupProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectedItems",
    validator: validate_BackupProtectedItemsList_568349, base: "",
    url: url_BackupProtectedItemsList_568350, schemes: {Scheme.Https})
type
  Call_BackupProtectionIntentList_568361 = ref object of OpenApiRestCall_567667
proc url_BackupProtectionIntentList_568363(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/backupProtectionIntents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupProtectionIntentList_568362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of all intents that are present within a vault.
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
  var valid_568366 = path.getOrDefault("vaultName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "vaultName", valid_568366
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
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  var valid_568368 = query.getOrDefault("$skipToken")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "$skipToken", valid_568368
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

proc call*(call_568370: Call_BackupProtectionIntentList_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all intents that are present within a vault.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_BackupProtectionIntentList_568361;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupProtectionIntentList
  ## Provides a pageable list of all intents that are present within a vault.
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
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "vaultName", newJString(vaultName))
  add(query_568373, "$skipToken", newJString(SkipToken))
  add(query_568373, "$filter", newJString(Filter))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var backupProtectionIntentList* = Call_BackupProtectionIntentList_568361(
    name: "backupProtectionIntentList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionIntents",
    validator: validate_BackupProtectionIntentList_568362, base: "",
    url: url_BackupProtectionIntentList_568363, schemes: {Scheme.Https})
type
  Call_BackupUsageSummariesList_568374 = ref object of OpenApiRestCall_567667
proc url_BackupUsageSummariesList_568376(protocol: Scheme; host: string;
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

proc validate_BackupUsageSummariesList_568375(path: JsonNode; query: JsonNode;
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
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  var valid_568379 = path.getOrDefault("vaultName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "vaultName", valid_568379
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
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  var valid_568381 = query.getOrDefault("$skipToken")
  valid_568381 = validateParameter(valid_568381, JString, required = false,
                                 default = nil)
  if valid_568381 != nil:
    section.add "$skipToken", valid_568381
  var valid_568382 = query.getOrDefault("$filter")
  valid_568382 = validateParameter(valid_568382, JString, required = false,
                                 default = nil)
  if valid_568382 != nil:
    section.add "$filter", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_BackupUsageSummariesList_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the backup management usage summaries of the vault.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_BackupUsageSummariesList_568374;
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
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  add(path_568385, "vaultName", newJString(vaultName))
  add(query_568386, "$skipToken", newJString(SkipToken))
  add(query_568386, "$filter", newJString(Filter))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var backupUsageSummariesList* = Call_BackupUsageSummariesList_568374(
    name: "backupUsageSummariesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupUsageSummaries",
    validator: validate_BackupUsageSummariesList_568375, base: "",
    url: url_BackupUsageSummariesList_568376, schemes: {Scheme.Https})
type
  Call_OperationValidate_568387 = ref object of OpenApiRestCall_567667
proc url_OperationValidate_568389(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backupValidateOperation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationValidate_568388(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Validate operation for specified backed up item. This is a synchronous operation.
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
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  var valid_568392 = path.getOrDefault("vaultName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "vaultName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource validate operation request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568395: Call_OperationValidate_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate operation for specified backed up item. This is a synchronous operation.
  ## 
  let valid = call_568395.validator(path, query, header, formData, body)
  let scheme = call_568395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568395.url(scheme.get, call_568395.host, call_568395.base,
                         call_568395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568395, url, valid)

proc call*(call_568396: Call_OperationValidate_568387; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          parameters: JsonNode): Recallable =
  ## operationValidate
  ## Validate operation for specified backed up item. This is a synchronous operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource validate operation request
  var path_568397 = newJObject()
  var query_568398 = newJObject()
  var body_568399 = newJObject()
  add(path_568397, "resourceGroupName", newJString(resourceGroupName))
  add(query_568398, "api-version", newJString(apiVersion))
  add(path_568397, "subscriptionId", newJString(subscriptionId))
  add(path_568397, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568399 = parameters
  result = call_568396.call(path_568397, query_568398, nil, nil, body_568399)

var operationValidate* = Call_OperationValidate_568387(name: "operationValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupValidateOperation",
    validator: validate_OperationValidate_568388, base: "",
    url: url_OperationValidate_568389, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
