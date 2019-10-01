
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataShareManagementClient
## version: 2018-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates a Microsoft.DataShare management client.
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
  macServiceName = "datashare-DataShare"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConsumerInvitationsListInvitations_567889 = ref object of OpenApiRestCall_567667
proc url_ConsumerInvitationsListInvitations_567891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConsumerInvitationsListInvitations_567890(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists invitations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : The continuation token
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568075: Call_ConsumerInvitationsListInvitations_567889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists invitations
  ## 
  let valid = call_568075.validator(path, query, header, formData, body)
  let scheme = call_568075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568075.url(scheme.get, call_568075.host, call_568075.base,
                         call_568075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568075, url, valid)

proc call*(call_568146: Call_ConsumerInvitationsListInvitations_567889;
          apiVersion: string; SkipToken: string = ""): Recallable =
  ## consumerInvitationsListInvitations
  ## Lists invitations
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   SkipToken: string
  ##            : The continuation token
  var query_568147 = newJObject()
  add(query_568147, "api-version", newJString(apiVersion))
  add(query_568147, "$skipToken", newJString(SkipToken))
  result = call_568146.call(nil, query_568147, nil, nil, nil)

var consumerInvitationsListInvitations* = Call_ConsumerInvitationsListInvitations_567889(
    name: "consumerInvitationsListInvitations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DataShare/ListInvitations",
    validator: validate_ConsumerInvitationsListInvitations_567890, base: "",
    url: url_ConsumerInvitationsListInvitations_567891, schemes: {Scheme.Https})
type
  Call_ConsumerInvitationsRejectInvitation_568187 = ref object of OpenApiRestCall_567667
proc url_ConsumerInvitationsRejectInvitation_568189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.DataShare/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/RejectInvitation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerInvitationsRejectInvitation_568188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reject an invitation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : Location of the invitation
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_568204 = path.getOrDefault("location")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "location", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   invitation: JObject (required)
  ##             : An invitation payload
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_ConsumerInvitationsRejectInvitation_568187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reject an invitation
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_ConsumerInvitationsRejectInvitation_568187;
          apiVersion: string; invitation: JsonNode; location: string): Recallable =
  ## consumerInvitationsRejectInvitation
  ## Reject an invitation
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitation: JObject (required)
  ##             : An invitation payload
  ##   location: string (required)
  ##           : Location of the invitation
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  var body_568211 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  if invitation != nil:
    body_568211 = invitation
  add(path_568209, "location", newJString(location))
  result = call_568208.call(path_568209, query_568210, nil, nil, body_568211)

var consumerInvitationsRejectInvitation* = Call_ConsumerInvitationsRejectInvitation_568187(
    name: "consumerInvitationsRejectInvitation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.DataShare/locations/{location}/RejectInvitation",
    validator: validate_ConsumerInvitationsRejectInvitation_568188, base: "",
    url: url_ConsumerInvitationsRejectInvitation_568189, schemes: {Scheme.Https})
type
  Call_ConsumerInvitationsGet_568212 = ref object of OpenApiRestCall_567667
proc url_ConsumerInvitationsGet_568214(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  assert "invitationId" in path, "`invitationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.DataShare/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/consumerInvitations/"),
               (kind: VariableSegment, value: "invitationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerInvitationsGet_568213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an invitation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invitationId: JString (required)
  ##               : An invitation id
  ##   location: JString (required)
  ##           : Location of the invitation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationId` field"
  var valid_568215 = path.getOrDefault("invitationId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "invitationId", valid_568215
  var valid_568216 = path.getOrDefault("location")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "location", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_ConsumerInvitationsGet_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an invitation
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_ConsumerInvitationsGet_568212; apiVersion: string;
          invitationId: string; location: string): Recallable =
  ## consumerInvitationsGet
  ## Get an invitation
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitationId: string (required)
  ##               : An invitation id
  ##   location: string (required)
  ##           : Location of the invitation
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(query_568221, "api-version", newJString(apiVersion))
  add(path_568220, "invitationId", newJString(invitationId))
  add(path_568220, "location", newJString(location))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var consumerInvitationsGet* = Call_ConsumerInvitationsGet_568212(
    name: "consumerInvitationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.DataShare/locations/{location}/consumerInvitations/{invitationId}",
    validator: validate_ConsumerInvitationsGet_568213, base: "",
    url: url_ConsumerInvitationsGet_568214, schemes: {Scheme.Https})
type
  Call_OperationsList_568222 = ref object of OpenApiRestCall_567667
proc url_OperationsList_568224(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568223(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List of available operations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
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

proc call*(call_568226: Call_OperationsList_568222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of available operations
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_OperationsList_568222; apiVersion: string): Recallable =
  ## operationsList
  ## List of available operations
  ##   apiVersion: string (required)
  ##             : The api version to use.
  var query_568228 = newJObject()
  add(query_568228, "api-version", newJString(apiVersion))
  result = call_568227.call(nil, query_568228, nil, nil, nil)

var operationsList* = Call_OperationsList_568222(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataShare/operations",
    validator: validate_OperationsList_568223, base: "", url: url_OperationsList_568224,
    schemes: {Scheme.Https})
type
  Call_AccountsListBySubscription_568229 = ref object of OpenApiRestCall_567667
proc url_AccountsListBySubscription_568231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListBySubscription_568230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Accounts in Subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  var valid_568234 = query.getOrDefault("$skipToken")
  valid_568234 = validateParameter(valid_568234, JString, required = false,
                                 default = nil)
  if valid_568234 != nil:
    section.add "$skipToken", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_AccountsListBySubscription_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Accounts in Subscription
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_AccountsListBySubscription_568229; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## accountsListBySubscription
  ## List Accounts in Subscription
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   SkipToken: string
  ##            : Continuation token
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(query_568238, "$skipToken", newJString(SkipToken))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var accountsListBySubscription* = Call_AccountsListBySubscription_568229(
    name: "accountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataShare/accounts",
    validator: validate_AccountsListBySubscription_568230, base: "",
    url: url_AccountsListBySubscription_568231, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_568239 = ref object of OpenApiRestCall_567667
proc url_AccountsListByResourceGroup_568241(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_568240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Accounts in ResourceGroup
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  var valid_568245 = query.getOrDefault("$skipToken")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "$skipToken", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_AccountsListByResourceGroup_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Accounts in ResourceGroup
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_AccountsListByResourceGroup_568239;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          SkipToken: string = ""): Recallable =
  ## accountsListByResourceGroup
  ## List Accounts in ResourceGroup
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   SkipToken: string
  ##            : Continuation token
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(path_568248, "resourceGroupName", newJString(resourceGroupName))
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  add(query_568249, "$skipToken", newJString(SkipToken))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_568239(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts",
    validator: validate_AccountsListByResourceGroup_568240, base: "",
    url: url_AccountsListByResourceGroup_568241, schemes: {Scheme.Https})
type
  Call_AccountsCreate_568261 = ref object of OpenApiRestCall_567667
proc url_AccountsCreate_568263(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreate_568262(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  var valid_568266 = path.getOrDefault("accountName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "accountName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
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
  ## parameters in `body` object:
  ##   account: JObject (required)
  ##          : The account payload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_AccountsCreate_568261; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an account
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_AccountsCreate_568261; resourceGroupName: string;
          apiVersion: string; account: JsonNode; subscriptionId: string;
          accountName: string): Recallable =
  ## accountsCreate
  ## Create an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   account: JObject (required)
  ##          : The account payload.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  var body_568273 = newJObject()
  add(path_568271, "resourceGroupName", newJString(resourceGroupName))
  add(query_568272, "api-version", newJString(apiVersion))
  if account != nil:
    body_568273 = account
  add(path_568271, "subscriptionId", newJString(subscriptionId))
  add(path_568271, "accountName", newJString(accountName))
  result = call_568270.call(path_568271, query_568272, nil, nil, body_568273)

var accountsCreate* = Call_AccountsCreate_568261(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsCreate_568262, base: "", url: url_AccountsCreate_568263,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_568250 = ref object of OpenApiRestCall_567667
proc url_AccountsGet_568252(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_568251(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568255 = path.getOrDefault("accountName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "accountName", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_AccountsGet_568250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an account
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_AccountsGet_568250; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Get an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  add(path_568259, "accountName", newJString(accountName))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var accountsGet* = Call_AccountsGet_568250(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
                                        validator: validate_AccountsGet_568251,
                                        base: "", url: url_AccountsGet_568252,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_568285 = ref object of OpenApiRestCall_567667
proc url_AccountsUpdate_568287(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_568286(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Patch an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  var valid_568290 = path.getOrDefault("accountName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "accountName", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   accountUpdateParameters: JObject (required)
  ##                          : The account update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_AccountsUpdate_568285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch an account
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_AccountsUpdate_568285; resourceGroupName: string;
          apiVersion: string; accountUpdateParameters: JsonNode;
          subscriptionId: string; accountName: string): Recallable =
  ## accountsUpdate
  ## Patch an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   accountUpdateParameters: JObject (required)
  ##                          : The account update parameters.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  var body_568297 = newJObject()
  add(path_568295, "resourceGroupName", newJString(resourceGroupName))
  add(query_568296, "api-version", newJString(apiVersion))
  if accountUpdateParameters != nil:
    body_568297 = accountUpdateParameters
  add(path_568295, "subscriptionId", newJString(subscriptionId))
  add(path_568295, "accountName", newJString(accountName))
  result = call_568294.call(path_568295, query_568296, nil, nil, body_568297)

var accountsUpdate* = Call_AccountsUpdate_568285(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsUpdate_568286, base: "", url: url_AccountsUpdate_568287,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_568274 = ref object of OpenApiRestCall_567667
proc url_AccountsDelete_568276(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_568275(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## DeleteAccount
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568279 = path.getOrDefault("accountName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "accountName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_AccountsDelete_568274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## DeleteAccount
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_AccountsDelete_568274; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## DeleteAccount
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  add(path_568283, "accountName", newJString(accountName))
  result = call_568282.call(path_568283, query_568284, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_568274(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsDelete_568275, base: "", url: url_AccountsDelete_568276,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListByAccount_568298 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsListByAccount_568300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsListByAccount_568299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List share subscriptions in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("accountName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "accountName", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation Token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  var valid_568305 = query.getOrDefault("$skipToken")
  valid_568305 = validateParameter(valid_568305, JString, required = false,
                                 default = nil)
  if valid_568305 != nil:
    section.add "$skipToken", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_ShareSubscriptionsListByAccount_568298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List share subscriptions in an account
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_ShareSubscriptionsListByAccount_568298;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListByAccount
  ## List share subscriptions in an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   SkipToken: string
  ##            : Continuation Token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(query_568309, "$skipToken", newJString(SkipToken))
  add(path_568308, "accountName", newJString(accountName))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var shareSubscriptionsListByAccount* = Call_ShareSubscriptionsListByAccount_568298(
    name: "shareSubscriptionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions",
    validator: validate_ShareSubscriptionsListByAccount_568299, base: "",
    url: url_ShareSubscriptionsListByAccount_568300, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsCreate_568322 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsCreate_568324(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsCreate_568323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a shareSubscription in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568325 = path.getOrDefault("resourceGroupName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "resourceGroupName", valid_568325
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  var valid_568327 = path.getOrDefault("shareSubscriptionName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "shareSubscriptionName", valid_568327
  var valid_568328 = path.getOrDefault("accountName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "accountName", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
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
  ##   shareSubscription: JObject (required)
  ##                    : create parameters for shareSubscription
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_ShareSubscriptionsCreate_568322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a shareSubscription in an account
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_ShareSubscriptionsCreate_568322;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; shareSubscription: JsonNode;
          accountName: string): Recallable =
  ## shareSubscriptionsCreate
  ## Create a shareSubscription in an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   shareSubscription: JObject (required)
  ##                    : create parameters for shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  var body_568335 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  add(path_568333, "shareSubscriptionName", newJString(shareSubscriptionName))
  if shareSubscription != nil:
    body_568335 = shareSubscription
  add(path_568333, "accountName", newJString(accountName))
  result = call_568332.call(path_568333, query_568334, nil, nil, body_568335)

var shareSubscriptionsCreate* = Call_ShareSubscriptionsCreate_568322(
    name: "shareSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsCreate_568323, base: "",
    url: url_ShareSubscriptionsCreate_568324, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsGet_568310 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsGet_568312(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsGet_568311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a shareSubscription in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  var valid_568315 = path.getOrDefault("shareSubscriptionName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "shareSubscriptionName", valid_568315
  var valid_568316 = path.getOrDefault("accountName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "accountName", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_ShareSubscriptionsGet_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a shareSubscription in an account
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_ShareSubscriptionsGet_568310;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string): Recallable =
  ## shareSubscriptionsGet
  ## Get a shareSubscription in an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  add(path_568320, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_568320, "accountName", newJString(accountName))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var shareSubscriptionsGet* = Call_ShareSubscriptionsGet_568310(
    name: "shareSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsGet_568311, base: "",
    url: url_ShareSubscriptionsGet_568312, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsDelete_568336 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsDelete_568338(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsDelete_568337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a shareSubscription in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
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
  var valid_568341 = path.getOrDefault("shareSubscriptionName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "shareSubscriptionName", valid_568341
  var valid_568342 = path.getOrDefault("accountName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "accountName", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_ShareSubscriptionsDelete_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a shareSubscription in an account
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_ShareSubscriptionsDelete_568336;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string): Recallable =
  ## shareSubscriptionsDelete
  ## Delete a shareSubscription in an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  add(path_568346, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_568346, "accountName", newJString(accountName))
  result = call_568345.call(path_568346, query_568347, nil, nil, nil)

var shareSubscriptionsDelete* = Call_ShareSubscriptionsDelete_568336(
    name: "shareSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsDelete_568337, base: "",
    url: url_ShareSubscriptionsDelete_568338, schemes: {Scheme.Https})
type
  Call_ConsumerSourceDataSetsListByShareSubscription_568348 = ref object of OpenApiRestCall_567667
proc url_ConsumerSourceDataSetsListByShareSubscription_568350(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/ConsumerSourceDataSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerSourceDataSetsListByShareSubscription_568349(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get source dataSets of a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
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
  var valid_568353 = path.getOrDefault("shareSubscriptionName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "shareSubscriptionName", valid_568353
  var valid_568354 = path.getOrDefault("accountName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "accountName", valid_568354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568355 = query.getOrDefault("api-version")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "api-version", valid_568355
  var valid_568356 = query.getOrDefault("$skipToken")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "$skipToken", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_ConsumerSourceDataSetsListByShareSubscription_568348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get source dataSets of a shareSubscription
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_ConsumerSourceDataSetsListByShareSubscription_568348;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## consumerSourceDataSetsListByShareSubscription
  ## Get source dataSets of a shareSubscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  add(path_568359, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_568360, "$skipToken", newJString(SkipToken))
  add(path_568359, "accountName", newJString(accountName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var consumerSourceDataSetsListByShareSubscription* = Call_ConsumerSourceDataSetsListByShareSubscription_568348(
    name: "consumerSourceDataSetsListByShareSubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/ConsumerSourceDataSets",
    validator: validate_ConsumerSourceDataSetsListByShareSubscription_568349,
    base: "", url: url_ConsumerSourceDataSetsListByShareSubscription_568350,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsSynchronize_568361 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsSynchronize_568363(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/Synchronize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsSynchronize_568362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate a copy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of share subscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
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
  var valid_568366 = path.getOrDefault("shareSubscriptionName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "shareSubscriptionName", valid_568366
  var valid_568367 = path.getOrDefault("accountName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "accountName", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "api-version", valid_568368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   synchronize: JObject (required)
  ##              : Synchronize payload
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_ShareSubscriptionsSynchronize_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiate a copy
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_ShareSubscriptionsSynchronize_568361;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; synchronize: JsonNode; accountName: string): Recallable =
  ## shareSubscriptionsSynchronize
  ## Initiate a copy
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of share subscription
  ##   synchronize: JObject (required)
  ##              : Synchronize payload
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  var body_568374 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "shareSubscriptionName", newJString(shareSubscriptionName))
  if synchronize != nil:
    body_568374 = synchronize
  add(path_568372, "accountName", newJString(accountName))
  result = call_568371.call(path_568372, query_568373, nil, nil, body_568374)

var shareSubscriptionsSynchronize* = Call_ShareSubscriptionsSynchronize_568361(
    name: "shareSubscriptionsSynchronize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/Synchronize",
    validator: validate_ShareSubscriptionsSynchronize_568362, base: "",
    url: url_ShareSubscriptionsSynchronize_568363, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsCancelSynchronization_568375 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsCancelSynchronization_568377(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/cancelSynchronization")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsCancelSynchronization_568376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request to cancel a synchronization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  var valid_568380 = path.getOrDefault("shareSubscriptionName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "shareSubscriptionName", valid_568380
  var valid_568381 = path.getOrDefault("accountName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "accountName", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   shareSubscriptionSynchronization: JObject (required)
  ##                                   : Share Subscription Synchronization payload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_ShareSubscriptionsCancelSynchronization_568375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to cancel a synchronization.
  ## 
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_ShareSubscriptionsCancelSynchronization_568375;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string;
          shareSubscriptionSynchronization: JsonNode; accountName: string): Recallable =
  ## shareSubscriptionsCancelSynchronization
  ## Request to cancel a synchronization.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   shareSubscriptionSynchronization: JObject (required)
  ##                                   : Share Subscription Synchronization payload.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  var body_568388 = newJObject()
  add(path_568386, "resourceGroupName", newJString(resourceGroupName))
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "subscriptionId", newJString(subscriptionId))
  add(path_568386, "shareSubscriptionName", newJString(shareSubscriptionName))
  if shareSubscriptionSynchronization != nil:
    body_568388 = shareSubscriptionSynchronization
  add(path_568386, "accountName", newJString(accountName))
  result = call_568385.call(path_568386, query_568387, nil, nil, body_568388)

var shareSubscriptionsCancelSynchronization* = Call_ShareSubscriptionsCancelSynchronization_568375(
    name: "shareSubscriptionsCancelSynchronization", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/cancelSynchronization",
    validator: validate_ShareSubscriptionsCancelSynchronization_568376, base: "",
    url: url_ShareSubscriptionsCancelSynchronization_568377,
    schemes: {Scheme.Https})
type
  Call_DataSetMappingsListByShareSubscription_568389 = ref object of OpenApiRestCall_567667
proc url_DataSetMappingsListByShareSubscription_568391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/dataSetMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetMappingsListByShareSubscription_568390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List DataSetMappings in a share subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568392 = path.getOrDefault("resourceGroupName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "resourceGroupName", valid_568392
  var valid_568393 = path.getOrDefault("subscriptionId")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "subscriptionId", valid_568393
  var valid_568394 = path.getOrDefault("shareSubscriptionName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "shareSubscriptionName", valid_568394
  var valid_568395 = path.getOrDefault("accountName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "accountName", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  var valid_568397 = query.getOrDefault("$skipToken")
  valid_568397 = validateParameter(valid_568397, JString, required = false,
                                 default = nil)
  if valid_568397 != nil:
    section.add "$skipToken", valid_568397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568398: Call_DataSetMappingsListByShareSubscription_568389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List DataSetMappings in a share subscription
  ## 
  let valid = call_568398.validator(path, query, header, formData, body)
  let scheme = call_568398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568398.url(scheme.get, call_568398.host, call_568398.base,
                         call_568398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568398, url, valid)

proc call*(call_568399: Call_DataSetMappingsListByShareSubscription_568389;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## dataSetMappingsListByShareSubscription
  ## List DataSetMappings in a share subscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568400 = newJObject()
  var query_568401 = newJObject()
  add(path_568400, "resourceGroupName", newJString(resourceGroupName))
  add(query_568401, "api-version", newJString(apiVersion))
  add(path_568400, "subscriptionId", newJString(subscriptionId))
  add(path_568400, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_568401, "$skipToken", newJString(SkipToken))
  add(path_568400, "accountName", newJString(accountName))
  result = call_568399.call(path_568400, query_568401, nil, nil, nil)

var dataSetMappingsListByShareSubscription* = Call_DataSetMappingsListByShareSubscription_568389(
    name: "dataSetMappingsListByShareSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings",
    validator: validate_DataSetMappingsListByShareSubscription_568390, base: "",
    url: url_DataSetMappingsListByShareSubscription_568391,
    schemes: {Scheme.Https})
type
  Call_DataSetMappingsCreate_568415 = ref object of OpenApiRestCall_567667
proc url_DataSetMappingsCreate_568417(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  assert "dataSetMappingName" in path,
        "`dataSetMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/dataSetMappings/"),
               (kind: VariableSegment, value: "dataSetMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetMappingsCreate_568416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a DataSetMapping 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: JString (required)
  ##                     : The Id of the source data set being mapped.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568418 = path.getOrDefault("resourceGroupName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "resourceGroupName", valid_568418
  var valid_568419 = path.getOrDefault("dataSetMappingName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "dataSetMappingName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  var valid_568421 = path.getOrDefault("shareSubscriptionName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "shareSubscriptionName", valid_568421
  var valid_568422 = path.getOrDefault("accountName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "accountName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "api-version", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataSetMapping: JObject (required)
  ##                 : Destination data set configuration details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_DataSetMappingsCreate_568415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a DataSetMapping 
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_DataSetMappingsCreate_568415;
          resourceGroupName: string; apiVersion: string; dataSetMappingName: string;
          subscriptionId: string; shareSubscriptionName: string;
          dataSetMapping: JsonNode; accountName: string): Recallable =
  ## dataSetMappingsCreate
  ## Create a DataSetMapping 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   dataSetMappingName: string (required)
  ##                     : The Id of the source data set being mapped.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   dataSetMapping: JObject (required)
  ##                 : Destination data set configuration details.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  var body_568429 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  add(path_568427, "shareSubscriptionName", newJString(shareSubscriptionName))
  if dataSetMapping != nil:
    body_568429 = dataSetMapping
  add(path_568427, "accountName", newJString(accountName))
  result = call_568426.call(path_568427, query_568428, nil, nil, body_568429)

var dataSetMappingsCreate* = Call_DataSetMappingsCreate_568415(
    name: "dataSetMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsCreate_568416, base: "",
    url: url_DataSetMappingsCreate_568417, schemes: {Scheme.Https})
type
  Call_DataSetMappingsGet_568402 = ref object of OpenApiRestCall_567667
proc url_DataSetMappingsGet_568404(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  assert "dataSetMappingName" in path,
        "`dataSetMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/dataSetMappings/"),
               (kind: VariableSegment, value: "dataSetMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetMappingsGet_568403(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get a DataSetMapping in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: JString (required)
  ##                     : The name of the dataSetMapping.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568405 = path.getOrDefault("resourceGroupName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "resourceGroupName", valid_568405
  var valid_568406 = path.getOrDefault("dataSetMappingName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "dataSetMappingName", valid_568406
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  var valid_568408 = path.getOrDefault("shareSubscriptionName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "shareSubscriptionName", valid_568408
  var valid_568409 = path.getOrDefault("accountName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "accountName", valid_568409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568410 = query.getOrDefault("api-version")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "api-version", valid_568410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568411: Call_DataSetMappingsGet_568402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a DataSetMapping in a shareSubscription
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_DataSetMappingsGet_568402; resourceGroupName: string;
          apiVersion: string; dataSetMappingName: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string): Recallable =
  ## dataSetMappingsGet
  ## Get a DataSetMapping in a shareSubscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   dataSetMappingName: string (required)
  ##                     : The name of the dataSetMapping.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  add(path_568413, "resourceGroupName", newJString(resourceGroupName))
  add(query_568414, "api-version", newJString(apiVersion))
  add(path_568413, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_568413, "subscriptionId", newJString(subscriptionId))
  add(path_568413, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_568413, "accountName", newJString(accountName))
  result = call_568412.call(path_568413, query_568414, nil, nil, nil)

var dataSetMappingsGet* = Call_DataSetMappingsGet_568402(
    name: "dataSetMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsGet_568403, base: "",
    url: url_DataSetMappingsGet_568404, schemes: {Scheme.Https})
type
  Call_DataSetMappingsDelete_568430 = ref object of OpenApiRestCall_567667
proc url_DataSetMappingsDelete_568432(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  assert "dataSetMappingName" in path,
        "`dataSetMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/dataSetMappings/"),
               (kind: VariableSegment, value: "dataSetMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetMappingsDelete_568431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a DataSetMapping in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: JString (required)
  ##                     : The name of the dataSetMapping.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568433 = path.getOrDefault("resourceGroupName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "resourceGroupName", valid_568433
  var valid_568434 = path.getOrDefault("dataSetMappingName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "dataSetMappingName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("shareSubscriptionName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "shareSubscriptionName", valid_568436
  var valid_568437 = path.getOrDefault("accountName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "accountName", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "api-version", valid_568438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_DataSetMappingsDelete_568430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a DataSetMapping in a shareSubscription
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_DataSetMappingsDelete_568430;
          resourceGroupName: string; apiVersion: string; dataSetMappingName: string;
          subscriptionId: string; shareSubscriptionName: string; accountName: string): Recallable =
  ## dataSetMappingsDelete
  ## Delete a DataSetMapping in a shareSubscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   dataSetMappingName: string (required)
  ##                     : The name of the dataSetMapping.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(path_568441, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_568441, "accountName", newJString(accountName))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var dataSetMappingsDelete* = Call_DataSetMappingsDelete_568430(
    name: "dataSetMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsDelete_568431, base: "",
    url: url_DataSetMappingsDelete_568432, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSourceShareSynchronizationSettings_568443 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsListSourceShareSynchronizationSettings_568445(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"), (
        kind: ConstantSegment, value: "/listSourceShareSynchronizationSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsListSourceShareSynchronizationSettings_568444(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get synchronization settings set on a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  var valid_568448 = path.getOrDefault("shareSubscriptionName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "shareSubscriptionName", valid_568448
  var valid_568449 = path.getOrDefault("accountName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "accountName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  var valid_568451 = query.getOrDefault("$skipToken")
  valid_568451 = validateParameter(valid_568451, JString, required = false,
                                 default = nil)
  if valid_568451 != nil:
    section.add "$skipToken", valid_568451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568452: Call_ShareSubscriptionsListSourceShareSynchronizationSettings_568443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get synchronization settings set on a share
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_ShareSubscriptionsListSourceShareSynchronizationSettings_568443;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListSourceShareSynchronizationSettings
  ## Get synchronization settings set on a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  add(path_568454, "resourceGroupName", newJString(resourceGroupName))
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "subscriptionId", newJString(subscriptionId))
  add(path_568454, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_568455, "$skipToken", newJString(SkipToken))
  add(path_568454, "accountName", newJString(accountName))
  result = call_568453.call(path_568454, query_568455, nil, nil, nil)

var shareSubscriptionsListSourceShareSynchronizationSettings* = Call_ShareSubscriptionsListSourceShareSynchronizationSettings_568443(
    name: "shareSubscriptionsListSourceShareSynchronizationSettings",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSourceShareSynchronizationSettings", validator: validate_ShareSubscriptionsListSourceShareSynchronizationSettings_568444,
    base: "", url: url_ShareSubscriptionsListSourceShareSynchronizationSettings_568445,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSynchronizationDetails_568456 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsListSynchronizationDetails_568458(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/listSynchronizationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsListSynchronizationDetails_568457(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronization details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("shareSubscriptionName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "shareSubscriptionName", valid_568461
  var valid_568462 = path.getOrDefault("accountName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "accountName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  var valid_568464 = query.getOrDefault("$skipToken")
  valid_568464 = validateParameter(valid_568464, JString, required = false,
                                 default = nil)
  if valid_568464 != nil:
    section.add "$skipToken", valid_568464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   shareSubscriptionSynchronization: JObject (required)
  ##                                   : Share Subscription Synchronization payload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568466: Call_ShareSubscriptionsListSynchronizationDetails_568456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronization details
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_ShareSubscriptionsListSynchronizationDetails_568456;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string;
          shareSubscriptionSynchronization: JsonNode; accountName: string;
          SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListSynchronizationDetails
  ## List synchronization details
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   shareSubscriptionSynchronization: JObject (required)
  ##                                   : Share Subscription Synchronization payload.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568468 = newJObject()
  var query_568469 = newJObject()
  var body_568470 = newJObject()
  add(path_568468, "resourceGroupName", newJString(resourceGroupName))
  add(query_568469, "api-version", newJString(apiVersion))
  add(path_568468, "subscriptionId", newJString(subscriptionId))
  add(path_568468, "shareSubscriptionName", newJString(shareSubscriptionName))
  if shareSubscriptionSynchronization != nil:
    body_568470 = shareSubscriptionSynchronization
  add(query_568469, "$skipToken", newJString(SkipToken))
  add(path_568468, "accountName", newJString(accountName))
  result = call_568467.call(path_568468, query_568469, nil, nil, body_568470)

var shareSubscriptionsListSynchronizationDetails* = Call_ShareSubscriptionsListSynchronizationDetails_568456(
    name: "shareSubscriptionsListSynchronizationDetails",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSynchronizationDetails",
    validator: validate_ShareSubscriptionsListSynchronizationDetails_568457,
    base: "", url: url_ShareSubscriptionsListSynchronizationDetails_568458,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSynchronizations_568471 = ref object of OpenApiRestCall_567667
proc url_ShareSubscriptionsListSynchronizations_568473(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/listSynchronizations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShareSubscriptionsListSynchronizations_568472(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronizations of a share subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568474 = path.getOrDefault("resourceGroupName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "resourceGroupName", valid_568474
  var valid_568475 = path.getOrDefault("subscriptionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "subscriptionId", valid_568475
  var valid_568476 = path.getOrDefault("shareSubscriptionName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "shareSubscriptionName", valid_568476
  var valid_568477 = path.getOrDefault("accountName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "accountName", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  var valid_568479 = query.getOrDefault("$skipToken")
  valid_568479 = validateParameter(valid_568479, JString, required = false,
                                 default = nil)
  if valid_568479 != nil:
    section.add "$skipToken", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_ShareSubscriptionsListSynchronizations_568471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronizations of a share subscription
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_ShareSubscriptionsListSynchronizations_568471;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListSynchronizations
  ## List synchronizations of a share subscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(path_568482, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_568483, "$skipToken", newJString(SkipToken))
  add(path_568482, "accountName", newJString(accountName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var shareSubscriptionsListSynchronizations* = Call_ShareSubscriptionsListSynchronizations_568471(
    name: "shareSubscriptionsListSynchronizations", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSynchronizations",
    validator: validate_ShareSubscriptionsListSynchronizations_568472, base: "",
    url: url_ShareSubscriptionsListSynchronizations_568473,
    schemes: {Scheme.Https})
type
  Call_TriggersListByShareSubscription_568484 = ref object of OpenApiRestCall_567667
proc url_TriggersListByShareSubscription_568486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersListByShareSubscription_568485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Triggers in a share subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("subscriptionId")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "subscriptionId", valid_568488
  var valid_568489 = path.getOrDefault("shareSubscriptionName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "shareSubscriptionName", valid_568489
  var valid_568490 = path.getOrDefault("accountName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "accountName", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
  var valid_568492 = query.getOrDefault("$skipToken")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = nil)
  if valid_568492 != nil:
    section.add "$skipToken", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_TriggersListByShareSubscription_568484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Triggers in a share subscription
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_TriggersListByShareSubscription_568484;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareSubscriptionName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## triggersListByShareSubscription
  ## List Triggers in a share subscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  add(path_568495, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_568496, "$skipToken", newJString(SkipToken))
  add(path_568495, "accountName", newJString(accountName))
  result = call_568494.call(path_568495, query_568496, nil, nil, nil)

var triggersListByShareSubscription* = Call_TriggersListByShareSubscription_568484(
    name: "triggersListByShareSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers",
    validator: validate_TriggersListByShareSubscription_568485, base: "",
    url: url_TriggersListByShareSubscription_568486, schemes: {Scheme.Https})
type
  Call_TriggersCreate_568510 = ref object of OpenApiRestCall_567667
proc url_TriggersCreate_568512(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersCreate_568511(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a Trigger 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   triggerName: JString (required)
  ##              : The name of the trigger.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("subscriptionId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "subscriptionId", valid_568514
  var valid_568515 = path.getOrDefault("shareSubscriptionName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "shareSubscriptionName", valid_568515
  var valid_568516 = path.getOrDefault("triggerName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "triggerName", valid_568516
  var valid_568517 = path.getOrDefault("accountName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "accountName", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   trigger: JObject (required)
  ##          : Trigger details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_TriggersCreate_568510; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Trigger 
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_TriggersCreate_568510; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareSubscriptionName: string;
          trigger: JsonNode; triggerName: string; accountName: string): Recallable =
  ## triggersCreate
  ## Create a Trigger 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   trigger: JObject (required)
  ##          : Trigger details.
  ##   triggerName: string (required)
  ##              : The name of the trigger.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  var body_568524 = newJObject()
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  add(path_568522, "shareSubscriptionName", newJString(shareSubscriptionName))
  if trigger != nil:
    body_568524 = trigger
  add(path_568522, "triggerName", newJString(triggerName))
  add(path_568522, "accountName", newJString(accountName))
  result = call_568521.call(path_568522, query_568523, nil, nil, body_568524)

var triggersCreate* = Call_TriggersCreate_568510(name: "triggersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
    validator: validate_TriggersCreate_568511, base: "", url: url_TriggersCreate_568512,
    schemes: {Scheme.Https})
type
  Call_TriggersGet_568497 = ref object of OpenApiRestCall_567667
proc url_TriggersGet_568499(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersGet_568498(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Trigger in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   triggerName: JString (required)
  ##              : The name of the trigger.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568500 = path.getOrDefault("resourceGroupName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceGroupName", valid_568500
  var valid_568501 = path.getOrDefault("subscriptionId")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "subscriptionId", valid_568501
  var valid_568502 = path.getOrDefault("shareSubscriptionName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "shareSubscriptionName", valid_568502
  var valid_568503 = path.getOrDefault("triggerName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "triggerName", valid_568503
  var valid_568504 = path.getOrDefault("accountName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "accountName", valid_568504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_TriggersGet_568497; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Trigger in a shareSubscription
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_TriggersGet_568497; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareSubscriptionName: string;
          triggerName: string; accountName: string): Recallable =
  ## triggersGet
  ## Get a Trigger in a shareSubscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   triggerName: string (required)
  ##              : The name of the trigger.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568508 = newJObject()
  var query_568509 = newJObject()
  add(path_568508, "resourceGroupName", newJString(resourceGroupName))
  add(query_568509, "api-version", newJString(apiVersion))
  add(path_568508, "subscriptionId", newJString(subscriptionId))
  add(path_568508, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_568508, "triggerName", newJString(triggerName))
  add(path_568508, "accountName", newJString(accountName))
  result = call_568507.call(path_568508, query_568509, nil, nil, nil)

var triggersGet* = Call_TriggersGet_568497(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_568498,
                                        base: "", url: url_TriggersGet_568499,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_568525 = ref object of OpenApiRestCall_567667
proc url_TriggersDelete_568527(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareSubscriptionName" in path,
        "`shareSubscriptionName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shareSubscriptions/"),
               (kind: VariableSegment, value: "shareSubscriptionName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersDelete_568526(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Trigger in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   triggerName: JString (required)
  ##              : The name of the trigger.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  var valid_568530 = path.getOrDefault("shareSubscriptionName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "shareSubscriptionName", valid_568530
  var valid_568531 = path.getOrDefault("triggerName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "triggerName", valid_568531
  var valid_568532 = path.getOrDefault("accountName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "accountName", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568534: Call_TriggersDelete_568525; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Trigger in a shareSubscription
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_TriggersDelete_568525; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareSubscriptionName: string;
          triggerName: string; accountName: string): Recallable =
  ## triggersDelete
  ## Delete a Trigger in a shareSubscription
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   triggerName: string (required)
  ##              : The name of the trigger.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  add(path_568536, "resourceGroupName", newJString(resourceGroupName))
  add(query_568537, "api-version", newJString(apiVersion))
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  add(path_568536, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_568536, "triggerName", newJString(triggerName))
  add(path_568536, "accountName", newJString(accountName))
  result = call_568535.call(path_568536, query_568537, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_568525(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_568526, base: "", url: url_TriggersDelete_568527,
    schemes: {Scheme.Https})
type
  Call_SharesListByAccount_568538 = ref object of OpenApiRestCall_567667
proc url_SharesListByAccount_568540(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesListByAccount_568539(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List shares in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568541 = path.getOrDefault("resourceGroupName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "resourceGroupName", valid_568541
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  var valid_568543 = path.getOrDefault("accountName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "accountName", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation Token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  var valid_568545 = query.getOrDefault("$skipToken")
  valid_568545 = validateParameter(valid_568545, JString, required = false,
                                 default = nil)
  if valid_568545 != nil:
    section.add "$skipToken", valid_568545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568546: Call_SharesListByAccount_568538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List shares in an account
  ## 
  let valid = call_568546.validator(path, query, header, formData, body)
  let scheme = call_568546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568546.url(scheme.get, call_568546.host, call_568546.base,
                         call_568546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568546, url, valid)

proc call*(call_568547: Call_SharesListByAccount_568538; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          SkipToken: string = ""): Recallable =
  ## sharesListByAccount
  ## List shares in an account
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   SkipToken: string
  ##            : Continuation Token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568548 = newJObject()
  var query_568549 = newJObject()
  add(path_568548, "resourceGroupName", newJString(resourceGroupName))
  add(query_568549, "api-version", newJString(apiVersion))
  add(path_568548, "subscriptionId", newJString(subscriptionId))
  add(query_568549, "$skipToken", newJString(SkipToken))
  add(path_568548, "accountName", newJString(accountName))
  result = call_568547.call(path_568548, query_568549, nil, nil, nil)

var sharesListByAccount* = Call_SharesListByAccount_568538(
    name: "sharesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares",
    validator: validate_SharesListByAccount_568539, base: "",
    url: url_SharesListByAccount_568540, schemes: {Scheme.Https})
type
  Call_SharesCreate_568562 = ref object of OpenApiRestCall_567667
proc url_SharesCreate_568564(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesCreate_568563(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a share 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568565 = path.getOrDefault("resourceGroupName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "resourceGroupName", valid_568565
  var valid_568566 = path.getOrDefault("subscriptionId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "subscriptionId", valid_568566
  var valid_568567 = path.getOrDefault("shareName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "shareName", valid_568567
  var valid_568568 = path.getOrDefault("accountName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "accountName", valid_568568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568569 = query.getOrDefault("api-version")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "api-version", valid_568569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   share: JObject (required)
  ##        : The share payload
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568571: Call_SharesCreate_568562; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a share 
  ## 
  let valid = call_568571.validator(path, query, header, formData, body)
  let scheme = call_568571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568571.url(scheme.get, call_568571.host, call_568571.base,
                         call_568571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568571, url, valid)

proc call*(call_568572: Call_SharesCreate_568562; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          share: JsonNode; accountName: string): Recallable =
  ## sharesCreate
  ## Create a share 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   share: JObject (required)
  ##        : The share payload
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568573 = newJObject()
  var query_568574 = newJObject()
  var body_568575 = newJObject()
  add(path_568573, "resourceGroupName", newJString(resourceGroupName))
  add(query_568574, "api-version", newJString(apiVersion))
  add(path_568573, "subscriptionId", newJString(subscriptionId))
  add(path_568573, "shareName", newJString(shareName))
  if share != nil:
    body_568575 = share
  add(path_568573, "accountName", newJString(accountName))
  result = call_568572.call(path_568573, query_568574, nil, nil, body_568575)

var sharesCreate* = Call_SharesCreate_568562(name: "sharesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
    validator: validate_SharesCreate_568563, base: "", url: url_SharesCreate_568564,
    schemes: {Scheme.Https})
type
  Call_SharesGet_568550 = ref object of OpenApiRestCall_567667
proc url_SharesGet_568552(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesGet_568551(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a share 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to retrieve.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568553 = path.getOrDefault("resourceGroupName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "resourceGroupName", valid_568553
  var valid_568554 = path.getOrDefault("subscriptionId")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "subscriptionId", valid_568554
  var valid_568555 = path.getOrDefault("shareName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "shareName", valid_568555
  var valid_568556 = path.getOrDefault("accountName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "accountName", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568558: Call_SharesGet_568550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a share 
  ## 
  let valid = call_568558.validator(path, query, header, formData, body)
  let scheme = call_568558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568558.url(scheme.get, call_568558.host, call_568558.base,
                         call_568558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568558, url, valid)

proc call*(call_568559: Call_SharesGet_568550; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          accountName: string): Recallable =
  ## sharesGet
  ## Get a share 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to retrieve.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568560 = newJObject()
  var query_568561 = newJObject()
  add(path_568560, "resourceGroupName", newJString(resourceGroupName))
  add(query_568561, "api-version", newJString(apiVersion))
  add(path_568560, "subscriptionId", newJString(subscriptionId))
  add(path_568560, "shareName", newJString(shareName))
  add(path_568560, "accountName", newJString(accountName))
  result = call_568559.call(path_568560, query_568561, nil, nil, nil)

var sharesGet* = Call_SharesGet_568550(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
                                    validator: validate_SharesGet_568551,
                                    base: "", url: url_SharesGet_568552,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_568576 = ref object of OpenApiRestCall_567667
proc url_SharesDelete_568578(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesDelete_568577(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a share 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568579 = path.getOrDefault("resourceGroupName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "resourceGroupName", valid_568579
  var valid_568580 = path.getOrDefault("subscriptionId")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "subscriptionId", valid_568580
  var valid_568581 = path.getOrDefault("shareName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "shareName", valid_568581
  var valid_568582 = path.getOrDefault("accountName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "accountName", valid_568582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568583 = query.getOrDefault("api-version")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "api-version", valid_568583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568584: Call_SharesDelete_568576; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a share 
  ## 
  let valid = call_568584.validator(path, query, header, formData, body)
  let scheme = call_568584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568584.url(scheme.get, call_568584.host, call_568584.base,
                         call_568584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568584, url, valid)

proc call*(call_568585: Call_SharesDelete_568576; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          accountName: string): Recallable =
  ## sharesDelete
  ## Delete a share 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568586 = newJObject()
  var query_568587 = newJObject()
  add(path_568586, "resourceGroupName", newJString(resourceGroupName))
  add(query_568587, "api-version", newJString(apiVersion))
  add(path_568586, "subscriptionId", newJString(subscriptionId))
  add(path_568586, "shareName", newJString(shareName))
  add(path_568586, "accountName", newJString(accountName))
  result = call_568585.call(path_568586, query_568587, nil, nil, nil)

var sharesDelete* = Call_SharesDelete_568576(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
    validator: validate_SharesDelete_568577, base: "", url: url_SharesDelete_568578,
    schemes: {Scheme.Https})
type
  Call_DataSetsListByShare_568588 = ref object of OpenApiRestCall_567667
proc url_DataSetsListByShare_568590(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/dataSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetsListByShare_568589(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List DataSets in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568591 = path.getOrDefault("resourceGroupName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "resourceGroupName", valid_568591
  var valid_568592 = path.getOrDefault("subscriptionId")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "subscriptionId", valid_568592
  var valid_568593 = path.getOrDefault("shareName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "shareName", valid_568593
  var valid_568594 = path.getOrDefault("accountName")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "accountName", valid_568594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568595 = query.getOrDefault("api-version")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "api-version", valid_568595
  var valid_568596 = query.getOrDefault("$skipToken")
  valid_568596 = validateParameter(valid_568596, JString, required = false,
                                 default = nil)
  if valid_568596 != nil:
    section.add "$skipToken", valid_568596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568597: Call_DataSetsListByShare_568588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List DataSets in a share
  ## 
  let valid = call_568597.validator(path, query, header, formData, body)
  let scheme = call_568597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568597.url(scheme.get, call_568597.host, call_568597.base,
                         call_568597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568597, url, valid)

proc call*(call_568598: Call_DataSetsListByShare_568588; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          accountName: string; SkipToken: string = ""): Recallable =
  ## dataSetsListByShare
  ## List DataSets in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   SkipToken: string
  ##            : continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568599 = newJObject()
  var query_568600 = newJObject()
  add(path_568599, "resourceGroupName", newJString(resourceGroupName))
  add(query_568600, "api-version", newJString(apiVersion))
  add(path_568599, "subscriptionId", newJString(subscriptionId))
  add(path_568599, "shareName", newJString(shareName))
  add(query_568600, "$skipToken", newJString(SkipToken))
  add(path_568599, "accountName", newJString(accountName))
  result = call_568598.call(path_568599, query_568600, nil, nil, nil)

var dataSetsListByShare* = Call_DataSetsListByShare_568588(
    name: "dataSetsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets",
    validator: validate_DataSetsListByShare_568589, base: "",
    url: url_DataSetsListByShare_568590, schemes: {Scheme.Https})
type
  Call_DataSetsCreate_568614 = ref object of OpenApiRestCall_567667
proc url_DataSetsCreate_568616(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "dataSetName" in path, "`dataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/dataSets/"),
               (kind: VariableSegment, value: "dataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetsCreate_568615(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a DataSet 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to add the data set to.
  ##   dataSetName: JString (required)
  ##              : The name of the dataSet.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568617 = path.getOrDefault("resourceGroupName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "resourceGroupName", valid_568617
  var valid_568618 = path.getOrDefault("subscriptionId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "subscriptionId", valid_568618
  var valid_568619 = path.getOrDefault("shareName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "shareName", valid_568619
  var valid_568620 = path.getOrDefault("dataSetName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "dataSetName", valid_568620
  var valid_568621 = path.getOrDefault("accountName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "accountName", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
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
  ## parameters in `body` object:
  ##   dataSet: JObject (required)
  ##          : The new data set information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568624: Call_DataSetsCreate_568614; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a DataSet 
  ## 
  let valid = call_568624.validator(path, query, header, formData, body)
  let scheme = call_568624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568624.url(scheme.get, call_568624.host, call_568624.base,
                         call_568624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568624, url, valid)

proc call*(call_568625: Call_DataSetsCreate_568614; resourceGroupName: string;
          apiVersion: string; dataSet: JsonNode; subscriptionId: string;
          shareName: string; dataSetName: string; accountName: string): Recallable =
  ## dataSetsCreate
  ## Create a DataSet 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   dataSet: JObject (required)
  ##          : The new data set information.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to add the data set to.
  ##   dataSetName: string (required)
  ##              : The name of the dataSet.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568626 = newJObject()
  var query_568627 = newJObject()
  var body_568628 = newJObject()
  add(path_568626, "resourceGroupName", newJString(resourceGroupName))
  add(query_568627, "api-version", newJString(apiVersion))
  if dataSet != nil:
    body_568628 = dataSet
  add(path_568626, "subscriptionId", newJString(subscriptionId))
  add(path_568626, "shareName", newJString(shareName))
  add(path_568626, "dataSetName", newJString(dataSetName))
  add(path_568626, "accountName", newJString(accountName))
  result = call_568625.call(path_568626, query_568627, nil, nil, body_568628)

var dataSetsCreate* = Call_DataSetsCreate_568614(name: "dataSetsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
    validator: validate_DataSetsCreate_568615, base: "", url: url_DataSetsCreate_568616,
    schemes: {Scheme.Https})
type
  Call_DataSetsGet_568601 = ref object of OpenApiRestCall_567667
proc url_DataSetsGet_568603(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "dataSetName" in path, "`dataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/dataSets/"),
               (kind: VariableSegment, value: "dataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetsGet_568602(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a DataSet in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   dataSetName: JString (required)
  ##              : The name of the dataSet.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568604 = path.getOrDefault("resourceGroupName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "resourceGroupName", valid_568604
  var valid_568605 = path.getOrDefault("subscriptionId")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "subscriptionId", valid_568605
  var valid_568606 = path.getOrDefault("shareName")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "shareName", valid_568606
  var valid_568607 = path.getOrDefault("dataSetName")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "dataSetName", valid_568607
  var valid_568608 = path.getOrDefault("accountName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "accountName", valid_568608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568609 = query.getOrDefault("api-version")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "api-version", valid_568609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568610: Call_DataSetsGet_568601; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a DataSet in a share
  ## 
  let valid = call_568610.validator(path, query, header, formData, body)
  let scheme = call_568610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568610.url(scheme.get, call_568610.host, call_568610.base,
                         call_568610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568610, url, valid)

proc call*(call_568611: Call_DataSetsGet_568601; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          dataSetName: string; accountName: string): Recallable =
  ## dataSetsGet
  ## Get a DataSet in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   dataSetName: string (required)
  ##              : The name of the dataSet.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568612 = newJObject()
  var query_568613 = newJObject()
  add(path_568612, "resourceGroupName", newJString(resourceGroupName))
  add(query_568613, "api-version", newJString(apiVersion))
  add(path_568612, "subscriptionId", newJString(subscriptionId))
  add(path_568612, "shareName", newJString(shareName))
  add(path_568612, "dataSetName", newJString(dataSetName))
  add(path_568612, "accountName", newJString(accountName))
  result = call_568611.call(path_568612, query_568613, nil, nil, nil)

var dataSetsGet* = Call_DataSetsGet_568601(name: "dataSetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
                                        validator: validate_DataSetsGet_568602,
                                        base: "", url: url_DataSetsGet_568603,
                                        schemes: {Scheme.Https})
type
  Call_DataSetsDelete_568629 = ref object of OpenApiRestCall_567667
proc url_DataSetsDelete_568631(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "dataSetName" in path, "`dataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/dataSets/"),
               (kind: VariableSegment, value: "dataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSetsDelete_568630(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a DataSet in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   dataSetName: JString (required)
  ##              : The name of the dataSet.
  ##   accountName: JString (required)
  ##              : The name of the share account.
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
  var valid_568634 = path.getOrDefault("shareName")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "shareName", valid_568634
  var valid_568635 = path.getOrDefault("dataSetName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "dataSetName", valid_568635
  var valid_568636 = path.getOrDefault("accountName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "accountName", valid_568636
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568637 = query.getOrDefault("api-version")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "api-version", valid_568637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568638: Call_DataSetsDelete_568629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a DataSet in a share
  ## 
  let valid = call_568638.validator(path, query, header, formData, body)
  let scheme = call_568638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568638.url(scheme.get, call_568638.host, call_568638.base,
                         call_568638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568638, url, valid)

proc call*(call_568639: Call_DataSetsDelete_568629; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          dataSetName: string; accountName: string): Recallable =
  ## dataSetsDelete
  ## Delete a DataSet in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   dataSetName: string (required)
  ##              : The name of the dataSet.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568640 = newJObject()
  var query_568641 = newJObject()
  add(path_568640, "resourceGroupName", newJString(resourceGroupName))
  add(query_568641, "api-version", newJString(apiVersion))
  add(path_568640, "subscriptionId", newJString(subscriptionId))
  add(path_568640, "shareName", newJString(shareName))
  add(path_568640, "dataSetName", newJString(dataSetName))
  add(path_568640, "accountName", newJString(accountName))
  result = call_568639.call(path_568640, query_568641, nil, nil, nil)

var dataSetsDelete* = Call_DataSetsDelete_568629(name: "dataSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
    validator: validate_DataSetsDelete_568630, base: "", url: url_DataSetsDelete_568631,
    schemes: {Scheme.Https})
type
  Call_InvitationsListByShare_568642 = ref object of OpenApiRestCall_567667
proc url_InvitationsListByShare_568644(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/invitations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvitationsListByShare_568643(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List invitations in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568645 = path.getOrDefault("resourceGroupName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "resourceGroupName", valid_568645
  var valid_568646 = path.getOrDefault("subscriptionId")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "subscriptionId", valid_568646
  var valid_568647 = path.getOrDefault("shareName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "shareName", valid_568647
  var valid_568648 = path.getOrDefault("accountName")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "accountName", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : The continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  var valid_568650 = query.getOrDefault("$skipToken")
  valid_568650 = validateParameter(valid_568650, JString, required = false,
                                 default = nil)
  if valid_568650 != nil:
    section.add "$skipToken", valid_568650
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568651: Call_InvitationsListByShare_568642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List invitations in a share
  ## 
  let valid = call_568651.validator(path, query, header, formData, body)
  let scheme = call_568651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568651.url(scheme.get, call_568651.host, call_568651.base,
                         call_568651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568651, url, valid)

proc call*(call_568652: Call_InvitationsListByShare_568642;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## invitationsListByShare
  ## List invitations in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   SkipToken: string
  ##            : The continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568653 = newJObject()
  var query_568654 = newJObject()
  add(path_568653, "resourceGroupName", newJString(resourceGroupName))
  add(query_568654, "api-version", newJString(apiVersion))
  add(path_568653, "subscriptionId", newJString(subscriptionId))
  add(path_568653, "shareName", newJString(shareName))
  add(query_568654, "$skipToken", newJString(SkipToken))
  add(path_568653, "accountName", newJString(accountName))
  result = call_568652.call(path_568653, query_568654, nil, nil, nil)

var invitationsListByShare* = Call_InvitationsListByShare_568642(
    name: "invitationsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations",
    validator: validate_InvitationsListByShare_568643, base: "",
    url: url_InvitationsListByShare_568644, schemes: {Scheme.Https})
type
  Call_InvitationsCreate_568668 = ref object of OpenApiRestCall_567667
proc url_InvitationsCreate_568670(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "invitationName" in path, "`invitationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/invitations/"),
               (kind: VariableSegment, value: "invitationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvitationsCreate_568669(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create an invitation 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   invitationName: JString (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to send the invitation for.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568671 = path.getOrDefault("resourceGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "resourceGroupName", valid_568671
  var valid_568672 = path.getOrDefault("invitationName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "invitationName", valid_568672
  var valid_568673 = path.getOrDefault("subscriptionId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "subscriptionId", valid_568673
  var valid_568674 = path.getOrDefault("shareName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "shareName", valid_568674
  var valid_568675 = path.getOrDefault("accountName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "accountName", valid_568675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568676 = query.getOrDefault("api-version")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "api-version", valid_568676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   invitation: JObject (required)
  ##             : Invitation details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568678: Call_InvitationsCreate_568668; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an invitation 
  ## 
  let valid = call_568678.validator(path, query, header, formData, body)
  let scheme = call_568678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568678.url(scheme.get, call_568678.host, call_568678.base,
                         call_568678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568678, url, valid)

proc call*(call_568679: Call_InvitationsCreate_568668; resourceGroupName: string;
          apiVersion: string; invitation: JsonNode; invitationName: string;
          subscriptionId: string; shareName: string; accountName: string): Recallable =
  ## invitationsCreate
  ## Create an invitation 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitation: JObject (required)
  ##             : Invitation details.
  ##   invitationName: string (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to send the invitation for.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568680 = newJObject()
  var query_568681 = newJObject()
  var body_568682 = newJObject()
  add(path_568680, "resourceGroupName", newJString(resourceGroupName))
  add(query_568681, "api-version", newJString(apiVersion))
  if invitation != nil:
    body_568682 = invitation
  add(path_568680, "invitationName", newJString(invitationName))
  add(path_568680, "subscriptionId", newJString(subscriptionId))
  add(path_568680, "shareName", newJString(shareName))
  add(path_568680, "accountName", newJString(accountName))
  result = call_568679.call(path_568680, query_568681, nil, nil, body_568682)

var invitationsCreate* = Call_InvitationsCreate_568668(name: "invitationsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsCreate_568669, base: "",
    url: url_InvitationsCreate_568670, schemes: {Scheme.Https})
type
  Call_InvitationsGet_568655 = ref object of OpenApiRestCall_567667
proc url_InvitationsGet_568657(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "invitationName" in path, "`invitationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/invitations/"),
               (kind: VariableSegment, value: "invitationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvitationsGet_568656(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get an invitation in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   invitationName: JString (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568658 = path.getOrDefault("resourceGroupName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "resourceGroupName", valid_568658
  var valid_568659 = path.getOrDefault("invitationName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "invitationName", valid_568659
  var valid_568660 = path.getOrDefault("subscriptionId")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "subscriptionId", valid_568660
  var valid_568661 = path.getOrDefault("shareName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "shareName", valid_568661
  var valid_568662 = path.getOrDefault("accountName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "accountName", valid_568662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568663 = query.getOrDefault("api-version")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "api-version", valid_568663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568664: Call_InvitationsGet_568655; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an invitation in a share
  ## 
  let valid = call_568664.validator(path, query, header, formData, body)
  let scheme = call_568664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568664.url(scheme.get, call_568664.host, call_568664.base,
                         call_568664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568664, url, valid)

proc call*(call_568665: Call_InvitationsGet_568655; resourceGroupName: string;
          apiVersion: string; invitationName: string; subscriptionId: string;
          shareName: string; accountName: string): Recallable =
  ## invitationsGet
  ## Get an invitation in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitationName: string (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568666 = newJObject()
  var query_568667 = newJObject()
  add(path_568666, "resourceGroupName", newJString(resourceGroupName))
  add(query_568667, "api-version", newJString(apiVersion))
  add(path_568666, "invitationName", newJString(invitationName))
  add(path_568666, "subscriptionId", newJString(subscriptionId))
  add(path_568666, "shareName", newJString(shareName))
  add(path_568666, "accountName", newJString(accountName))
  result = call_568665.call(path_568666, query_568667, nil, nil, nil)

var invitationsGet* = Call_InvitationsGet_568655(name: "invitationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsGet_568656, base: "", url: url_InvitationsGet_568657,
    schemes: {Scheme.Https})
type
  Call_InvitationsDelete_568683 = ref object of OpenApiRestCall_567667
proc url_InvitationsDelete_568685(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "invitationName" in path, "`invitationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/invitations/"),
               (kind: VariableSegment, value: "invitationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvitationsDelete_568684(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an invitation in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   invitationName: JString (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568686 = path.getOrDefault("resourceGroupName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "resourceGroupName", valid_568686
  var valid_568687 = path.getOrDefault("invitationName")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "invitationName", valid_568687
  var valid_568688 = path.getOrDefault("subscriptionId")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "subscriptionId", valid_568688
  var valid_568689 = path.getOrDefault("shareName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "shareName", valid_568689
  var valid_568690 = path.getOrDefault("accountName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "accountName", valid_568690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568691 = query.getOrDefault("api-version")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "api-version", valid_568691
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568692: Call_InvitationsDelete_568683; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an invitation in a share
  ## 
  let valid = call_568692.validator(path, query, header, formData, body)
  let scheme = call_568692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568692.url(scheme.get, call_568692.host, call_568692.base,
                         call_568692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568692, url, valid)

proc call*(call_568693: Call_InvitationsDelete_568683; resourceGroupName: string;
          apiVersion: string; invitationName: string; subscriptionId: string;
          shareName: string; accountName: string): Recallable =
  ## invitationsDelete
  ## Delete an invitation in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitationName: string (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568694 = newJObject()
  var query_568695 = newJObject()
  add(path_568694, "resourceGroupName", newJString(resourceGroupName))
  add(query_568695, "api-version", newJString(apiVersion))
  add(path_568694, "invitationName", newJString(invitationName))
  add(path_568694, "subscriptionId", newJString(subscriptionId))
  add(path_568694, "shareName", newJString(shareName))
  add(path_568694, "accountName", newJString(accountName))
  result = call_568693.call(path_568694, query_568695, nil, nil, nil)

var invitationsDelete* = Call_InvitationsDelete_568683(name: "invitationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsDelete_568684, base: "",
    url: url_InvitationsDelete_568685, schemes: {Scheme.Https})
type
  Call_SharesListSynchronizationDetails_568696 = ref object of OpenApiRestCall_567667
proc url_SharesListSynchronizationDetails_568698(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/listSynchronizationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesListSynchronizationDetails_568697(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronization details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568699 = path.getOrDefault("resourceGroupName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "resourceGroupName", valid_568699
  var valid_568700 = path.getOrDefault("subscriptionId")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "subscriptionId", valid_568700
  var valid_568701 = path.getOrDefault("shareName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "shareName", valid_568701
  var valid_568702 = path.getOrDefault("accountName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "accountName", valid_568702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568703 = query.getOrDefault("api-version")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "api-version", valid_568703
  var valid_568704 = query.getOrDefault("$skipToken")
  valid_568704 = validateParameter(valid_568704, JString, required = false,
                                 default = nil)
  if valid_568704 != nil:
    section.add "$skipToken", valid_568704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   shareSynchronization: JObject (required)
  ##                       : Share Synchronization payload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568706: Call_SharesListSynchronizationDetails_568696;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronization details
  ## 
  let valid = call_568706.validator(path, query, header, formData, body)
  let scheme = call_568706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568706.url(scheme.get, call_568706.host, call_568706.base,
                         call_568706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568706, url, valid)

proc call*(call_568707: Call_SharesListSynchronizationDetails_568696;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; shareSynchronization: JsonNode; accountName: string;
          SkipToken: string = ""): Recallable =
  ## sharesListSynchronizationDetails
  ## List synchronization details
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   shareSynchronization: JObject (required)
  ##                       : Share Synchronization payload.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568708 = newJObject()
  var query_568709 = newJObject()
  var body_568710 = newJObject()
  add(path_568708, "resourceGroupName", newJString(resourceGroupName))
  add(query_568709, "api-version", newJString(apiVersion))
  add(path_568708, "subscriptionId", newJString(subscriptionId))
  add(path_568708, "shareName", newJString(shareName))
  if shareSynchronization != nil:
    body_568710 = shareSynchronization
  add(query_568709, "$skipToken", newJString(SkipToken))
  add(path_568708, "accountName", newJString(accountName))
  result = call_568707.call(path_568708, query_568709, nil, nil, body_568710)

var sharesListSynchronizationDetails* = Call_SharesListSynchronizationDetails_568696(
    name: "sharesListSynchronizationDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/listSynchronizationDetails",
    validator: validate_SharesListSynchronizationDetails_568697, base: "",
    url: url_SharesListSynchronizationDetails_568698, schemes: {Scheme.Https})
type
  Call_SharesListSynchronizations_568711 = ref object of OpenApiRestCall_567667
proc url_SharesListSynchronizations_568713(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/listSynchronizations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesListSynchronizations_568712(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronizations of a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568714 = path.getOrDefault("resourceGroupName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "resourceGroupName", valid_568714
  var valid_568715 = path.getOrDefault("subscriptionId")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "subscriptionId", valid_568715
  var valid_568716 = path.getOrDefault("shareName")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "shareName", valid_568716
  var valid_568717 = path.getOrDefault("accountName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "accountName", valid_568717
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568718 = query.getOrDefault("api-version")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "api-version", valid_568718
  var valid_568719 = query.getOrDefault("$skipToken")
  valid_568719 = validateParameter(valid_568719, JString, required = false,
                                 default = nil)
  if valid_568719 != nil:
    section.add "$skipToken", valid_568719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568720: Call_SharesListSynchronizations_568711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List synchronizations of a share
  ## 
  let valid = call_568720.validator(path, query, header, formData, body)
  let scheme = call_568720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568720.url(scheme.get, call_568720.host, call_568720.base,
                         call_568720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568720, url, valid)

proc call*(call_568721: Call_SharesListSynchronizations_568711;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## sharesListSynchronizations
  ## List synchronizations of a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   SkipToken: string
  ##            : Continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568722 = newJObject()
  var query_568723 = newJObject()
  add(path_568722, "resourceGroupName", newJString(resourceGroupName))
  add(query_568723, "api-version", newJString(apiVersion))
  add(path_568722, "subscriptionId", newJString(subscriptionId))
  add(path_568722, "shareName", newJString(shareName))
  add(query_568723, "$skipToken", newJString(SkipToken))
  add(path_568722, "accountName", newJString(accountName))
  result = call_568721.call(path_568722, query_568723, nil, nil, nil)

var sharesListSynchronizations* = Call_SharesListSynchronizations_568711(
    name: "sharesListSynchronizations", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/listSynchronizations",
    validator: validate_SharesListSynchronizations_568712, base: "",
    url: url_SharesListSynchronizations_568713, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsListByShare_568724 = ref object of OpenApiRestCall_567667
proc url_ProviderShareSubscriptionsListByShare_568726(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/providerShareSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderShareSubscriptionsListByShare_568725(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List share subscriptions in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568727 = path.getOrDefault("resourceGroupName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "resourceGroupName", valid_568727
  var valid_568728 = path.getOrDefault("subscriptionId")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "subscriptionId", valid_568728
  var valid_568729 = path.getOrDefault("shareName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "shareName", valid_568729
  var valid_568730 = path.getOrDefault("accountName")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "accountName", valid_568730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation Token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568731 = query.getOrDefault("api-version")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "api-version", valid_568731
  var valid_568732 = query.getOrDefault("$skipToken")
  valid_568732 = validateParameter(valid_568732, JString, required = false,
                                 default = nil)
  if valid_568732 != nil:
    section.add "$skipToken", valid_568732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568733: Call_ProviderShareSubscriptionsListByShare_568724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List share subscriptions in a provider share
  ## 
  let valid = call_568733.validator(path, query, header, formData, body)
  let scheme = call_568733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568733.url(scheme.get, call_568733.host, call_568733.base,
                         call_568733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568733, url, valid)

proc call*(call_568734: Call_ProviderShareSubscriptionsListByShare_568724;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## providerShareSubscriptionsListByShare
  ## List share subscriptions in a provider share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   SkipToken: string
  ##            : Continuation Token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568735 = newJObject()
  var query_568736 = newJObject()
  add(path_568735, "resourceGroupName", newJString(resourceGroupName))
  add(query_568736, "api-version", newJString(apiVersion))
  add(path_568735, "subscriptionId", newJString(subscriptionId))
  add(path_568735, "shareName", newJString(shareName))
  add(query_568736, "$skipToken", newJString(SkipToken))
  add(path_568735, "accountName", newJString(accountName))
  result = call_568734.call(path_568735, query_568736, nil, nil, nil)

var providerShareSubscriptionsListByShare* = Call_ProviderShareSubscriptionsListByShare_568724(
    name: "providerShareSubscriptionsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions",
    validator: validate_ProviderShareSubscriptionsListByShare_568725, base: "",
    url: url_ProviderShareSubscriptionsListByShare_568726, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsGetByShare_568737 = ref object of OpenApiRestCall_567667
proc url_ProviderShareSubscriptionsGetByShare_568739(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "providerShareSubscriptionId" in path,
        "`providerShareSubscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/providerShareSubscriptions/"),
               (kind: VariableSegment, value: "providerShareSubscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderShareSubscriptionsGetByShare_568738(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get share subscription in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   providerShareSubscriptionId: JString (required)
  ##                              : To locate shareSubscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568740 = path.getOrDefault("resourceGroupName")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "resourceGroupName", valid_568740
  var valid_568741 = path.getOrDefault("subscriptionId")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "subscriptionId", valid_568741
  var valid_568742 = path.getOrDefault("shareName")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "shareName", valid_568742
  var valid_568743 = path.getOrDefault("providerShareSubscriptionId")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "providerShareSubscriptionId", valid_568743
  var valid_568744 = path.getOrDefault("accountName")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "accountName", valid_568744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568745 = query.getOrDefault("api-version")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "api-version", valid_568745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568746: Call_ProviderShareSubscriptionsGetByShare_568737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get share subscription in a provider share
  ## 
  let valid = call_568746.validator(path, query, header, formData, body)
  let scheme = call_568746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568746.url(scheme.get, call_568746.host, call_568746.base,
                         call_568746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568746, url, valid)

proc call*(call_568747: Call_ProviderShareSubscriptionsGetByShare_568737;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; providerShareSubscriptionId: string;
          accountName: string): Recallable =
  ## providerShareSubscriptionsGetByShare
  ## Get share subscription in a provider share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   providerShareSubscriptionId: string (required)
  ##                              : To locate shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568748 = newJObject()
  var query_568749 = newJObject()
  add(path_568748, "resourceGroupName", newJString(resourceGroupName))
  add(query_568749, "api-version", newJString(apiVersion))
  add(path_568748, "subscriptionId", newJString(subscriptionId))
  add(path_568748, "shareName", newJString(shareName))
  add(path_568748, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_568748, "accountName", newJString(accountName))
  result = call_568747.call(path_568748, query_568749, nil, nil, nil)

var providerShareSubscriptionsGetByShare* = Call_ProviderShareSubscriptionsGetByShare_568737(
    name: "providerShareSubscriptionsGetByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}",
    validator: validate_ProviderShareSubscriptionsGetByShare_568738, base: "",
    url: url_ProviderShareSubscriptionsGetByShare_568739, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsReinstate_568750 = ref object of OpenApiRestCall_567667
proc url_ProviderShareSubscriptionsReinstate_568752(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "providerShareSubscriptionId" in path,
        "`providerShareSubscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/providerShareSubscriptions/"),
               (kind: VariableSegment, value: "providerShareSubscriptionId"),
               (kind: ConstantSegment, value: "/reinstate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderShareSubscriptionsReinstate_568751(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reinstate share subscription in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   providerShareSubscriptionId: JString (required)
  ##                              : To locate shareSubscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568753 = path.getOrDefault("resourceGroupName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "resourceGroupName", valid_568753
  var valid_568754 = path.getOrDefault("subscriptionId")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "subscriptionId", valid_568754
  var valid_568755 = path.getOrDefault("shareName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "shareName", valid_568755
  var valid_568756 = path.getOrDefault("providerShareSubscriptionId")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "providerShareSubscriptionId", valid_568756
  var valid_568757 = path.getOrDefault("accountName")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "accountName", valid_568757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568758 = query.getOrDefault("api-version")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "api-version", valid_568758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568759: Call_ProviderShareSubscriptionsReinstate_568750;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reinstate share subscription in a provider share
  ## 
  let valid = call_568759.validator(path, query, header, formData, body)
  let scheme = call_568759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568759.url(scheme.get, call_568759.host, call_568759.base,
                         call_568759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568759, url, valid)

proc call*(call_568760: Call_ProviderShareSubscriptionsReinstate_568750;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; providerShareSubscriptionId: string;
          accountName: string): Recallable =
  ## providerShareSubscriptionsReinstate
  ## Reinstate share subscription in a provider share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   providerShareSubscriptionId: string (required)
  ##                              : To locate shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568761 = newJObject()
  var query_568762 = newJObject()
  add(path_568761, "resourceGroupName", newJString(resourceGroupName))
  add(query_568762, "api-version", newJString(apiVersion))
  add(path_568761, "subscriptionId", newJString(subscriptionId))
  add(path_568761, "shareName", newJString(shareName))
  add(path_568761, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_568761, "accountName", newJString(accountName))
  result = call_568760.call(path_568761, query_568762, nil, nil, nil)

var providerShareSubscriptionsReinstate* = Call_ProviderShareSubscriptionsReinstate_568750(
    name: "providerShareSubscriptionsReinstate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}/reinstate",
    validator: validate_ProviderShareSubscriptionsReinstate_568751, base: "",
    url: url_ProviderShareSubscriptionsReinstate_568752, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsRevoke_568763 = ref object of OpenApiRestCall_567667
proc url_ProviderShareSubscriptionsRevoke_568765(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "providerShareSubscriptionId" in path,
        "`providerShareSubscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/providerShareSubscriptions/"),
               (kind: VariableSegment, value: "providerShareSubscriptionId"),
               (kind: ConstantSegment, value: "/revoke")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderShareSubscriptionsRevoke_568764(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke share subscription in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   providerShareSubscriptionId: JString (required)
  ##                              : To locate shareSubscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_568768 = path.getOrDefault("shareName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "shareName", valid_568768
  var valid_568769 = path.getOrDefault("providerShareSubscriptionId")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "providerShareSubscriptionId", valid_568769
  var valid_568770 = path.getOrDefault("accountName")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "accountName", valid_568770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
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

proc call*(call_568772: Call_ProviderShareSubscriptionsRevoke_568763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke share subscription in a provider share
  ## 
  let valid = call_568772.validator(path, query, header, formData, body)
  let scheme = call_568772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568772.url(scheme.get, call_568772.host, call_568772.base,
                         call_568772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568772, url, valid)

proc call*(call_568773: Call_ProviderShareSubscriptionsRevoke_568763;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; providerShareSubscriptionId: string;
          accountName: string): Recallable =
  ## providerShareSubscriptionsRevoke
  ## Revoke share subscription in a provider share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   providerShareSubscriptionId: string (required)
  ##                              : To locate shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568774 = newJObject()
  var query_568775 = newJObject()
  add(path_568774, "resourceGroupName", newJString(resourceGroupName))
  add(query_568775, "api-version", newJString(apiVersion))
  add(path_568774, "subscriptionId", newJString(subscriptionId))
  add(path_568774, "shareName", newJString(shareName))
  add(path_568774, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_568774, "accountName", newJString(accountName))
  result = call_568773.call(path_568774, query_568775, nil, nil, nil)

var providerShareSubscriptionsRevoke* = Call_ProviderShareSubscriptionsRevoke_568763(
    name: "providerShareSubscriptionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}/revoke",
    validator: validate_ProviderShareSubscriptionsRevoke_568764, base: "",
    url: url_ProviderShareSubscriptionsRevoke_568765, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsListByShare_568776 = ref object of OpenApiRestCall_567667
proc url_SynchronizationSettingsListByShare_568778(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/synchronizationSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynchronizationSettingsListByShare_568777(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronizationSettings in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568779 = path.getOrDefault("resourceGroupName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "resourceGroupName", valid_568779
  var valid_568780 = path.getOrDefault("subscriptionId")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "subscriptionId", valid_568780
  var valid_568781 = path.getOrDefault("shareName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "shareName", valid_568781
  var valid_568782 = path.getOrDefault("accountName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "accountName", valid_568782
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568783 = query.getOrDefault("api-version")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "api-version", valid_568783
  var valid_568784 = query.getOrDefault("$skipToken")
  valid_568784 = validateParameter(valid_568784, JString, required = false,
                                 default = nil)
  if valid_568784 != nil:
    section.add "$skipToken", valid_568784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568785: Call_SynchronizationSettingsListByShare_568776;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronizationSettings in a share
  ## 
  let valid = call_568785.validator(path, query, header, formData, body)
  let scheme = call_568785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568785.url(scheme.get, call_568785.host, call_568785.base,
                         call_568785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568785, url, valid)

proc call*(call_568786: Call_SynchronizationSettingsListByShare_568776;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          shareName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## synchronizationSettingsListByShare
  ## List synchronizationSettings in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   SkipToken: string
  ##            : continuation token
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568787 = newJObject()
  var query_568788 = newJObject()
  add(path_568787, "resourceGroupName", newJString(resourceGroupName))
  add(query_568788, "api-version", newJString(apiVersion))
  add(path_568787, "subscriptionId", newJString(subscriptionId))
  add(path_568787, "shareName", newJString(shareName))
  add(query_568788, "$skipToken", newJString(SkipToken))
  add(path_568787, "accountName", newJString(accountName))
  result = call_568786.call(path_568787, query_568788, nil, nil, nil)

var synchronizationSettingsListByShare* = Call_SynchronizationSettingsListByShare_568776(
    name: "synchronizationSettingsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings",
    validator: validate_SynchronizationSettingsListByShare_568777, base: "",
    url: url_SynchronizationSettingsListByShare_568778, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsCreate_568802 = ref object of OpenApiRestCall_567667
proc url_SynchronizationSettingsCreate_568804(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "synchronizationSettingName" in path,
        "`synchronizationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/synchronizationSettings/"),
               (kind: VariableSegment, value: "synchronizationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynchronizationSettingsCreate_568803(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a synchronizationSetting 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   synchronizationSettingName: JString (required)
  ##                             : The name of the synchronizationSetting.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to add the synchronization setting to.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568805 = path.getOrDefault("resourceGroupName")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "resourceGroupName", valid_568805
  var valid_568806 = path.getOrDefault("synchronizationSettingName")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "synchronizationSettingName", valid_568806
  var valid_568807 = path.getOrDefault("subscriptionId")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "subscriptionId", valid_568807
  var valid_568808 = path.getOrDefault("shareName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "shareName", valid_568808
  var valid_568809 = path.getOrDefault("accountName")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "accountName", valid_568809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568810 = query.getOrDefault("api-version")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "api-version", valid_568810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   synchronizationSetting: JObject (required)
  ##                         : The new synchronization setting information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568812: Call_SynchronizationSettingsCreate_568802; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a synchronizationSetting 
  ## 
  let valid = call_568812.validator(path, query, header, formData, body)
  let scheme = call_568812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568812.url(scheme.get, call_568812.host, call_568812.base,
                         call_568812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568812, url, valid)

proc call*(call_568813: Call_SynchronizationSettingsCreate_568802;
          resourceGroupName: string; synchronizationSettingName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          synchronizationSetting: JsonNode; accountName: string): Recallable =
  ## synchronizationSettingsCreate
  ## Create or update a synchronizationSetting 
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   synchronizationSettingName: string (required)
  ##                             : The name of the synchronizationSetting.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to add the synchronization setting to.
  ##   synchronizationSetting: JObject (required)
  ##                         : The new synchronization setting information.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568814 = newJObject()
  var query_568815 = newJObject()
  var body_568816 = newJObject()
  add(path_568814, "resourceGroupName", newJString(resourceGroupName))
  add(path_568814, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(query_568815, "api-version", newJString(apiVersion))
  add(path_568814, "subscriptionId", newJString(subscriptionId))
  add(path_568814, "shareName", newJString(shareName))
  if synchronizationSetting != nil:
    body_568816 = synchronizationSetting
  add(path_568814, "accountName", newJString(accountName))
  result = call_568813.call(path_568814, query_568815, nil, nil, body_568816)

var synchronizationSettingsCreate* = Call_SynchronizationSettingsCreate_568802(
    name: "synchronizationSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsCreate_568803, base: "",
    url: url_SynchronizationSettingsCreate_568804, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsGet_568789 = ref object of OpenApiRestCall_567667
proc url_SynchronizationSettingsGet_568791(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "synchronizationSettingName" in path,
        "`synchronizationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/synchronizationSettings/"),
               (kind: VariableSegment, value: "synchronizationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynchronizationSettingsGet_568790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a synchronizationSetting in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   synchronizationSettingName: JString (required)
  ##                             : The name of the synchronizationSetting.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568792 = path.getOrDefault("resourceGroupName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "resourceGroupName", valid_568792
  var valid_568793 = path.getOrDefault("synchronizationSettingName")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "synchronizationSettingName", valid_568793
  var valid_568794 = path.getOrDefault("subscriptionId")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "subscriptionId", valid_568794
  var valid_568795 = path.getOrDefault("shareName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "shareName", valid_568795
  var valid_568796 = path.getOrDefault("accountName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "accountName", valid_568796
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568797 = query.getOrDefault("api-version")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "api-version", valid_568797
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568798: Call_SynchronizationSettingsGet_568789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a synchronizationSetting in a share
  ## 
  let valid = call_568798.validator(path, query, header, formData, body)
  let scheme = call_568798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568798.url(scheme.get, call_568798.host, call_568798.base,
                         call_568798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568798, url, valid)

proc call*(call_568799: Call_SynchronizationSettingsGet_568789;
          resourceGroupName: string; synchronizationSettingName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          accountName: string): Recallable =
  ## synchronizationSettingsGet
  ## Get a synchronizationSetting in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   synchronizationSettingName: string (required)
  ##                             : The name of the synchronizationSetting.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568800 = newJObject()
  var query_568801 = newJObject()
  add(path_568800, "resourceGroupName", newJString(resourceGroupName))
  add(path_568800, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(query_568801, "api-version", newJString(apiVersion))
  add(path_568800, "subscriptionId", newJString(subscriptionId))
  add(path_568800, "shareName", newJString(shareName))
  add(path_568800, "accountName", newJString(accountName))
  result = call_568799.call(path_568800, query_568801, nil, nil, nil)

var synchronizationSettingsGet* = Call_SynchronizationSettingsGet_568789(
    name: "synchronizationSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsGet_568790, base: "",
    url: url_SynchronizationSettingsGet_568791, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsDelete_568817 = ref object of OpenApiRestCall_567667
proc url_SynchronizationSettingsDelete_568819(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  assert "synchronizationSettingName" in path,
        "`synchronizationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataShare/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/synchronizationSettings/"),
               (kind: VariableSegment, value: "synchronizationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynchronizationSettingsDelete_568818(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a synchronizationSetting in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   synchronizationSettingName: JString (required)
  ##                             : The name of the synchronizationSetting .
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568820 = path.getOrDefault("resourceGroupName")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "resourceGroupName", valid_568820
  var valid_568821 = path.getOrDefault("synchronizationSettingName")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "synchronizationSettingName", valid_568821
  var valid_568822 = path.getOrDefault("subscriptionId")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "subscriptionId", valid_568822
  var valid_568823 = path.getOrDefault("shareName")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "shareName", valid_568823
  var valid_568824 = path.getOrDefault("accountName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "accountName", valid_568824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568825 = query.getOrDefault("api-version")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "api-version", valid_568825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568826: Call_SynchronizationSettingsDelete_568817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a synchronizationSetting in a share
  ## 
  let valid = call_568826.validator(path, query, header, formData, body)
  let scheme = call_568826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568826.url(scheme.get, call_568826.host, call_568826.base,
                         call_568826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568826, url, valid)

proc call*(call_568827: Call_SynchronizationSettingsDelete_568817;
          resourceGroupName: string; synchronizationSettingName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          accountName: string): Recallable =
  ## synchronizationSettingsDelete
  ## Delete a synchronizationSetting in a share
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   synchronizationSettingName: string (required)
  ##                             : The name of the synchronizationSetting .
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_568828 = newJObject()
  var query_568829 = newJObject()
  add(path_568828, "resourceGroupName", newJString(resourceGroupName))
  add(path_568828, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(query_568829, "api-version", newJString(apiVersion))
  add(path_568828, "subscriptionId", newJString(subscriptionId))
  add(path_568828, "shareName", newJString(shareName))
  add(path_568828, "accountName", newJString(accountName))
  result = call_568827.call(path_568828, query_568829, nil, nil, nil)

var synchronizationSettingsDelete* = Call_SynchronizationSettingsDelete_568817(
    name: "synchronizationSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsDelete_568818, base: "",
    url: url_SynchronizationSettingsDelete_568819, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
