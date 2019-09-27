
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_ProtectionIntentValidate_593660 = ref object of OpenApiRestCall_593438
proc url_ProtectionIntentValidate_593662(protocol: Scheme; host: string;
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

proc validate_ProtectionIntentValidate_593661(path: JsonNode; query: JsonNode;
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
  var valid_593835 = path.getOrDefault("subscriptionId")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = nil)
  if valid_593835 != nil:
    section.add "subscriptionId", valid_593835
  var valid_593836 = path.getOrDefault("azureRegion")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "azureRegion", valid_593836
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593837 = query.getOrDefault("api-version")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "api-version", valid_593837
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

proc call*(call_593861: Call_ProtectionIntentValidate_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593861.validator(path, query, header, formData, body)
  let scheme = call_593861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593861.url(scheme.get, call_593861.host, call_593861.base,
                         call_593861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593861, url, valid)

proc call*(call_593932: Call_ProtectionIntentValidate_593660; apiVersion: string;
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
  var path_593933 = newJObject()
  var query_593935 = newJObject()
  var body_593936 = newJObject()
  add(query_593935, "api-version", newJString(apiVersion))
  add(path_593933, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593936 = parameters
  add(path_593933, "azureRegion", newJString(azureRegion))
  result = call_593932.call(path_593933, query_593935, nil, nil, body_593936)

var protectionIntentValidate* = Call_ProtectionIntentValidate_593660(
    name: "protectionIntentValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/locations/{azureRegion}/backupPreValidateProtection",
    validator: validate_ProtectionIntentValidate_593661, base: "",
    url: url_ProtectionIntentValidate_593662, schemes: {Scheme.Https})
type
  Call_BackupStatusGet_593975 = ref object of OpenApiRestCall_593438
proc url_BackupStatusGet_593977(protocol: Scheme; host: string; base: string;
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

proc validate_BackupStatusGet_593976(path: JsonNode; query: JsonNode;
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
  var valid_593978 = path.getOrDefault("subscriptionId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "subscriptionId", valid_593978
  var valid_593979 = path.getOrDefault("azureRegion")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "azureRegion", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
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

proc call*(call_593982: Call_BackupStatusGet_593975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_BackupStatusGet_593975; apiVersion: string;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  var body_593986 = newJObject()
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593986 = parameters
  add(path_593984, "azureRegion", newJString(azureRegion))
  result = call_593983.call(path_593984, query_593985, nil, nil, body_593986)

var backupStatusGet* = Call_BackupStatusGet_593975(name: "backupStatusGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/locations/{azureRegion}/backupStatus",
    validator: validate_BackupStatusGet_593976, base: "", url: url_BackupStatusGet_593977,
    schemes: {Scheme.Https})
type
  Call_FeatureSupportValidate_593987 = ref object of OpenApiRestCall_593438
proc url_FeatureSupportValidate_593989(protocol: Scheme; host: string; base: string;
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

proc validate_FeatureSupportValidate_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  var valid_593991 = path.getOrDefault("azureRegion")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "azureRegion", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
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

proc call*(call_593994: Call_FeatureSupportValidate_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_FeatureSupportValidate_593987; apiVersion: string;
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
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  var body_593998 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593998 = parameters
  add(path_593996, "azureRegion", newJString(azureRegion))
  result = call_593995.call(path_593996, query_593997, nil, nil, body_593998)

var featureSupportValidate* = Call_FeatureSupportValidate_593987(
    name: "featureSupportValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/locations/{azureRegion}/backupValidateFeatures",
    validator: validate_FeatureSupportValidate_593988, base: "",
    url: url_FeatureSupportValidate_593989, schemes: {Scheme.Https})
type
  Call_ProtectionIntentCreateOrUpdate_594012 = ref object of OpenApiRestCall_593438
proc url_ProtectionIntentCreateOrUpdate_594014(protocol: Scheme; host: string;
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

proc validate_ProtectionIntentCreateOrUpdate_594013(path: JsonNode;
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
  var valid_594032 = path.getOrDefault("fabricName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "fabricName", valid_594032
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("intentObjectName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "intentObjectName", valid_594035
  var valid_594036 = path.getOrDefault("vaultName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "vaultName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
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

proc call*(call_594039: Call_ProtectionIntentCreateOrUpdate_594012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Intent for Enabling backup of an item. This is a synchronous operation.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_ProtectionIntentCreateOrUpdate_594012;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  var body_594043 = newJObject()
  add(path_594041, "fabricName", newJString(fabricName))
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  add(path_594041, "intentObjectName", newJString(intentObjectName))
  add(path_594041, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594043 = parameters
  result = call_594040.call(path_594041, query_594042, nil, nil, body_594043)

var protectionIntentCreateOrUpdate* = Call_ProtectionIntentCreateOrUpdate_594012(
    name: "protectionIntentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/backupProtectionIntent/{intentObjectName}",
    validator: validate_ProtectionIntentCreateOrUpdate_594013, base: "",
    url: url_ProtectionIntentCreateOrUpdate_594014, schemes: {Scheme.Https})
type
  Call_ProtectionIntentGet_593999 = ref object of OpenApiRestCall_593438
proc url_ProtectionIntentGet_594001(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionIntentGet_594000(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("fabricName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fabricName", valid_594002
  var valid_594003 = path.getOrDefault("resourceGroupName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "resourceGroupName", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("intentObjectName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "intentObjectName", valid_594005
  var valid_594006 = path.getOrDefault("vaultName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "vaultName", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_ProtectionIntentGet_593999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the protection intent up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_ProtectionIntentGet_593999; fabricName: string;
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(path_594010, "fabricName", newJString(fabricName))
  add(path_594010, "resourceGroupName", newJString(resourceGroupName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  add(path_594010, "intentObjectName", newJString(intentObjectName))
  add(path_594010, "vaultName", newJString(vaultName))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var protectionIntentGet* = Call_ProtectionIntentGet_593999(
    name: "protectionIntentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/backupProtectionIntent/{intentObjectName}",
    validator: validate_ProtectionIntentGet_594000, base: "",
    url: url_ProtectionIntentGet_594001, schemes: {Scheme.Https})
type
  Call_ProtectionIntentDelete_594044 = ref object of OpenApiRestCall_593438
proc url_ProtectionIntentDelete_594046(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionIntentDelete_594045(path: JsonNode; query: JsonNode;
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
  var valid_594047 = path.getOrDefault("fabricName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "fabricName", valid_594047
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("intentObjectName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "intentObjectName", valid_594050
  var valid_594051 = path.getOrDefault("vaultName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "vaultName", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_ProtectionIntentDelete_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to remove intent from an item
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_ProtectionIntentDelete_594044; fabricName: string;
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
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(path_594055, "fabricName", newJString(fabricName))
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  add(path_594055, "intentObjectName", newJString(intentObjectName))
  add(path_594055, "vaultName", newJString(vaultName))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var protectionIntentDelete* = Call_ProtectionIntentDelete_594044(
    name: "protectionIntentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/backupProtectionIntent/{intentObjectName}",
    validator: validate_ProtectionIntentDelete_594045, base: "",
    url: url_ProtectionIntentDelete_594046, schemes: {Scheme.Https})
type
  Call_BackupJobsList_594057 = ref object of OpenApiRestCall_593438
proc url_BackupJobsList_594059(protocol: Scheme; host: string; base: string;
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

proc validate_BackupJobsList_594058(path: JsonNode; query: JsonNode;
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
  var valid_594061 = path.getOrDefault("resourceGroupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "resourceGroupName", valid_594061
  var valid_594062 = path.getOrDefault("subscriptionId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "subscriptionId", valid_594062
  var valid_594063 = path.getOrDefault("vaultName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "vaultName", valid_594063
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
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  var valid_594065 = query.getOrDefault("$skipToken")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "$skipToken", valid_594065
  var valid_594066 = query.getOrDefault("$filter")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "$filter", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_BackupJobsList_594057; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of jobs.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_BackupJobsList_594057; resourceGroupName: string;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "vaultName", newJString(vaultName))
  add(query_594070, "$skipToken", newJString(SkipToken))
  add(query_594070, "$filter", newJString(Filter))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var backupJobsList* = Call_BackupJobsList_594057(name: "backupJobsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs",
    validator: validate_BackupJobsList_594058, base: "", url: url_BackupJobsList_594059,
    schemes: {Scheme.Https})
type
  Call_ExportJobsOperationResultsGet_594071 = ref object of OpenApiRestCall_593438
proc url_ExportJobsOperationResultsGet_594073(protocol: Scheme; host: string;
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

proc validate_ExportJobsOperationResultsGet_594072(path: JsonNode; query: JsonNode;
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
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("vaultName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "vaultName", valid_594076
  var valid_594077 = path.getOrDefault("operationId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "operationId", valid_594077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594078 = query.getOrDefault("api-version")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "api-version", valid_594078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594079: Call_ExportJobsOperationResultsGet_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the operation result of operation triggered by Export Jobs API. If the operation is successful, then it also
  ## contains URL of a Blob and a SAS key to access the same. The blob contains exported jobs in JSON serialized format.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_ExportJobsOperationResultsGet_594071;
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
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  add(path_594081, "resourceGroupName", newJString(resourceGroupName))
  add(query_594082, "api-version", newJString(apiVersion))
  add(path_594081, "subscriptionId", newJString(subscriptionId))
  add(path_594081, "vaultName", newJString(vaultName))
  add(path_594081, "operationId", newJString(operationId))
  result = call_594080.call(path_594081, query_594082, nil, nil, nil)

var exportJobsOperationResultsGet* = Call_ExportJobsOperationResultsGet_594071(
    name: "exportJobsOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/operationResults/{operationId}",
    validator: validate_ExportJobsOperationResultsGet_594072, base: "",
    url: url_ExportJobsOperationResultsGet_594073, schemes: {Scheme.Https})
type
  Call_JobDetailsGet_594083 = ref object of OpenApiRestCall_593438
proc url_JobDetailsGet_594085(protocol: Scheme; host: string; base: string;
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

proc validate_JobDetailsGet_594084(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594086 = path.getOrDefault("resourceGroupName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "resourceGroupName", valid_594086
  var valid_594087 = path.getOrDefault("subscriptionId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "subscriptionId", valid_594087
  var valid_594088 = path.getOrDefault("jobName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "jobName", valid_594088
  var valid_594089 = path.getOrDefault("vaultName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "vaultName", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594090 = query.getOrDefault("api-version")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "api-version", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_JobDetailsGet_594083; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets extended information associated with the job.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_JobDetailsGet_594083; resourceGroupName: string;
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
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(path_594093, "resourceGroupName", newJString(resourceGroupName))
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "subscriptionId", newJString(subscriptionId))
  add(path_594093, "jobName", newJString(jobName))
  add(path_594093, "vaultName", newJString(vaultName))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var jobDetailsGet* = Call_JobDetailsGet_594083(name: "jobDetailsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}",
    validator: validate_JobDetailsGet_594084, base: "", url: url_JobDetailsGet_594085,
    schemes: {Scheme.Https})
type
  Call_JobsExport_594095 = ref object of OpenApiRestCall_593438
proc url_JobsExport_594097(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsExport_594096(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  var valid_594100 = path.getOrDefault("vaultName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "vaultName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  var valid_594102 = query.getOrDefault("$filter")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "$filter", valid_594102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_JobsExport_594095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers export of jobs specified by filters and returns an OperationID to track.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_JobsExport_594095; resourceGroupName: string;
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
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  add(path_594105, "resourceGroupName", newJString(resourceGroupName))
  add(query_594106, "api-version", newJString(apiVersion))
  add(path_594105, "subscriptionId", newJString(subscriptionId))
  add(path_594105, "vaultName", newJString(vaultName))
  add(query_594106, "$filter", newJString(Filter))
  result = call_594104.call(path_594105, query_594106, nil, nil, nil)

var jobsExport* = Call_JobsExport_594095(name: "jobsExport",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobsExport",
                                      validator: validate_JobsExport_594096,
                                      base: "", url: url_JobsExport_594097,
                                      schemes: {Scheme.Https})
type
  Call_BackupPoliciesList_594107 = ref object of OpenApiRestCall_593438
proc url_BackupPoliciesList_594109(protocol: Scheme; host: string; base: string;
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

proc validate_BackupPoliciesList_594108(path: JsonNode; query: JsonNode;
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
  var valid_594110 = path.getOrDefault("resourceGroupName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "resourceGroupName", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  var valid_594112 = path.getOrDefault("vaultName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "vaultName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  var valid_594114 = query.getOrDefault("$filter")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "$filter", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_BackupPoliciesList_594107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists of backup policies associated with Recovery Services Vault. API provides pagination parameters to fetch
  ## scoped results.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_BackupPoliciesList_594107; resourceGroupName: string;
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
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(path_594117, "resourceGroupName", newJString(resourceGroupName))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  add(path_594117, "vaultName", newJString(vaultName))
  add(query_594118, "$filter", newJString(Filter))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var backupPoliciesList* = Call_BackupPoliciesList_594107(
    name: "backupPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies",
    validator: validate_BackupPoliciesList_594108, base: "",
    url: url_BackupPoliciesList_594109, schemes: {Scheme.Https})
type
  Call_BackupProtectedItemsList_594119 = ref object of OpenApiRestCall_593438
proc url_BackupProtectedItemsList_594121(protocol: Scheme; host: string;
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

proc validate_BackupProtectedItemsList_594120(path: JsonNode; query: JsonNode;
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
  var valid_594122 = path.getOrDefault("resourceGroupName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "resourceGroupName", valid_594122
  var valid_594123 = path.getOrDefault("subscriptionId")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "subscriptionId", valid_594123
  var valid_594124 = path.getOrDefault("vaultName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "vaultName", valid_594124
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
  var valid_594125 = query.getOrDefault("api-version")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "api-version", valid_594125
  var valid_594126 = query.getOrDefault("$skipToken")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "$skipToken", valid_594126
  var valid_594127 = query.getOrDefault("$filter")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "$filter", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_BackupProtectedItemsList_594119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all items that are backed up within a vault.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_BackupProtectedItemsList_594119;
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
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  add(path_594130, "vaultName", newJString(vaultName))
  add(query_594131, "$skipToken", newJString(SkipToken))
  add(query_594131, "$filter", newJString(Filter))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var backupProtectedItemsList* = Call_BackupProtectedItemsList_594119(
    name: "backupProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectedItems",
    validator: validate_BackupProtectedItemsList_594120, base: "",
    url: url_BackupProtectedItemsList_594121, schemes: {Scheme.Https})
type
  Call_BackupProtectionIntentList_594132 = ref object of OpenApiRestCall_593438
proc url_BackupProtectionIntentList_594134(protocol: Scheme; host: string;
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

proc validate_BackupProtectionIntentList_594133(path: JsonNode; query: JsonNode;
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
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  var valid_594137 = path.getOrDefault("vaultName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "vaultName", valid_594137
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
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  var valid_594139 = query.getOrDefault("$skipToken")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "$skipToken", valid_594139
  var valid_594140 = query.getOrDefault("$filter")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "$filter", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_BackupProtectionIntentList_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all intents that are present within a vault.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_BackupProtectionIntentList_594132;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(path_594143, "resourceGroupName", newJString(resourceGroupName))
  add(query_594144, "api-version", newJString(apiVersion))
  add(path_594143, "subscriptionId", newJString(subscriptionId))
  add(path_594143, "vaultName", newJString(vaultName))
  add(query_594144, "$skipToken", newJString(SkipToken))
  add(query_594144, "$filter", newJString(Filter))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var backupProtectionIntentList* = Call_BackupProtectionIntentList_594132(
    name: "backupProtectionIntentList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionIntents",
    validator: validate_BackupProtectionIntentList_594133, base: "",
    url: url_BackupProtectionIntentList_594134, schemes: {Scheme.Https})
type
  Call_BackupUsageSummariesList_594145 = ref object of OpenApiRestCall_593438
proc url_BackupUsageSummariesList_594147(protocol: Scheme; host: string;
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

proc validate_BackupUsageSummariesList_594146(path: JsonNode; query: JsonNode;
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
  var valid_594148 = path.getOrDefault("resourceGroupName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "resourceGroupName", valid_594148
  var valid_594149 = path.getOrDefault("subscriptionId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "subscriptionId", valid_594149
  var valid_594150 = path.getOrDefault("vaultName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "vaultName", valid_594150
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
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
  var valid_594152 = query.getOrDefault("$skipToken")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "$skipToken", valid_594152
  var valid_594153 = query.getOrDefault("$filter")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "$filter", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594154: Call_BackupUsageSummariesList_594145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the backup management usage summaries of the vault.
  ## 
  let valid = call_594154.validator(path, query, header, formData, body)
  let scheme = call_594154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594154.url(scheme.get, call_594154.host, call_594154.base,
                         call_594154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594154, url, valid)

proc call*(call_594155: Call_BackupUsageSummariesList_594145;
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
  var path_594156 = newJObject()
  var query_594157 = newJObject()
  add(path_594156, "resourceGroupName", newJString(resourceGroupName))
  add(query_594157, "api-version", newJString(apiVersion))
  add(path_594156, "subscriptionId", newJString(subscriptionId))
  add(path_594156, "vaultName", newJString(vaultName))
  add(query_594157, "$skipToken", newJString(SkipToken))
  add(query_594157, "$filter", newJString(Filter))
  result = call_594155.call(path_594156, query_594157, nil, nil, nil)

var backupUsageSummariesList* = Call_BackupUsageSummariesList_594145(
    name: "backupUsageSummariesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupUsageSummaries",
    validator: validate_BackupUsageSummariesList_594146, base: "",
    url: url_BackupUsageSummariesList_594147, schemes: {Scheme.Https})
type
  Call_OperationValidate_594158 = ref object of OpenApiRestCall_593438
proc url_OperationValidate_594160(protocol: Scheme; host: string; base: string;
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

proc validate_OperationValidate_594159(path: JsonNode; query: JsonNode;
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
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("subscriptionId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "subscriptionId", valid_594162
  var valid_594163 = path.getOrDefault("vaultName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "vaultName", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
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

proc call*(call_594166: Call_OperationValidate_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate operation for specified backed up item. This is a synchronous operation.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_OperationValidate_594158; resourceGroupName: string;
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
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  var body_594170 = newJObject()
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  add(path_594168, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594170 = parameters
  result = call_594167.call(path_594168, query_594169, nil, nil, body_594170)

var operationValidate* = Call_OperationValidate_594158(name: "operationValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupValidateOperation",
    validator: validate_OperationValidate_594159, base: "",
    url: url_OperationValidate_594160, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
