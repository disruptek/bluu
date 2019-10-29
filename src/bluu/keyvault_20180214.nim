
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: KeyVaultManagementClient
## version: 2018-02-14
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure management API provides a RESTful set of web services that interact with Azure Key Vault.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "keyvault"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VaultsCheckNameAvailability_563777 = ref object of OpenApiRestCall_563555
proc url_VaultsCheckNameAvailability_563779(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.KeyVault/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsCheckNameAvailability_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the vault name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563971 = path.getOrDefault("subscriptionId")
  valid_563971 = validateParameter(valid_563971, JString, required = true,
                                 default = nil)
  if valid_563971 != nil:
    section.add "subscriptionId", valid_563971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563972 = query.getOrDefault("api-version")
  valid_563972 = validateParameter(valid_563972, JString, required = true,
                                 default = nil)
  if valid_563972 != nil:
    section.add "api-version", valid_563972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vaultName: JObject (required)
  ##            : The name of the vault.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563996: Call_VaultsCheckNameAvailability_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the vault name is valid and is not already in use.
  ## 
  let valid = call_563996.validator(path, query, header, formData, body)
  let scheme = call_563996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563996.url(scheme.get, call_563996.host, call_563996.base,
                         call_563996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563996, url, valid)

proc call*(call_564067: Call_VaultsCheckNameAvailability_563777;
          apiVersion: string; vaultName: JsonNode; subscriptionId: string): Recallable =
  ## vaultsCheckNameAvailability
  ## Checks that the vault name is valid and is not already in use.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vaultName: JObject (required)
  ##            : The name of the vault.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564068 = newJObject()
  var query_564070 = newJObject()
  var body_564071 = newJObject()
  add(query_564070, "api-version", newJString(apiVersion))
  if vaultName != nil:
    body_564071 = vaultName
  add(path_564068, "subscriptionId", newJString(subscriptionId))
  result = call_564067.call(path_564068, query_564070, nil, nil, body_564071)

var vaultsCheckNameAvailability* = Call_VaultsCheckNameAvailability_563777(
    name: "vaultsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/checkNameAvailability",
    validator: validate_VaultsCheckNameAvailability_563778, base: "",
    url: url_VaultsCheckNameAvailability_563779, schemes: {Scheme.Https})
type
  Call_VaultsListDeleted_564110 = ref object of OpenApiRestCall_563555
proc url_VaultsListDeleted_564112(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.KeyVault/deletedVaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListDeleted_564111(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about the deleted vaults in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_VaultsListDeleted_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the deleted vaults in a subscription.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_VaultsListDeleted_564110; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vaultsListDeleted
  ## Gets information about the deleted vaults in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var vaultsListDeleted* = Call_VaultsListDeleted_564110(name: "vaultsListDeleted",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/deletedVaults",
    validator: validate_VaultsListDeleted_564111, base: "",
    url: url_VaultsListDeleted_564112, schemes: {Scheme.Https})
type
  Call_VaultsGetDeleted_564119 = ref object of OpenApiRestCall_563555
proc url_VaultsGetDeleted_564121(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/deletedVaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsGetDeleted_564120(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the deleted Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the vault.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the deleted vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564122 = path.getOrDefault("vaultName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "vaultName", valid_564122
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("location")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "location", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_VaultsGetDeleted_564119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the deleted Azure key vault.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_VaultsGetDeleted_564119; vaultName: string;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## vaultsGetDeleted
  ## Gets the deleted Azure key vault.
  ##   vaultName: string (required)
  ##            : The name of the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the deleted vault.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(path_564128, "vaultName", newJString(vaultName))
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "location", newJString(location))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var vaultsGetDeleted* = Call_VaultsGetDeleted_564119(name: "vaultsGetDeleted",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/locations/{location}/deletedVaults/{vaultName}",
    validator: validate_VaultsGetDeleted_564120, base: "",
    url: url_VaultsGetDeleted_564121, schemes: {Scheme.Https})
type
  Call_VaultsPurgeDeleted_564130 = ref object of OpenApiRestCall_563555
proc url_VaultsPurgeDeleted_564132(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/deletedVaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsPurgeDeleted_564131(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the soft-deleted vault.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the soft-deleted vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564133 = path.getOrDefault("vaultName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "vaultName", valid_564133
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  var valid_564135 = path.getOrDefault("location")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "location", valid_564135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_VaultsPurgeDeleted_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_VaultsPurgeDeleted_564130; vaultName: string;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## vaultsPurgeDeleted
  ## Permanently deletes the specified vault. aka Purges the deleted Azure key vault.
  ##   vaultName: string (required)
  ##            : The name of the soft-deleted vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the soft-deleted vault.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(path_564139, "vaultName", newJString(vaultName))
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "location", newJString(location))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var vaultsPurgeDeleted* = Call_VaultsPurgeDeleted_564130(
    name: "vaultsPurgeDeleted", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/locations/{location}/deletedVaults/{vaultName}/purge",
    validator: validate_VaultsPurgeDeleted_564131, base: "",
    url: url_VaultsPurgeDeleted_564132, schemes: {Scheme.Https})
type
  Call_VaultsListBySubscription_564141 = ref object of OpenApiRestCall_563555
proc url_VaultsListBySubscription_564143(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListBySubscription_564142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of results to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564146 = query.getOrDefault("$top")
  valid_564146 = validateParameter(valid_564146, JInt, required = false, default = nil)
  if valid_564146 != nil:
    section.add "$top", valid_564146
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_VaultsListBySubscription_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_VaultsListBySubscription_564141; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## vaultsListBySubscription
  ## The List operation gets information about the vaults associated with the subscription.
  ##   Top: int
  ##      : Maximum number of results to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  add(query_564151, "$top", newJInt(Top))
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  result = call_564149.call(path_564150, query_564151, nil, nil, nil)

var vaultsListBySubscription* = Call_VaultsListBySubscription_564141(
    name: "vaultsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.KeyVault/vaults",
    validator: validate_VaultsListBySubscription_564142, base: "",
    url: url_VaultsListBySubscription_564143, schemes: {Scheme.Https})
type
  Call_VaultsListByResourceGroup_564152 = ref object of OpenApiRestCall_563555
proc url_VaultsListByResourceGroup_564154(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsListByResourceGroup_564153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("resourceGroupName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceGroupName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of results to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564157 = query.getOrDefault("$top")
  valid_564157 = validateParameter(valid_564157, JInt, required = false, default = nil)
  if valid_564157 != nil:
    section.add "$top", valid_564157
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_VaultsListByResourceGroup_564152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_VaultsListByResourceGroup_564152; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0): Recallable =
  ## vaultsListByResourceGroup
  ## The List operation gets information about the vaults associated with the subscription and within the specified resource group.
  ##   Top: int
  ##      : Maximum number of results to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "$top", newJInt(Top))
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var vaultsListByResourceGroup* = Call_VaultsListByResourceGroup_564152(
    name: "vaultsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults",
    validator: validate_VaultsListByResourceGroup_564153, base: "",
    url: url_VaultsListByResourceGroup_564154, schemes: {Scheme.Https})
type
  Call_VaultsCreateOrUpdate_564174 = ref object of OpenApiRestCall_563555
proc url_VaultsCreateOrUpdate_564176(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsCreateOrUpdate_564175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a key vault in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : Name of the vault
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the server belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564177 = path.getOrDefault("vaultName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "vaultName", valid_564177
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the vault
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_VaultsCreateOrUpdate_564174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a key vault in the specified subscription.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_VaultsCreateOrUpdate_564174; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## vaultsCreateOrUpdate
  ## Create or update a key vault in the specified subscription.
  ##   vaultName: string (required)
  ##            : Name of the vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the vault
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  var body_564186 = newJObject()
  add(path_564184, "vaultName", newJString(vaultName))
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564186 = parameters
  result = call_564183.call(path_564184, query_564185, nil, nil, body_564186)

var vaultsCreateOrUpdate* = Call_VaultsCreateOrUpdate_564174(
    name: "vaultsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsCreateOrUpdate_564175, base: "",
    url: url_VaultsCreateOrUpdate_564176, schemes: {Scheme.Https})
type
  Call_VaultsGet_564163 = ref object of OpenApiRestCall_563555
proc url_VaultsGet_564165(protocol: Scheme; host: string; base: string; route: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsGet_564164(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the vault.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564166 = path.getOrDefault("vaultName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "vaultName", valid_564166
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_VaultsGet_564163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Azure key vault.
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_VaultsGet_564163; vaultName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## vaultsGet
  ## Gets the specified Azure key vault.
  ##   vaultName: string (required)
  ##            : The name of the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(path_564172, "vaultName", newJString(vaultName))
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var vaultsGet* = Call_VaultsGet_564163(name: "vaultsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
                                    validator: validate_VaultsGet_564164,
                                    base: "", url: url_VaultsGet_564165,
                                    schemes: {Scheme.Https})
type
  Call_VaultsUpdate_564198 = ref object of OpenApiRestCall_563555
proc url_VaultsUpdate_564200(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsUpdate_564199(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a key vault in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : Name of the vault
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the server belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564201 = path.getOrDefault("vaultName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "vaultName", valid_564201
  var valid_564202 = path.getOrDefault("subscriptionId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "subscriptionId", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to patch the vault
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_VaultsUpdate_564198; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a key vault in the specified subscription.
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_VaultsUpdate_564198; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## vaultsUpdate
  ## Update a key vault in the specified subscription.
  ##   vaultName: string (required)
  ##            : Name of the vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the server belongs.
  ##   parameters: JObject (required)
  ##             : Parameters to patch the vault
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  var body_564210 = newJObject()
  add(path_564208, "vaultName", newJString(vaultName))
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564210 = parameters
  result = call_564207.call(path_564208, query_564209, nil, nil, body_564210)

var vaultsUpdate* = Call_VaultsUpdate_564198(name: "vaultsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsUpdate_564199, base: "", url: url_VaultsUpdate_564200,
    schemes: {Scheme.Https})
type
  Call_VaultsDelete_564187 = ref object of OpenApiRestCall_563555
proc url_VaultsDelete_564189(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsDelete_564188(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Azure key vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the vault to delete
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564190 = path.getOrDefault("vaultName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "vaultName", valid_564190
  var valid_564191 = path.getOrDefault("subscriptionId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "subscriptionId", valid_564191
  var valid_564192 = path.getOrDefault("resourceGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceGroupName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564194: Call_VaultsDelete_564187; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Azure key vault.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_VaultsDelete_564187; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vaultsDelete
  ## Deletes the specified Azure key vault.
  ##   vaultName: string (required)
  ##            : The name of the vault to delete
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(path_564196, "vaultName", newJString(vaultName))
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var vaultsDelete* = Call_VaultsDelete_564187(name: "vaultsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
    validator: validate_VaultsDelete_564188, base: "", url: url_VaultsDelete_564189,
    schemes: {Scheme.Https})
type
  Call_VaultsUpdateAccessPolicy_564211 = ref object of OpenApiRestCall_563555
proc url_VaultsUpdateAccessPolicy_564213(protocol: Scheme; host: string;
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
  assert "operationKind" in path, "`operationKind` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.KeyVault/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/accessPolicies/"),
               (kind: VariableSegment, value: "operationKind")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultsUpdateAccessPolicy_564212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update access policies in a key vault in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationKind: JString (required)
  ##                : Name of the operation
  ##   vaultName: JString (required)
  ##            : Name of the vault
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationKind` field"
  var valid_564227 = path.getOrDefault("operationKind")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = newJString("add"))
  if valid_564227 != nil:
    section.add "operationKind", valid_564227
  var valid_564228 = path.getOrDefault("vaultName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "vaultName", valid_564228
  var valid_564229 = path.getOrDefault("subscriptionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "subscriptionId", valid_564229
  var valid_564230 = path.getOrDefault("resourceGroupName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "resourceGroupName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Access policy to merge into the vault
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_VaultsUpdateAccessPolicy_564211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update access policies in a key vault in the specified subscription.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_VaultsUpdateAccessPolicy_564211; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; operationKind: string = "add"): Recallable =
  ## vaultsUpdateAccessPolicy
  ## Update access policies in a key vault in the specified subscription.
  ##   operationKind: string (required)
  ##                : Name of the operation
  ##   vaultName: string (required)
  ##            : Name of the vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the vault belongs.
  ##   parameters: JObject (required)
  ##             : Access policy to merge into the vault
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  var body_564237 = newJObject()
  add(path_564235, "operationKind", newJString(operationKind))
  add(path_564235, "vaultName", newJString(vaultName))
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564237 = parameters
  result = call_564234.call(path_564235, query_564236, nil, nil, body_564237)

var vaultsUpdateAccessPolicy* = Call_VaultsUpdateAccessPolicy_564211(
    name: "vaultsUpdateAccessPolicy", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/accessPolicies/{operationKind}",
    validator: validate_VaultsUpdateAccessPolicy_564212, base: "",
    url: url_VaultsUpdateAccessPolicy_564213, schemes: {Scheme.Https})
type
  Call_VaultsList_564238 = ref object of OpenApiRestCall_563555
proc url_VaultsList_564240(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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

proc validate_VaultsList_564239(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564241 = path.getOrDefault("subscriptionId")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "subscriptionId", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of results to return.
  ##   api-version: JString (required)
  ##              : Azure Resource Manager Api Version.
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564242 = query.getOrDefault("$top")
  valid_564242 = validateParameter(valid_564242, JInt, required = false, default = nil)
  if valid_564242 != nil:
    section.add "$top", valid_564242
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_564243 != nil:
    section.add "api-version", valid_564243
  var valid_564244 = query.getOrDefault("$filter")
  valid_564244 = validateParameter(valid_564244, JString, required = true, default = newJString(
      "resourceType eq \'Microsoft.KeyVault/vaults\'"))
  if valid_564244 != nil:
    section.add "$filter", valid_564244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564245: Call_VaultsList_564238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List operation gets information about the vaults associated with the subscription.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_VaultsList_564238; subscriptionId: string; Top: int = 0;
          apiVersion: string = "2015-11-01";
          Filter: string = "resourceType eq \'Microsoft.KeyVault/vaults\'"): Recallable =
  ## vaultsList
  ## The List operation gets information about the vaults associated with the subscription.
  ##   Top: int
  ##      : Maximum number of results to return.
  ##   apiVersion: string (required)
  ##             : Azure Resource Manager Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  add(query_564248, "$top", newJInt(Top))
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(query_564248, "$filter", newJString(Filter))
  result = call_564246.call(path_564247, query_564248, nil, nil, nil)

var vaultsList* = Call_VaultsList_564238(name: "vaultsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resources",
                                      validator: validate_VaultsList_564239,
                                      base: "", url: url_VaultsList_564240,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
