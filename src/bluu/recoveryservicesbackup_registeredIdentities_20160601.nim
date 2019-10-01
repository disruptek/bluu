
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup-registeredIdentities"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProtectionContainersUnregister_567863 = ref object of OpenApiRestCall_567641
proc url_ProtectionContainersUnregister_567865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "identityName" in path, "`identityName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/registeredIdentities/"),
               (kind: VariableSegment, value: "identityName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersUnregister_567864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregisters the given container from your Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   identityName: JString (required)
  ##               : Name of the protection container to unregister.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568038 = path.getOrDefault("resourceGroupName")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "resourceGroupName", valid_568038
  var valid_568039 = path.getOrDefault("identityName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "identityName", valid_568039
  var valid_568040 = path.getOrDefault("subscriptionId")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "subscriptionId", valid_568040
  var valid_568041 = path.getOrDefault("vaultName")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "vaultName", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568065: Call_ProtectionContainersUnregister_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters the given container from your Recovery Services vault.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_ProtectionContainersUnregister_567863;
          resourceGroupName: string; apiVersion: string; identityName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersUnregister
  ## Unregisters the given container from your Recovery Services vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   identityName: string (required)
  ##               : Name of the protection container to unregister.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_568137 = newJObject()
  var query_568139 = newJObject()
  add(path_568137, "resourceGroupName", newJString(resourceGroupName))
  add(query_568139, "api-version", newJString(apiVersion))
  add(path_568137, "identityName", newJString(identityName))
  add(path_568137, "subscriptionId", newJString(subscriptionId))
  add(path_568137, "vaultName", newJString(vaultName))
  result = call_568136.call(path_568137, query_568139, nil, nil, nil)

var protectionContainersUnregister* = Call_ProtectionContainersUnregister_567863(
    name: "protectionContainersUnregister", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/registeredIdentities/{identityName}",
    validator: validate_ProtectionContainersUnregister_567864, base: "",
    url: url_ProtectionContainersUnregister_567865, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
