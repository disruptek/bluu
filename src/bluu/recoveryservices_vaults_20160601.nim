
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesClient
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservices-vaults"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the list of available operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of available operations.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_OperationsList_593630; apiVersion: string): Recallable =
  ## operationsList
  ## Returns the list of available operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.RecoveryServices/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_VaultsListBySubscriptionId_593926 = ref object of OpenApiRestCall_593408
proc url_VaultsListBySubscriptionId_593928(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.RecoveryServices/vaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListBySubscriptionId_593927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches all the resources of the specified type in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593943 = path.getOrDefault("subscriptionId")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = nil)
  if valid_593943 != nil:
    section.add "subscriptionId", valid_593943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593944 = query.getOrDefault("api-version")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "api-version", valid_593944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593945: Call_VaultsListBySubscriptionId_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches all the resources of the specified type in the subscription.
  ## 
  let valid = call_593945.validator(path, query, header, formData, body)
  let scheme = call_593945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593945.url(scheme.get, call_593945.host, call_593945.base,
                         call_593945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593945, url, valid)

proc call*(call_593946: Call_VaultsListBySubscriptionId_593926; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vaultsListBySubscriptionId
  ## Fetches all the resources of the specified type in the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  var path_593947 = newJObject()
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(path_593947, "subscriptionId", newJString(subscriptionId))
  result = call_593946.call(path_593947, query_593948, nil, nil, nil)

var vaultsListBySubscriptionId* = Call_VaultsListBySubscriptionId_593926(
    name: "vaultsListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.RecoveryServices/vaults",
    validator: validate_VaultsListBySubscriptionId_593927, base: "",
    url: url_VaultsListBySubscriptionId_593928, schemes: {Scheme.Https})
type
  Call_RecoveryServicesCheckNameAvailability_593949 = ref object of OpenApiRestCall_593408
proc url_RecoveryServicesCheckNameAvailability_593951(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryServicesCheckNameAvailability_593950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   location: JString (required)
  ##           : Location of the resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593952 = path.getOrDefault("resourceGroupName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "resourceGroupName", valid_593952
  var valid_593953 = path.getOrDefault("subscriptionId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "subscriptionId", valid_593953
  var valid_593954 = path.getOrDefault("location")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "location", valid_593954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593955 = query.getOrDefault("api-version")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "api-version", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Contains information about Resource type and Resource name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_RecoveryServicesCheckNameAvailability_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_RecoveryServicesCheckNameAvailability_593949;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; location: string): Recallable =
  ## recoveryServicesCheckNameAvailability
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Contains information about Resource type and Resource name
  ##   location: string (required)
  ##           : Location of the resource
  var path_593959 = newJObject()
  var query_593960 = newJObject()
  var body_593961 = newJObject()
  add(path_593959, "resourceGroupName", newJString(resourceGroupName))
  add(query_593960, "api-version", newJString(apiVersion))
  add(path_593959, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_593961 = input
  add(path_593959, "location", newJString(location))
  result = call_593958.call(path_593959, query_593960, nil, nil, body_593961)

var recoveryServicesCheckNameAvailability* = Call_RecoveryServicesCheckNameAvailability_593949(
    name: "recoveryServicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/locations/{location}/checkNameAvailability",
    validator: validate_RecoveryServicesCheckNameAvailability_593950, base: "",
    url: url_RecoveryServicesCheckNameAvailability_593951, schemes: {Scheme.Https})
type
  Call_VaultsListByResourceGroup_593962 = ref object of OpenApiRestCall_593408
proc url_VaultsListByResourceGroup_593964(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListByResourceGroup_593963(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of Vaults.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593965 = path.getOrDefault("resourceGroupName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceGroupName", valid_593965
  var valid_593966 = path.getOrDefault("subscriptionId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "subscriptionId", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_VaultsListByResourceGroup_593962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of Vaults.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_VaultsListByResourceGroup_593962;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vaultsListByResourceGroup
  ## Retrieve a list of Vaults.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  var path_593970 = newJObject()
  var query_593971 = newJObject()
  add(path_593970, "resourceGroupName", newJString(resourceGroupName))
  add(query_593971, "api-version", newJString(apiVersion))
  add(path_593970, "subscriptionId", newJString(subscriptionId))
  result = call_593969.call(path_593970, query_593971, nil, nil, nil)

var vaultsListByResourceGroup* = Call_VaultsListByResourceGroup_593962(
    name: "vaultsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults",
    validator: validate_VaultsListByResourceGroup_593963, base: "",
    url: url_VaultsListByResourceGroup_593964, schemes: {Scheme.Https})
type
  Call_VaultsCreateOrUpdate_593983 = ref object of OpenApiRestCall_593408
proc url_VaultsCreateOrUpdate_593985(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsCreateOrUpdate_593984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Recovery Services vault.
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
  var valid_593986 = path.getOrDefault("resourceGroupName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "resourceGroupName", valid_593986
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
  var valid_593988 = path.getOrDefault("vaultName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "vaultName", valid_593988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vault: JObject (required)
  ##        : Recovery Services Vault to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_VaultsCreateOrUpdate_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Recovery Services vault.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_VaultsCreateOrUpdate_593983;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vault: JsonNode; vaultName: string): Recallable =
  ## vaultsCreateOrUpdate
  ## Creates or updates a Recovery Services vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vault: JObject (required)
  ##        : Recovery Services Vault to be created.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  var body_593995 = newJObject()
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  if vault != nil:
    body_593995 = vault
  add(path_593993, "vaultName", newJString(vaultName))
  result = call_593992.call(path_593993, query_593994, nil, nil, body_593995)

var vaultsCreateOrUpdate* = Call_VaultsCreateOrUpdate_593983(
    name: "vaultsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}",
    validator: validate_VaultsCreateOrUpdate_593984, base: "",
    url: url_VaultsCreateOrUpdate_593985, schemes: {Scheme.Https})
type
  Call_VaultsGet_593972 = ref object of OpenApiRestCall_593408
proc url_VaultsGet_593974(protocol: Scheme; host: string; base: string; route: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsGet_593973(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Vault details.
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
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  var valid_593977 = path.getOrDefault("vaultName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "vaultName", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_VaultsGet_593972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Vault details.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_VaultsGet_593972; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string): Recallable =
  ## vaultsGet
  ## Get the Vault details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  add(path_593981, "resourceGroupName", newJString(resourceGroupName))
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  add(path_593981, "vaultName", newJString(vaultName))
  result = call_593980.call(path_593981, query_593982, nil, nil, nil)

var vaultsGet* = Call_VaultsGet_593972(name: "vaultsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}",
                                    validator: validate_VaultsGet_593973,
                                    base: "", url: url_VaultsGet_593974,
                                    schemes: {Scheme.Https})
type
  Call_VaultsUpdate_594007 = ref object of OpenApiRestCall_593408
proc url_VaultsUpdate_594009(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsUpdate_594008(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the vault.
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
  var valid_594010 = path.getOrDefault("resourceGroupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceGroupName", valid_594010
  var valid_594011 = path.getOrDefault("subscriptionId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "subscriptionId", valid_594011
  var valid_594012 = path.getOrDefault("vaultName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "vaultName", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vault: JObject (required)
  ##        : Recovery Services Vault to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_VaultsUpdate_594007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the vault.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_VaultsUpdate_594007; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vault: JsonNode;
          vaultName: string): Recallable =
  ## vaultsUpdate
  ## Updates the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vault: JObject (required)
  ##        : Recovery Services Vault to be created.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  var body_594019 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  if vault != nil:
    body_594019 = vault
  add(path_594017, "vaultName", newJString(vaultName))
  result = call_594016.call(path_594017, query_594018, nil, nil, body_594019)

var vaultsUpdate* = Call_VaultsUpdate_594007(name: "vaultsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}",
    validator: validate_VaultsUpdate_594008, base: "", url: url_VaultsUpdate_594009,
    schemes: {Scheme.Https})
type
  Call_VaultsDelete_593996 = ref object of OpenApiRestCall_593408
proc url_VaultsDelete_593998(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsDelete_593997(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a vault.
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
  var valid_593999 = path.getOrDefault("resourceGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceGroupName", valid_593999
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  var valid_594001 = path.getOrDefault("vaultName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "vaultName", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_VaultsDelete_593996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vault.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_VaultsDelete_593996; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string): Recallable =
  ## vaultsDelete
  ## Deletes a vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(path_594005, "resourceGroupName", newJString(resourceGroupName))
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(path_594005, "vaultName", newJString(vaultName))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var vaultsDelete* = Call_VaultsDelete_593996(name: "vaultsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}",
    validator: validate_VaultsDelete_593997, base: "", url: url_VaultsDelete_593998,
    schemes: {Scheme.Https})
type
  Call_VaultExtendedInfoCreateOrUpdate_594031 = ref object of OpenApiRestCall_593408
proc url_VaultExtendedInfoCreateOrUpdate_594033(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultExtendedInfoCreateOrUpdate_594032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create vault extended info.
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
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
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
  ##   resourceResourceExtendedInfoDetails: JObject (required)
  ##                                      : Details of ResourceExtendedInfo
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_VaultExtendedInfoCreateOrUpdate_594031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create vault extended info.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_VaultExtendedInfoCreateOrUpdate_594031;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; resourceResourceExtendedInfoDetails: JsonNode): Recallable =
  ## vaultExtendedInfoCreateOrUpdate
  ## Create vault extended info.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   resourceResourceExtendedInfoDetails: JObject (required)
  ##                                      : Details of ResourceExtendedInfo
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  var body_594043 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  add(path_594041, "vaultName", newJString(vaultName))
  if resourceResourceExtendedInfoDetails != nil:
    body_594043 = resourceResourceExtendedInfoDetails
  result = call_594040.call(path_594041, query_594042, nil, nil, body_594043)

var vaultExtendedInfoCreateOrUpdate* = Call_VaultExtendedInfoCreateOrUpdate_594031(
    name: "vaultExtendedInfoCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/extendedInformation/vaultExtendedInfo",
    validator: validate_VaultExtendedInfoCreateOrUpdate_594032, base: "",
    url: url_VaultExtendedInfoCreateOrUpdate_594033, schemes: {Scheme.Https})
type
  Call_VaultExtendedInfoGet_594020 = ref object of OpenApiRestCall_593408
proc url_VaultExtendedInfoGet_594022(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultExtendedInfoGet_594021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the vault extended info.
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
  var valid_594023 = path.getOrDefault("resourceGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceGroupName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  var valid_594025 = path.getOrDefault("vaultName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "vaultName", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_VaultExtendedInfoGet_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the vault extended info.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_VaultExtendedInfoGet_594020;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## vaultExtendedInfoGet
  ## Get the vault extended info.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  add(path_594029, "vaultName", newJString(vaultName))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var vaultExtendedInfoGet* = Call_VaultExtendedInfoGet_594020(
    name: "vaultExtendedInfoGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/extendedInformation/vaultExtendedInfo",
    validator: validate_VaultExtendedInfoGet_594021, base: "",
    url: url_VaultExtendedInfoGet_594022, schemes: {Scheme.Https})
type
  Call_VaultExtendedInfoUpdate_594044 = ref object of OpenApiRestCall_593408
proc url_VaultExtendedInfoUpdate_594046(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultExtendedInfoUpdate_594045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update vault extended info.
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
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  var valid_594049 = path.getOrDefault("vaultName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "vaultName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceResourceExtendedInfoDetails: JObject (required)
  ##                                      : Details of ResourceExtendedInfo
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_VaultExtendedInfoUpdate_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update vault extended info.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_VaultExtendedInfoUpdate_594044;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; resourceResourceExtendedInfoDetails: JsonNode): Recallable =
  ## vaultExtendedInfoUpdate
  ## Update vault extended info.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   resourceResourceExtendedInfoDetails: JObject (required)
  ##                                      : Details of ResourceExtendedInfo
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  var body_594056 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(path_594054, "vaultName", newJString(vaultName))
  if resourceResourceExtendedInfoDetails != nil:
    body_594056 = resourceResourceExtendedInfoDetails
  result = call_594053.call(path_594054, query_594055, nil, nil, body_594056)

var vaultExtendedInfoUpdate* = Call_VaultExtendedInfoUpdate_594044(
    name: "vaultExtendedInfoUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/extendedInformation/vaultExtendedInfo",
    validator: validate_VaultExtendedInfoUpdate_594045, base: "",
    url: url_VaultExtendedInfoUpdate_594046, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
