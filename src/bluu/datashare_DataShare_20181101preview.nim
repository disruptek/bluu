
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "datashare-DataShare"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConsumerInvitationsListInvitations_563787 = ref object of OpenApiRestCall_563565
proc url_ConsumerInvitationsListInvitations_563789(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConsumerInvitationsListInvitations_563788(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists invitations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_563951 = query.getOrDefault("$skipToken")
  valid_563951 = validateParameter(valid_563951, JString, required = false,
                                 default = nil)
  if valid_563951 != nil:
    section.add "$skipToken", valid_563951
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563952 = query.getOrDefault("api-version")
  valid_563952 = validateParameter(valid_563952, JString, required = true,
                                 default = nil)
  if valid_563952 != nil:
    section.add "api-version", valid_563952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563975: Call_ConsumerInvitationsListInvitations_563787;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists invitations
  ## 
  let valid = call_563975.validator(path, query, header, formData, body)
  let scheme = call_563975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563975.url(scheme.get, call_563975.host, call_563975.base,
                         call_563975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563975, url, valid)

proc call*(call_564046: Call_ConsumerInvitationsListInvitations_563787;
          apiVersion: string; SkipToken: string = ""): Recallable =
  ## consumerInvitationsListInvitations
  ## Lists invitations
  ##   SkipToken: string
  ##            : The continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  var query_564047 = newJObject()
  add(query_564047, "$skipToken", newJString(SkipToken))
  add(query_564047, "api-version", newJString(apiVersion))
  result = call_564046.call(nil, query_564047, nil, nil, nil)

var consumerInvitationsListInvitations* = Call_ConsumerInvitationsListInvitations_563787(
    name: "consumerInvitationsListInvitations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DataShare/ListInvitations",
    validator: validate_ConsumerInvitationsListInvitations_563788, base: "",
    url: url_ConsumerInvitationsListInvitations_563789, schemes: {Scheme.Https})
type
  Call_ConsumerInvitationsRejectInvitation_564087 = ref object of OpenApiRestCall_563565
proc url_ConsumerInvitationsRejectInvitation_564089(protocol: Scheme; host: string;
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

proc validate_ConsumerInvitationsRejectInvitation_564088(path: JsonNode;
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
  var valid_564104 = path.getOrDefault("location")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "location", valid_564104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564105 = query.getOrDefault("api-version")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "api-version", valid_564105
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

proc call*(call_564107: Call_ConsumerInvitationsRejectInvitation_564087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reject an invitation
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_ConsumerInvitationsRejectInvitation_564087;
          apiVersion: string; location: string; invitation: JsonNode): Recallable =
  ## consumerInvitationsRejectInvitation
  ## Reject an invitation
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   location: string (required)
  ##           : Location of the invitation
  ##   invitation: JObject (required)
  ##             : An invitation payload
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  var body_564111 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "location", newJString(location))
  if invitation != nil:
    body_564111 = invitation
  result = call_564108.call(path_564109, query_564110, nil, nil, body_564111)

var consumerInvitationsRejectInvitation* = Call_ConsumerInvitationsRejectInvitation_564087(
    name: "consumerInvitationsRejectInvitation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.DataShare/locations/{location}/RejectInvitation",
    validator: validate_ConsumerInvitationsRejectInvitation_564088, base: "",
    url: url_ConsumerInvitationsRejectInvitation_564089, schemes: {Scheme.Https})
type
  Call_ConsumerInvitationsGet_564112 = ref object of OpenApiRestCall_563565
proc url_ConsumerInvitationsGet_564114(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerInvitationsGet_564113(path: JsonNode; query: JsonNode;
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
  var valid_564115 = path.getOrDefault("invitationId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "invitationId", valid_564115
  var valid_564116 = path.getOrDefault("location")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "location", valid_564116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_ConsumerInvitationsGet_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an invitation
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_ConsumerInvitationsGet_564112; invitationId: string;
          apiVersion: string; location: string): Recallable =
  ## consumerInvitationsGet
  ## Get an invitation
  ##   invitationId: string (required)
  ##               : An invitation id
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   location: string (required)
  ##           : Location of the invitation
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(path_564120, "invitationId", newJString(invitationId))
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "location", newJString(location))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var consumerInvitationsGet* = Call_ConsumerInvitationsGet_564112(
    name: "consumerInvitationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.DataShare/locations/{location}/consumerInvitations/{invitationId}",
    validator: validate_ConsumerInvitationsGet_564113, base: "",
    url: url_ConsumerInvitationsGet_564114, schemes: {Scheme.Https})
type
  Call_OperationsList_564122 = ref object of OpenApiRestCall_563565
proc url_OperationsList_564124(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564123(path: JsonNode; query: JsonNode;
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

proc call*(call_564126: Call_OperationsList_564122; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of available operations
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_OperationsList_564122; apiVersion: string): Recallable =
  ## operationsList
  ## List of available operations
  ##   apiVersion: string (required)
  ##             : The api version to use.
  var query_564128 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  result = call_564127.call(nil, query_564128, nil, nil, nil)

var operationsList* = Call_OperationsList_564122(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataShare/operations",
    validator: validate_OperationsList_564123, base: "", url: url_OperationsList_564124,
    schemes: {Scheme.Https})
type
  Call_AccountsListBySubscription_564129 = ref object of OpenApiRestCall_563565
proc url_AccountsListBySubscription_564131(protocol: Scheme; host: string;
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

proc validate_AccountsListBySubscription_564130(path: JsonNode; query: JsonNode;
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
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564133 = query.getOrDefault("$skipToken")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "$skipToken", valid_564133
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_AccountsListBySubscription_564129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Accounts in Subscription
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_AccountsListBySubscription_564129; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## accountsListBySubscription
  ## List Accounts in Subscription
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "$skipToken", newJString(SkipToken))
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var accountsListBySubscription* = Call_AccountsListBySubscription_564129(
    name: "accountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataShare/accounts",
    validator: validate_AccountsListBySubscription_564130, base: "",
    url: url_AccountsListBySubscription_564131, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_564139 = ref object of OpenApiRestCall_563565
proc url_AccountsListByResourceGroup_564141(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_564140(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Accounts in ResourceGroup
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564144 = query.getOrDefault("$skipToken")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "$skipToken", valid_564144
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_AccountsListByResourceGroup_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Accounts in ResourceGroup
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_AccountsListByResourceGroup_564139;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""): Recallable =
  ## accountsListByResourceGroup
  ## List Accounts in ResourceGroup
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(query_564149, "$skipToken", newJString(SkipToken))
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_564139(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts",
    validator: validate_AccountsListByResourceGroup_564140, base: "",
    url: url_AccountsListByResourceGroup_564141, schemes: {Scheme.Https})
type
  Call_AccountsCreate_564161 = ref object of OpenApiRestCall_563565
proc url_AccountsCreate_564163(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreate_564162(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  var valid_564166 = path.getOrDefault("accountName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "accountName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
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

proc call*(call_564169: Call_AccountsCreate_564161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an account
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_AccountsCreate_564161; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; account: JsonNode;
          accountName: string): Recallable =
  ## accountsCreate
  ## Create an account
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   account: JObject (required)
  ##          : The account payload.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  var body_564173 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  if account != nil:
    body_564173 = account
  add(path_564171, "accountName", newJString(accountName))
  result = call_564170.call(path_564171, query_564172, nil, nil, body_564173)

var accountsCreate* = Call_AccountsCreate_564161(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsCreate_564162, base: "", url: url_AccountsCreate_564163,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_564150 = ref object of OpenApiRestCall_563565
proc url_AccountsGet_564152(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_564151(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroupName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroupName", valid_564154
  var valid_564155 = path.getOrDefault("accountName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "accountName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_AccountsGet_564150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an account
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_AccountsGet_564150; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountsGet
  ## Get an account
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "resourceGroupName", newJString(resourceGroupName))
  add(path_564159, "accountName", newJString(accountName))
  result = call_564158.call(path_564159, query_564160, nil, nil, nil)

var accountsGet* = Call_AccountsGet_564150(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
                                        validator: validate_AccountsGet_564151,
                                        base: "", url: url_AccountsGet_564152,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_564185 = ref object of OpenApiRestCall_563565
proc url_AccountsUpdate_564187(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsUpdate_564186(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Patch an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  var valid_564190 = path.getOrDefault("accountName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "accountName", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564191 = query.getOrDefault("api-version")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "api-version", valid_564191
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

proc call*(call_564193: Call_AccountsUpdate_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch an account
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_AccountsUpdate_564185;
          accountUpdateParameters: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountsUpdate
  ## Patch an account
  ##   accountUpdateParameters: JObject (required)
  ##                          : The account update parameters.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  var body_564197 = newJObject()
  if accountUpdateParameters != nil:
    body_564197 = accountUpdateParameters
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  add(path_564195, "accountName", newJString(accountName))
  result = call_564194.call(path_564195, query_564196, nil, nil, body_564197)

var accountsUpdate* = Call_AccountsUpdate_564185(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsUpdate_564186, base: "", url: url_AccountsUpdate_564187,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_564174 = ref object of OpenApiRestCall_563565
proc url_AccountsDelete_564176(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_564175(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## DeleteAccount
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("resourceGroupName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "resourceGroupName", valid_564178
  var valid_564179 = path.getOrDefault("accountName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "accountName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
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
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_AccountsDelete_564174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## DeleteAccount
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_AccountsDelete_564174; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## accountsDelete
  ## DeleteAccount
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  add(path_564183, "accountName", newJString(accountName))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_564174(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsDelete_564175, base: "", url: url_AccountsDelete_564176,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListByAccount_564198 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsListByAccount_564200(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsListByAccount_564199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List share subscriptions in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564201 = path.getOrDefault("subscriptionId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "subscriptionId", valid_564201
  var valid_564202 = path.getOrDefault("resourceGroupName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceGroupName", valid_564202
  var valid_564203 = path.getOrDefault("accountName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "accountName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation Token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564204 = query.getOrDefault("$skipToken")
  valid_564204 = validateParameter(valid_564204, JString, required = false,
                                 default = nil)
  if valid_564204 != nil:
    section.add "$skipToken", valid_564204
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_ShareSubscriptionsListByAccount_564198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List share subscriptions in an account
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_ShareSubscriptionsListByAccount_564198;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListByAccount
  ## List share subscriptions in an account
  ##   SkipToken: string
  ##            : Continuation Token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  add(query_564209, "$skipToken", newJString(SkipToken))
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  add(path_564208, "accountName", newJString(accountName))
  result = call_564207.call(path_564208, query_564209, nil, nil, nil)

var shareSubscriptionsListByAccount* = Call_ShareSubscriptionsListByAccount_564198(
    name: "shareSubscriptionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions",
    validator: validate_ShareSubscriptionsListByAccount_564199, base: "",
    url: url_ShareSubscriptionsListByAccount_564200, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsCreate_564222 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsCreate_564224(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsCreate_564223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a shareSubscription in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564225 = path.getOrDefault("shareSubscriptionName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "shareSubscriptionName", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("accountName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "accountName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
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

proc call*(call_564231: Call_ShareSubscriptionsCreate_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a shareSubscription in an account
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ShareSubscriptionsCreate_564222; apiVersion: string;
          shareSubscription: JsonNode; shareSubscriptionName: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## shareSubscriptionsCreate
  ## Create a shareSubscription in an account
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscription: JObject (required)
  ##                    : create parameters for shareSubscription
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  var body_564235 = newJObject()
  add(query_564234, "api-version", newJString(apiVersion))
  if shareSubscription != nil:
    body_564235 = shareSubscription
  add(path_564233, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "accountName", newJString(accountName))
  result = call_564232.call(path_564233, query_564234, nil, nil, body_564235)

var shareSubscriptionsCreate* = Call_ShareSubscriptionsCreate_564222(
    name: "shareSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsCreate_564223, base: "",
    url: url_ShareSubscriptionsCreate_564224, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsGet_564210 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsGet_564212(protocol: Scheme; host: string; base: string;
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

proc validate_ShareSubscriptionsGet_564211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a shareSubscription in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564213 = path.getOrDefault("shareSubscriptionName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "shareSubscriptionName", valid_564213
  var valid_564214 = path.getOrDefault("subscriptionId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "subscriptionId", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  var valid_564216 = path.getOrDefault("accountName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "accountName", valid_564216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564217 = query.getOrDefault("api-version")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "api-version", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_ShareSubscriptionsGet_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a shareSubscription in an account
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_ShareSubscriptionsGet_564210; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## shareSubscriptionsGet
  ## Get a shareSubscription in an account
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "accountName", newJString(accountName))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var shareSubscriptionsGet* = Call_ShareSubscriptionsGet_564210(
    name: "shareSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsGet_564211, base: "",
    url: url_ShareSubscriptionsGet_564212, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsDelete_564236 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsDelete_564238(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsDelete_564237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a shareSubscription in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564239 = path.getOrDefault("shareSubscriptionName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "shareSubscriptionName", valid_564239
  var valid_564240 = path.getOrDefault("subscriptionId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "subscriptionId", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  var valid_564242 = path.getOrDefault("accountName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "accountName", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "api-version", valid_564243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564244: Call_ShareSubscriptionsDelete_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a shareSubscription in an account
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_ShareSubscriptionsDelete_564236; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## shareSubscriptionsDelete
  ## Delete a shareSubscription in an account
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564246 = newJObject()
  var query_564247 = newJObject()
  add(query_564247, "api-version", newJString(apiVersion))
  add(path_564246, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(path_564246, "resourceGroupName", newJString(resourceGroupName))
  add(path_564246, "accountName", newJString(accountName))
  result = call_564245.call(path_564246, query_564247, nil, nil, nil)

var shareSubscriptionsDelete* = Call_ShareSubscriptionsDelete_564236(
    name: "shareSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsDelete_564237, base: "",
    url: url_ShareSubscriptionsDelete_564238, schemes: {Scheme.Https})
type
  Call_ConsumerSourceDataSetsListByShareSubscription_564248 = ref object of OpenApiRestCall_563565
proc url_ConsumerSourceDataSetsListByShareSubscription_564250(protocol: Scheme;
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

proc validate_ConsumerSourceDataSetsListByShareSubscription_564249(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get source dataSets of a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564251 = path.getOrDefault("shareSubscriptionName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "shareSubscriptionName", valid_564251
  var valid_564252 = path.getOrDefault("subscriptionId")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "subscriptionId", valid_564252
  var valid_564253 = path.getOrDefault("resourceGroupName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "resourceGroupName", valid_564253
  var valid_564254 = path.getOrDefault("accountName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "accountName", valid_564254
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564255 = query.getOrDefault("$skipToken")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = nil)
  if valid_564255 != nil:
    section.add "$skipToken", valid_564255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_ConsumerSourceDataSetsListByShareSubscription_564248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get source dataSets of a shareSubscription
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_ConsumerSourceDataSetsListByShareSubscription_564248;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## consumerSourceDataSetsListByShareSubscription
  ## Get source dataSets of a shareSubscription
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(query_564260, "$skipToken", newJString(SkipToken))
  add(query_564260, "api-version", newJString(apiVersion))
  add(path_564259, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564259, "subscriptionId", newJString(subscriptionId))
  add(path_564259, "resourceGroupName", newJString(resourceGroupName))
  add(path_564259, "accountName", newJString(accountName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var consumerSourceDataSetsListByShareSubscription* = Call_ConsumerSourceDataSetsListByShareSubscription_564248(
    name: "consumerSourceDataSetsListByShareSubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/ConsumerSourceDataSets",
    validator: validate_ConsumerSourceDataSetsListByShareSubscription_564249,
    base: "", url: url_ConsumerSourceDataSetsListByShareSubscription_564250,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsSynchronize_564261 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsSynchronize_564263(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsSynchronize_564262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate a copy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of share subscription
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564264 = path.getOrDefault("shareSubscriptionName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "shareSubscriptionName", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("resourceGroupName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "resourceGroupName", valid_564266
  var valid_564267 = path.getOrDefault("accountName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "accountName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "api-version", valid_564268
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

proc call*(call_564270: Call_ShareSubscriptionsSynchronize_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiate a copy
  ## 
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_ShareSubscriptionsSynchronize_564261;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          synchronize: JsonNode; resourceGroupName: string; accountName: string): Recallable =
  ## shareSubscriptionsSynchronize
  ## Initiate a copy
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of share subscription
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   synchronize: JObject (required)
  ##              : Synchronize payload
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  var body_564274 = newJObject()
  add(query_564273, "api-version", newJString(apiVersion))
  add(path_564272, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564272, "subscriptionId", newJString(subscriptionId))
  if synchronize != nil:
    body_564274 = synchronize
  add(path_564272, "resourceGroupName", newJString(resourceGroupName))
  add(path_564272, "accountName", newJString(accountName))
  result = call_564271.call(path_564272, query_564273, nil, nil, body_564274)

var shareSubscriptionsSynchronize* = Call_ShareSubscriptionsSynchronize_564261(
    name: "shareSubscriptionsSynchronize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/Synchronize",
    validator: validate_ShareSubscriptionsSynchronize_564262, base: "",
    url: url_ShareSubscriptionsSynchronize_564263, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsCancelSynchronization_564275 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsCancelSynchronization_564277(protocol: Scheme;
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

proc validate_ShareSubscriptionsCancelSynchronization_564276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request to cancel a synchronization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564278 = path.getOrDefault("shareSubscriptionName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "shareSubscriptionName", valid_564278
  var valid_564279 = path.getOrDefault("subscriptionId")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "subscriptionId", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  var valid_564281 = path.getOrDefault("accountName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "accountName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "api-version", valid_564282
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

proc call*(call_564284: Call_ShareSubscriptionsCancelSynchronization_564275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to cancel a synchronization.
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_ShareSubscriptionsCancelSynchronization_564275;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; shareSubscriptionSynchronization: JsonNode;
          accountName: string): Recallable =
  ## shareSubscriptionsCancelSynchronization
  ## Request to cancel a synchronization.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   shareSubscriptionSynchronization: JObject (required)
  ##                                   : Share Subscription Synchronization payload.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  var body_564288 = newJObject()
  add(query_564287, "api-version", newJString(apiVersion))
  add(path_564286, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564286, "subscriptionId", newJString(subscriptionId))
  add(path_564286, "resourceGroupName", newJString(resourceGroupName))
  if shareSubscriptionSynchronization != nil:
    body_564288 = shareSubscriptionSynchronization
  add(path_564286, "accountName", newJString(accountName))
  result = call_564285.call(path_564286, query_564287, nil, nil, body_564288)

var shareSubscriptionsCancelSynchronization* = Call_ShareSubscriptionsCancelSynchronization_564275(
    name: "shareSubscriptionsCancelSynchronization", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/cancelSynchronization",
    validator: validate_ShareSubscriptionsCancelSynchronization_564276, base: "",
    url: url_ShareSubscriptionsCancelSynchronization_564277,
    schemes: {Scheme.Https})
type
  Call_DataSetMappingsListByShareSubscription_564289 = ref object of OpenApiRestCall_563565
proc url_DataSetMappingsListByShareSubscription_564291(protocol: Scheme;
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

proc validate_DataSetMappingsListByShareSubscription_564290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List DataSetMappings in a share subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564292 = path.getOrDefault("shareSubscriptionName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "shareSubscriptionName", valid_564292
  var valid_564293 = path.getOrDefault("subscriptionId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "subscriptionId", valid_564293
  var valid_564294 = path.getOrDefault("resourceGroupName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroupName", valid_564294
  var valid_564295 = path.getOrDefault("accountName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "accountName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564296 = query.getOrDefault("$skipToken")
  valid_564296 = validateParameter(valid_564296, JString, required = false,
                                 default = nil)
  if valid_564296 != nil:
    section.add "$skipToken", valid_564296
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "api-version", valid_564297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564298: Call_DataSetMappingsListByShareSubscription_564289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List DataSetMappings in a share subscription
  ## 
  let valid = call_564298.validator(path, query, header, formData, body)
  let scheme = call_564298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564298.url(scheme.get, call_564298.host, call_564298.base,
                         call_564298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564298, url, valid)

proc call*(call_564299: Call_DataSetMappingsListByShareSubscription_564289;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## dataSetMappingsListByShareSubscription
  ## List DataSetMappings in a share subscription
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564300 = newJObject()
  var query_564301 = newJObject()
  add(query_564301, "$skipToken", newJString(SkipToken))
  add(query_564301, "api-version", newJString(apiVersion))
  add(path_564300, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564300, "subscriptionId", newJString(subscriptionId))
  add(path_564300, "resourceGroupName", newJString(resourceGroupName))
  add(path_564300, "accountName", newJString(accountName))
  result = call_564299.call(path_564300, query_564301, nil, nil, nil)

var dataSetMappingsListByShareSubscription* = Call_DataSetMappingsListByShareSubscription_564289(
    name: "dataSetMappingsListByShareSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings",
    validator: validate_DataSetMappingsListByShareSubscription_564290, base: "",
    url: url_DataSetMappingsListByShareSubscription_564291,
    schemes: {Scheme.Https})
type
  Call_DataSetMappingsCreate_564315 = ref object of OpenApiRestCall_563565
proc url_DataSetMappingsCreate_564317(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetMappingsCreate_564316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a DataSetMapping 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: JString (required)
  ##                     : The Id of the source data set being mapped.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564318 = path.getOrDefault("shareSubscriptionName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "shareSubscriptionName", valid_564318
  var valid_564319 = path.getOrDefault("subscriptionId")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "subscriptionId", valid_564319
  var valid_564320 = path.getOrDefault("resourceGroupName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "resourceGroupName", valid_564320
  var valid_564321 = path.getOrDefault("dataSetMappingName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "dataSetMappingName", valid_564321
  var valid_564322 = path.getOrDefault("accountName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "accountName", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "api-version", valid_564323
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

proc call*(call_564325: Call_DataSetMappingsCreate_564315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a DataSetMapping 
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_DataSetMappingsCreate_564315; apiVersion: string;
          shareSubscriptionName: string; dataSetMapping: JsonNode;
          subscriptionId: string; resourceGroupName: string;
          dataSetMappingName: string; accountName: string): Recallable =
  ## dataSetMappingsCreate
  ## Create a DataSetMapping 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   dataSetMapping: JObject (required)
  ##                 : Destination data set configuration details.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: string (required)
  ##                     : The Id of the source data set being mapped.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  var body_564329 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "shareSubscriptionName", newJString(shareSubscriptionName))
  if dataSetMapping != nil:
    body_564329 = dataSetMapping
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  add(path_564327, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_564327, "accountName", newJString(accountName))
  result = call_564326.call(path_564327, query_564328, nil, nil, body_564329)

var dataSetMappingsCreate* = Call_DataSetMappingsCreate_564315(
    name: "dataSetMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsCreate_564316, base: "",
    url: url_DataSetMappingsCreate_564317, schemes: {Scheme.Https})
type
  Call_DataSetMappingsGet_564302 = ref object of OpenApiRestCall_563565
proc url_DataSetMappingsGet_564304(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetMappingsGet_564303(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get a DataSetMapping in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: JString (required)
  ##                     : The name of the dataSetMapping.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564305 = path.getOrDefault("shareSubscriptionName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "shareSubscriptionName", valid_564305
  var valid_564306 = path.getOrDefault("subscriptionId")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "subscriptionId", valid_564306
  var valid_564307 = path.getOrDefault("resourceGroupName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "resourceGroupName", valid_564307
  var valid_564308 = path.getOrDefault("dataSetMappingName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "dataSetMappingName", valid_564308
  var valid_564309 = path.getOrDefault("accountName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "accountName", valid_564309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564310 = query.getOrDefault("api-version")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "api-version", valid_564310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564311: Call_DataSetMappingsGet_564302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a DataSetMapping in a shareSubscription
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_DataSetMappingsGet_564302; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; dataSetMappingName: string; accountName: string): Recallable =
  ## dataSetMappingsGet
  ## Get a DataSetMapping in a shareSubscription
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: string (required)
  ##                     : The name of the dataSetMapping.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  add(path_564313, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_564313, "accountName", newJString(accountName))
  result = call_564312.call(path_564313, query_564314, nil, nil, nil)

var dataSetMappingsGet* = Call_DataSetMappingsGet_564302(
    name: "dataSetMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsGet_564303, base: "",
    url: url_DataSetMappingsGet_564304, schemes: {Scheme.Https})
type
  Call_DataSetMappingsDelete_564330 = ref object of OpenApiRestCall_563565
proc url_DataSetMappingsDelete_564332(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetMappingsDelete_564331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a DataSetMapping in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: JString (required)
  ##                     : The name of the dataSetMapping.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564333 = path.getOrDefault("shareSubscriptionName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "shareSubscriptionName", valid_564333
  var valid_564334 = path.getOrDefault("subscriptionId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "subscriptionId", valid_564334
  var valid_564335 = path.getOrDefault("resourceGroupName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "resourceGroupName", valid_564335
  var valid_564336 = path.getOrDefault("dataSetMappingName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "dataSetMappingName", valid_564336
  var valid_564337 = path.getOrDefault("accountName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "accountName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564338 = query.getOrDefault("api-version")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "api-version", valid_564338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_DataSetMappingsDelete_564330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a DataSetMapping in a shareSubscription
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_DataSetMappingsDelete_564330; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; dataSetMappingName: string; accountName: string): Recallable =
  ## dataSetMappingsDelete
  ## Delete a DataSetMapping in a shareSubscription
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   dataSetMappingName: string (required)
  ##                     : The name of the dataSetMapping.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  add(path_564341, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_564341, "accountName", newJString(accountName))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var dataSetMappingsDelete* = Call_DataSetMappingsDelete_564330(
    name: "dataSetMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsDelete_564331, base: "",
    url: url_DataSetMappingsDelete_564332, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSourceShareSynchronizationSettings_564343 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsListSourceShareSynchronizationSettings_564345(
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

proc validate_ShareSubscriptionsListSourceShareSynchronizationSettings_564344(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get synchronization settings set on a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564346 = path.getOrDefault("shareSubscriptionName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "shareSubscriptionName", valid_564346
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  var valid_564349 = path.getOrDefault("accountName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "accountName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564350 = query.getOrDefault("$skipToken")
  valid_564350 = validateParameter(valid_564350, JString, required = false,
                                 default = nil)
  if valid_564350 != nil:
    section.add "$skipToken", valid_564350
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_ShareSubscriptionsListSourceShareSynchronizationSettings_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get synchronization settings set on a share
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_ShareSubscriptionsListSourceShareSynchronizationSettings_564343;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListSourceShareSynchronizationSettings
  ## Get synchronization settings set on a share
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "$skipToken", newJString(SkipToken))
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564354, "subscriptionId", newJString(subscriptionId))
  add(path_564354, "resourceGroupName", newJString(resourceGroupName))
  add(path_564354, "accountName", newJString(accountName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var shareSubscriptionsListSourceShareSynchronizationSettings* = Call_ShareSubscriptionsListSourceShareSynchronizationSettings_564343(
    name: "shareSubscriptionsListSourceShareSynchronizationSettings",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSourceShareSynchronizationSettings", validator: validate_ShareSubscriptionsListSourceShareSynchronizationSettings_564344,
    base: "", url: url_ShareSubscriptionsListSourceShareSynchronizationSettings_564345,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSynchronizationDetails_564356 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsListSynchronizationDetails_564358(protocol: Scheme;
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

proc validate_ShareSubscriptionsListSynchronizationDetails_564357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronization details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564359 = path.getOrDefault("shareSubscriptionName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "shareSubscriptionName", valid_564359
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
  var valid_564362 = path.getOrDefault("accountName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "accountName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564363 = query.getOrDefault("$skipToken")
  valid_564363 = validateParameter(valid_564363, JString, required = false,
                                 default = nil)
  if valid_564363 != nil:
    section.add "$skipToken", valid_564363
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564364 = query.getOrDefault("api-version")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "api-version", valid_564364
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

proc call*(call_564366: Call_ShareSubscriptionsListSynchronizationDetails_564356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronization details
  ## 
  let valid = call_564366.validator(path, query, header, formData, body)
  let scheme = call_564366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564366.url(scheme.get, call_564366.host, call_564366.base,
                         call_564366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564366, url, valid)

proc call*(call_564367: Call_ShareSubscriptionsListSynchronizationDetails_564356;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; shareSubscriptionSynchronization: JsonNode;
          accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListSynchronizationDetails
  ## List synchronization details
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   shareSubscriptionSynchronization: JObject (required)
  ##                                   : Share Subscription Synchronization payload.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564368 = newJObject()
  var query_564369 = newJObject()
  var body_564370 = newJObject()
  add(query_564369, "$skipToken", newJString(SkipToken))
  add(query_564369, "api-version", newJString(apiVersion))
  add(path_564368, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564368, "subscriptionId", newJString(subscriptionId))
  add(path_564368, "resourceGroupName", newJString(resourceGroupName))
  if shareSubscriptionSynchronization != nil:
    body_564370 = shareSubscriptionSynchronization
  add(path_564368, "accountName", newJString(accountName))
  result = call_564367.call(path_564368, query_564369, nil, nil, body_564370)

var shareSubscriptionsListSynchronizationDetails* = Call_ShareSubscriptionsListSynchronizationDetails_564356(
    name: "shareSubscriptionsListSynchronizationDetails",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSynchronizationDetails",
    validator: validate_ShareSubscriptionsListSynchronizationDetails_564357,
    base: "", url: url_ShareSubscriptionsListSynchronizationDetails_564358,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSynchronizations_564371 = ref object of OpenApiRestCall_563565
proc url_ShareSubscriptionsListSynchronizations_564373(protocol: Scheme;
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

proc validate_ShareSubscriptionsListSynchronizations_564372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronizations of a share subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564374 = path.getOrDefault("shareSubscriptionName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "shareSubscriptionName", valid_564374
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
  var valid_564377 = path.getOrDefault("accountName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "accountName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564378 = query.getOrDefault("$skipToken")
  valid_564378 = validateParameter(valid_564378, JString, required = false,
                                 default = nil)
  if valid_564378 != nil:
    section.add "$skipToken", valid_564378
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564379 = query.getOrDefault("api-version")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "api-version", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564380: Call_ShareSubscriptionsListSynchronizations_564371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronizations of a share subscription
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_ShareSubscriptionsListSynchronizations_564371;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## shareSubscriptionsListSynchronizations
  ## List synchronizations of a share subscription
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  add(query_564383, "$skipToken", newJString(SkipToken))
  add(query_564383, "api-version", newJString(apiVersion))
  add(path_564382, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564382, "subscriptionId", newJString(subscriptionId))
  add(path_564382, "resourceGroupName", newJString(resourceGroupName))
  add(path_564382, "accountName", newJString(accountName))
  result = call_564381.call(path_564382, query_564383, nil, nil, nil)

var shareSubscriptionsListSynchronizations* = Call_ShareSubscriptionsListSynchronizations_564371(
    name: "shareSubscriptionsListSynchronizations", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSynchronizations",
    validator: validate_ShareSubscriptionsListSynchronizations_564372, base: "",
    url: url_ShareSubscriptionsListSynchronizations_564373,
    schemes: {Scheme.Https})
type
  Call_TriggersListByShareSubscription_564384 = ref object of OpenApiRestCall_563565
proc url_TriggersListByShareSubscription_564386(protocol: Scheme; host: string;
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

proc validate_TriggersListByShareSubscription_564385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Triggers in a share subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564387 = path.getOrDefault("shareSubscriptionName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "shareSubscriptionName", valid_564387
  var valid_564388 = path.getOrDefault("subscriptionId")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "subscriptionId", valid_564388
  var valid_564389 = path.getOrDefault("resourceGroupName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "resourceGroupName", valid_564389
  var valid_564390 = path.getOrDefault("accountName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "accountName", valid_564390
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564391 = query.getOrDefault("$skipToken")
  valid_564391 = validateParameter(valid_564391, JString, required = false,
                                 default = nil)
  if valid_564391 != nil:
    section.add "$skipToken", valid_564391
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_TriggersListByShareSubscription_564384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Triggers in a share subscription
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_TriggersListByShareSubscription_564384;
          apiVersion: string; shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## triggersListByShareSubscription
  ## List Triggers in a share subscription
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "$skipToken", newJString(SkipToken))
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  add(path_564395, "accountName", newJString(accountName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var triggersListByShareSubscription* = Call_TriggersListByShareSubscription_564384(
    name: "triggersListByShareSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers",
    validator: validate_TriggersListByShareSubscription_564385, base: "",
    url: url_TriggersListByShareSubscription_564386, schemes: {Scheme.Https})
type
  Call_TriggersCreate_564410 = ref object of OpenApiRestCall_563565
proc url_TriggersCreate_564412(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreate_564411(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a Trigger 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The name of the trigger.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564413 = path.getOrDefault("shareSubscriptionName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "shareSubscriptionName", valid_564413
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("resourceGroupName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "resourceGroupName", valid_564415
  var valid_564416 = path.getOrDefault("triggerName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "triggerName", valid_564416
  var valid_564417 = path.getOrDefault("accountName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "accountName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
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

proc call*(call_564420: Call_TriggersCreate_564410; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Trigger 
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_TriggersCreate_564410; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string; trigger: JsonNode;
          accountName: string): Recallable =
  ## triggersCreate
  ## Create a Trigger 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the share subscription which will hold the data set sink.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The name of the trigger.
  ##   trigger: JObject (required)
  ##          : Trigger details.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  var body_564424 = newJObject()
  add(query_564423, "api-version", newJString(apiVersion))
  add(path_564422, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564422, "subscriptionId", newJString(subscriptionId))
  add(path_564422, "resourceGroupName", newJString(resourceGroupName))
  add(path_564422, "triggerName", newJString(triggerName))
  if trigger != nil:
    body_564424 = trigger
  add(path_564422, "accountName", newJString(accountName))
  result = call_564421.call(path_564422, query_564423, nil, nil, body_564424)

var triggersCreate* = Call_TriggersCreate_564410(name: "triggersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
    validator: validate_TriggersCreate_564411, base: "", url: url_TriggersCreate_564412,
    schemes: {Scheme.Https})
type
  Call_TriggersGet_564397 = ref object of OpenApiRestCall_563565
proc url_TriggersGet_564399(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_564398(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Trigger in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The name of the trigger.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564400 = path.getOrDefault("shareSubscriptionName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "shareSubscriptionName", valid_564400
  var valid_564401 = path.getOrDefault("subscriptionId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "subscriptionId", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  var valid_564403 = path.getOrDefault("triggerName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "triggerName", valid_564403
  var valid_564404 = path.getOrDefault("accountName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "accountName", valid_564404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564405 = query.getOrDefault("api-version")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "api-version", valid_564405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_TriggersGet_564397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Trigger in a shareSubscription
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_TriggersGet_564397; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string; accountName: string): Recallable =
  ## triggersGet
  ## Get a Trigger in a shareSubscription
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The name of the trigger.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564408 = newJObject()
  var query_564409 = newJObject()
  add(query_564409, "api-version", newJString(apiVersion))
  add(path_564408, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564408, "subscriptionId", newJString(subscriptionId))
  add(path_564408, "resourceGroupName", newJString(resourceGroupName))
  add(path_564408, "triggerName", newJString(triggerName))
  add(path_564408, "accountName", newJString(accountName))
  result = call_564407.call(path_564408, query_564409, nil, nil, nil)

var triggersGet* = Call_TriggersGet_564397(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_564398,
                                        base: "", url: url_TriggersGet_564399,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_564425 = ref object of OpenApiRestCall_563565
proc url_TriggersDelete_564427(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_564426(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Trigger in a shareSubscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   shareSubscriptionName: JString (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The name of the trigger.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `shareSubscriptionName` field"
  var valid_564428 = path.getOrDefault("shareSubscriptionName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "shareSubscriptionName", valid_564428
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  var valid_564431 = path.getOrDefault("triggerName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "triggerName", valid_564431
  var valid_564432 = path.getOrDefault("accountName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "accountName", valid_564432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564433 = query.getOrDefault("api-version")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "api-version", valid_564433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564434: Call_TriggersDelete_564425; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Trigger in a shareSubscription
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_TriggersDelete_564425; apiVersion: string;
          shareSubscriptionName: string; subscriptionId: string;
          resourceGroupName: string; triggerName: string; accountName: string): Recallable =
  ## triggersDelete
  ## Delete a Trigger in a shareSubscription
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   shareSubscriptionName: string (required)
  ##                        : The name of the shareSubscription.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The name of the trigger.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  add(path_564436, "triggerName", newJString(triggerName))
  add(path_564436, "accountName", newJString(accountName))
  result = call_564435.call(path_564436, query_564437, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_564425(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_564426, base: "", url: url_TriggersDelete_564427,
    schemes: {Scheme.Https})
type
  Call_SharesListByAccount_564438 = ref object of OpenApiRestCall_563565
proc url_SharesListByAccount_564440(protocol: Scheme; host: string; base: string;
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

proc validate_SharesListByAccount_564439(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List shares in an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564441 = path.getOrDefault("subscriptionId")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "subscriptionId", valid_564441
  var valid_564442 = path.getOrDefault("resourceGroupName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "resourceGroupName", valid_564442
  var valid_564443 = path.getOrDefault("accountName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "accountName", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation Token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564444 = query.getOrDefault("$skipToken")
  valid_564444 = validateParameter(valid_564444, JString, required = false,
                                 default = nil)
  if valid_564444 != nil:
    section.add "$skipToken", valid_564444
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564445 = query.getOrDefault("api-version")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "api-version", valid_564445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564446: Call_SharesListByAccount_564438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List shares in an account
  ## 
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_SharesListByAccount_564438; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          SkipToken: string = ""): Recallable =
  ## sharesListByAccount
  ## List shares in an account
  ##   SkipToken: string
  ##            : Continuation Token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  add(query_564449, "$skipToken", newJString(SkipToken))
  add(query_564449, "api-version", newJString(apiVersion))
  add(path_564448, "subscriptionId", newJString(subscriptionId))
  add(path_564448, "resourceGroupName", newJString(resourceGroupName))
  add(path_564448, "accountName", newJString(accountName))
  result = call_564447.call(path_564448, query_564449, nil, nil, nil)

var sharesListByAccount* = Call_SharesListByAccount_564438(
    name: "sharesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares",
    validator: validate_SharesListByAccount_564439, base: "",
    url: url_SharesListByAccount_564440, schemes: {Scheme.Https})
type
  Call_SharesCreate_564462 = ref object of OpenApiRestCall_563565
proc url_SharesCreate_564464(protocol: Scheme; host: string; base: string;
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

proc validate_SharesCreate_564463(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a share 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564465 = path.getOrDefault("subscriptionId")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "subscriptionId", valid_564465
  var valid_564466 = path.getOrDefault("shareName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "shareName", valid_564466
  var valid_564467 = path.getOrDefault("resourceGroupName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "resourceGroupName", valid_564467
  var valid_564468 = path.getOrDefault("accountName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "accountName", valid_564468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564469 = query.getOrDefault("api-version")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "api-version", valid_564469
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

proc call*(call_564471: Call_SharesCreate_564462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a share 
  ## 
  let valid = call_564471.validator(path, query, header, formData, body)
  let scheme = call_564471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564471.url(scheme.get, call_564471.host, call_564471.base,
                         call_564471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564471, url, valid)

proc call*(call_564472: Call_SharesCreate_564462; apiVersion: string;
          subscriptionId: string; shareName: string; share: JsonNode;
          resourceGroupName: string; accountName: string): Recallable =
  ## sharesCreate
  ## Create a share 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   share: JObject (required)
  ##        : The share payload
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564473 = newJObject()
  var query_564474 = newJObject()
  var body_564475 = newJObject()
  add(query_564474, "api-version", newJString(apiVersion))
  add(path_564473, "subscriptionId", newJString(subscriptionId))
  add(path_564473, "shareName", newJString(shareName))
  if share != nil:
    body_564475 = share
  add(path_564473, "resourceGroupName", newJString(resourceGroupName))
  add(path_564473, "accountName", newJString(accountName))
  result = call_564472.call(path_564473, query_564474, nil, nil, body_564475)

var sharesCreate* = Call_SharesCreate_564462(name: "sharesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
    validator: validate_SharesCreate_564463, base: "", url: url_SharesCreate_564464,
    schemes: {Scheme.Https})
type
  Call_SharesGet_564450 = ref object of OpenApiRestCall_563565
proc url_SharesGet_564452(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SharesGet_564451(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a share 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to retrieve.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564453 = path.getOrDefault("subscriptionId")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "subscriptionId", valid_564453
  var valid_564454 = path.getOrDefault("shareName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "shareName", valid_564454
  var valid_564455 = path.getOrDefault("resourceGroupName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "resourceGroupName", valid_564455
  var valid_564456 = path.getOrDefault("accountName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "accountName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564458: Call_SharesGet_564450; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a share 
  ## 
  let valid = call_564458.validator(path, query, header, formData, body)
  let scheme = call_564458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564458.url(scheme.get, call_564458.host, call_564458.base,
                         call_564458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564458, url, valid)

proc call*(call_564459: Call_SharesGet_564450; apiVersion: string;
          subscriptionId: string; shareName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## sharesGet
  ## Get a share 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to retrieve.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564460 = newJObject()
  var query_564461 = newJObject()
  add(query_564461, "api-version", newJString(apiVersion))
  add(path_564460, "subscriptionId", newJString(subscriptionId))
  add(path_564460, "shareName", newJString(shareName))
  add(path_564460, "resourceGroupName", newJString(resourceGroupName))
  add(path_564460, "accountName", newJString(accountName))
  result = call_564459.call(path_564460, query_564461, nil, nil, nil)

var sharesGet* = Call_SharesGet_564450(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
                                    validator: validate_SharesGet_564451,
                                    base: "", url: url_SharesGet_564452,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_564476 = ref object of OpenApiRestCall_563565
proc url_SharesDelete_564478(protocol: Scheme; host: string; base: string;
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

proc validate_SharesDelete_564477(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a share 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564479 = path.getOrDefault("subscriptionId")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "subscriptionId", valid_564479
  var valid_564480 = path.getOrDefault("shareName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "shareName", valid_564480
  var valid_564481 = path.getOrDefault("resourceGroupName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "resourceGroupName", valid_564481
  var valid_564482 = path.getOrDefault("accountName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "accountName", valid_564482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564483 = query.getOrDefault("api-version")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "api-version", valid_564483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564484: Call_SharesDelete_564476; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a share 
  ## 
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_SharesDelete_564476; apiVersion: string;
          subscriptionId: string; shareName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## sharesDelete
  ## Delete a share 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564486 = newJObject()
  var query_564487 = newJObject()
  add(query_564487, "api-version", newJString(apiVersion))
  add(path_564486, "subscriptionId", newJString(subscriptionId))
  add(path_564486, "shareName", newJString(shareName))
  add(path_564486, "resourceGroupName", newJString(resourceGroupName))
  add(path_564486, "accountName", newJString(accountName))
  result = call_564485.call(path_564486, query_564487, nil, nil, nil)

var sharesDelete* = Call_SharesDelete_564476(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
    validator: validate_SharesDelete_564477, base: "", url: url_SharesDelete_564478,
    schemes: {Scheme.Https})
type
  Call_DataSetsListByShare_564488 = ref object of OpenApiRestCall_563565
proc url_DataSetsListByShare_564490(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsListByShare_564489(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List DataSets in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564491 = path.getOrDefault("subscriptionId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "subscriptionId", valid_564491
  var valid_564492 = path.getOrDefault("shareName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "shareName", valid_564492
  var valid_564493 = path.getOrDefault("resourceGroupName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "resourceGroupName", valid_564493
  var valid_564494 = path.getOrDefault("accountName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "accountName", valid_564494
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564495 = query.getOrDefault("$skipToken")
  valid_564495 = validateParameter(valid_564495, JString, required = false,
                                 default = nil)
  if valid_564495 != nil:
    section.add "$skipToken", valid_564495
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564496 = query.getOrDefault("api-version")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "api-version", valid_564496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564497: Call_DataSetsListByShare_564488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List DataSets in a share
  ## 
  let valid = call_564497.validator(path, query, header, formData, body)
  let scheme = call_564497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564497.url(scheme.get, call_564497.host, call_564497.base,
                         call_564497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564497, url, valid)

proc call*(call_564498: Call_DataSetsListByShare_564488; apiVersion: string;
          subscriptionId: string; shareName: string; resourceGroupName: string;
          accountName: string; SkipToken: string = ""): Recallable =
  ## dataSetsListByShare
  ## List DataSets in a share
  ##   SkipToken: string
  ##            : continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564499 = newJObject()
  var query_564500 = newJObject()
  add(query_564500, "$skipToken", newJString(SkipToken))
  add(query_564500, "api-version", newJString(apiVersion))
  add(path_564499, "subscriptionId", newJString(subscriptionId))
  add(path_564499, "shareName", newJString(shareName))
  add(path_564499, "resourceGroupName", newJString(resourceGroupName))
  add(path_564499, "accountName", newJString(accountName))
  result = call_564498.call(path_564499, query_564500, nil, nil, nil)

var dataSetsListByShare* = Call_DataSetsListByShare_564488(
    name: "dataSetsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets",
    validator: validate_DataSetsListByShare_564489, base: "",
    url: url_DataSetsListByShare_564490, schemes: {Scheme.Https})
type
  Call_DataSetsCreate_564514 = ref object of OpenApiRestCall_563565
proc url_DataSetsCreate_564516(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsCreate_564515(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a DataSet 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to add the data set to.
  ##   dataSetName: JString (required)
  ##              : The name of the dataSet.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("shareName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "shareName", valid_564518
  var valid_564519 = path.getOrDefault("dataSetName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "dataSetName", valid_564519
  var valid_564520 = path.getOrDefault("resourceGroupName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "resourceGroupName", valid_564520
  var valid_564521 = path.getOrDefault("accountName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "accountName", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
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

proc call*(call_564524: Call_DataSetsCreate_564514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a DataSet 
  ## 
  let valid = call_564524.validator(path, query, header, formData, body)
  let scheme = call_564524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564524.url(scheme.get, call_564524.host, call_564524.base,
                         call_564524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564524, url, valid)

proc call*(call_564525: Call_DataSetsCreate_564514; apiVersion: string;
          subscriptionId: string; shareName: string; dataSetName: string;
          resourceGroupName: string; dataSet: JsonNode; accountName: string): Recallable =
  ## dataSetsCreate
  ## Create a DataSet 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to add the data set to.
  ##   dataSetName: string (required)
  ##              : The name of the dataSet.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   dataSet: JObject (required)
  ##          : The new data set information.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564526 = newJObject()
  var query_564527 = newJObject()
  var body_564528 = newJObject()
  add(query_564527, "api-version", newJString(apiVersion))
  add(path_564526, "subscriptionId", newJString(subscriptionId))
  add(path_564526, "shareName", newJString(shareName))
  add(path_564526, "dataSetName", newJString(dataSetName))
  add(path_564526, "resourceGroupName", newJString(resourceGroupName))
  if dataSet != nil:
    body_564528 = dataSet
  add(path_564526, "accountName", newJString(accountName))
  result = call_564525.call(path_564526, query_564527, nil, nil, body_564528)

var dataSetsCreate* = Call_DataSetsCreate_564514(name: "dataSetsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
    validator: validate_DataSetsCreate_564515, base: "", url: url_DataSetsCreate_564516,
    schemes: {Scheme.Https})
type
  Call_DataSetsGet_564501 = ref object of OpenApiRestCall_563565
proc url_DataSetsGet_564503(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsGet_564502(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a DataSet in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   dataSetName: JString (required)
  ##              : The name of the dataSet.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564504 = path.getOrDefault("subscriptionId")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "subscriptionId", valid_564504
  var valid_564505 = path.getOrDefault("shareName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "shareName", valid_564505
  var valid_564506 = path.getOrDefault("dataSetName")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "dataSetName", valid_564506
  var valid_564507 = path.getOrDefault("resourceGroupName")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "resourceGroupName", valid_564507
  var valid_564508 = path.getOrDefault("accountName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "accountName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564510: Call_DataSetsGet_564501; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a DataSet in a share
  ## 
  let valid = call_564510.validator(path, query, header, formData, body)
  let scheme = call_564510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564510.url(scheme.get, call_564510.host, call_564510.base,
                         call_564510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564510, url, valid)

proc call*(call_564511: Call_DataSetsGet_564501; apiVersion: string;
          subscriptionId: string; shareName: string; dataSetName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## dataSetsGet
  ## Get a DataSet in a share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   dataSetName: string (required)
  ##              : The name of the dataSet.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564512 = newJObject()
  var query_564513 = newJObject()
  add(query_564513, "api-version", newJString(apiVersion))
  add(path_564512, "subscriptionId", newJString(subscriptionId))
  add(path_564512, "shareName", newJString(shareName))
  add(path_564512, "dataSetName", newJString(dataSetName))
  add(path_564512, "resourceGroupName", newJString(resourceGroupName))
  add(path_564512, "accountName", newJString(accountName))
  result = call_564511.call(path_564512, query_564513, nil, nil, nil)

var dataSetsGet* = Call_DataSetsGet_564501(name: "dataSetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
                                        validator: validate_DataSetsGet_564502,
                                        base: "", url: url_DataSetsGet_564503,
                                        schemes: {Scheme.Https})
type
  Call_DataSetsDelete_564529 = ref object of OpenApiRestCall_563565
proc url_DataSetsDelete_564531(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsDelete_564530(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a DataSet in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   dataSetName: JString (required)
  ##              : The name of the dataSet.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564532 = path.getOrDefault("subscriptionId")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "subscriptionId", valid_564532
  var valid_564533 = path.getOrDefault("shareName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "shareName", valid_564533
  var valid_564534 = path.getOrDefault("dataSetName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "dataSetName", valid_564534
  var valid_564535 = path.getOrDefault("resourceGroupName")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "resourceGroupName", valid_564535
  var valid_564536 = path.getOrDefault("accountName")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "accountName", valid_564536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564537 = query.getOrDefault("api-version")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "api-version", valid_564537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564538: Call_DataSetsDelete_564529; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a DataSet in a share
  ## 
  let valid = call_564538.validator(path, query, header, formData, body)
  let scheme = call_564538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564538.url(scheme.get, call_564538.host, call_564538.base,
                         call_564538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564538, url, valid)

proc call*(call_564539: Call_DataSetsDelete_564529; apiVersion: string;
          subscriptionId: string; shareName: string; dataSetName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## dataSetsDelete
  ## Delete a DataSet in a share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   dataSetName: string (required)
  ##              : The name of the dataSet.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564540 = newJObject()
  var query_564541 = newJObject()
  add(query_564541, "api-version", newJString(apiVersion))
  add(path_564540, "subscriptionId", newJString(subscriptionId))
  add(path_564540, "shareName", newJString(shareName))
  add(path_564540, "dataSetName", newJString(dataSetName))
  add(path_564540, "resourceGroupName", newJString(resourceGroupName))
  add(path_564540, "accountName", newJString(accountName))
  result = call_564539.call(path_564540, query_564541, nil, nil, nil)

var dataSetsDelete* = Call_DataSetsDelete_564529(name: "dataSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
    validator: validate_DataSetsDelete_564530, base: "", url: url_DataSetsDelete_564531,
    schemes: {Scheme.Https})
type
  Call_InvitationsListByShare_564542 = ref object of OpenApiRestCall_563565
proc url_InvitationsListByShare_564544(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsListByShare_564543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List invitations in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564545 = path.getOrDefault("subscriptionId")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "subscriptionId", valid_564545
  var valid_564546 = path.getOrDefault("shareName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "shareName", valid_564546
  var valid_564547 = path.getOrDefault("resourceGroupName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "resourceGroupName", valid_564547
  var valid_564548 = path.getOrDefault("accountName")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "accountName", valid_564548
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564551: Call_InvitationsListByShare_564542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List invitations in a share
  ## 
  let valid = call_564551.validator(path, query, header, formData, body)
  let scheme = call_564551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564551.url(scheme.get, call_564551.host, call_564551.base,
                         call_564551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564551, url, valid)

proc call*(call_564552: Call_InvitationsListByShare_564542; apiVersion: string;
          subscriptionId: string; shareName: string; resourceGroupName: string;
          accountName: string; SkipToken: string = ""): Recallable =
  ## invitationsListByShare
  ## List invitations in a share
  ##   SkipToken: string
  ##            : The continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564553 = newJObject()
  var query_564554 = newJObject()
  add(query_564554, "$skipToken", newJString(SkipToken))
  add(query_564554, "api-version", newJString(apiVersion))
  add(path_564553, "subscriptionId", newJString(subscriptionId))
  add(path_564553, "shareName", newJString(shareName))
  add(path_564553, "resourceGroupName", newJString(resourceGroupName))
  add(path_564553, "accountName", newJString(accountName))
  result = call_564552.call(path_564553, query_564554, nil, nil, nil)

var invitationsListByShare* = Call_InvitationsListByShare_564542(
    name: "invitationsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations",
    validator: validate_InvitationsListByShare_564543, base: "",
    url: url_InvitationsListByShare_564544, schemes: {Scheme.Https})
type
  Call_InvitationsCreate_564568 = ref object of OpenApiRestCall_563565
proc url_InvitationsCreate_564570(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsCreate_564569(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create an invitation 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invitationName: JString (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to send the invitation for.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationName` field"
  var valid_564571 = path.getOrDefault("invitationName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "invitationName", valid_564571
  var valid_564572 = path.getOrDefault("subscriptionId")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "subscriptionId", valid_564572
  var valid_564573 = path.getOrDefault("shareName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "shareName", valid_564573
  var valid_564574 = path.getOrDefault("resourceGroupName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "resourceGroupName", valid_564574
  var valid_564575 = path.getOrDefault("accountName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "accountName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
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

proc call*(call_564578: Call_InvitationsCreate_564568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an invitation 
  ## 
  let valid = call_564578.validator(path, query, header, formData, body)
  let scheme = call_564578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564578.url(scheme.get, call_564578.host, call_564578.base,
                         call_564578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564578, url, valid)

proc call*(call_564579: Call_InvitationsCreate_564568; invitationName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; invitation: JsonNode; accountName: string): Recallable =
  ## invitationsCreate
  ## Create an invitation 
  ##   invitationName: string (required)
  ##                 : The name of the invitation.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to send the invitation for.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   invitation: JObject (required)
  ##             : Invitation details.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564580 = newJObject()
  var query_564581 = newJObject()
  var body_564582 = newJObject()
  add(path_564580, "invitationName", newJString(invitationName))
  add(query_564581, "api-version", newJString(apiVersion))
  add(path_564580, "subscriptionId", newJString(subscriptionId))
  add(path_564580, "shareName", newJString(shareName))
  add(path_564580, "resourceGroupName", newJString(resourceGroupName))
  if invitation != nil:
    body_564582 = invitation
  add(path_564580, "accountName", newJString(accountName))
  result = call_564579.call(path_564580, query_564581, nil, nil, body_564582)

var invitationsCreate* = Call_InvitationsCreate_564568(name: "invitationsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsCreate_564569, base: "",
    url: url_InvitationsCreate_564570, schemes: {Scheme.Https})
type
  Call_InvitationsGet_564555 = ref object of OpenApiRestCall_563565
proc url_InvitationsGet_564557(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsGet_564556(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get an invitation in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invitationName: JString (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationName` field"
  var valid_564558 = path.getOrDefault("invitationName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "invitationName", valid_564558
  var valid_564559 = path.getOrDefault("subscriptionId")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "subscriptionId", valid_564559
  var valid_564560 = path.getOrDefault("shareName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "shareName", valid_564560
  var valid_564561 = path.getOrDefault("resourceGroupName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "resourceGroupName", valid_564561
  var valid_564562 = path.getOrDefault("accountName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "accountName", valid_564562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564563 = query.getOrDefault("api-version")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "api-version", valid_564563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564564: Call_InvitationsGet_564555; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an invitation in a share
  ## 
  let valid = call_564564.validator(path, query, header, formData, body)
  let scheme = call_564564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564564.url(scheme.get, call_564564.host, call_564564.base,
                         call_564564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564564, url, valid)

proc call*(call_564565: Call_InvitationsGet_564555; invitationName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## invitationsGet
  ## Get an invitation in a share
  ##   invitationName: string (required)
  ##                 : The name of the invitation.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564566 = newJObject()
  var query_564567 = newJObject()
  add(path_564566, "invitationName", newJString(invitationName))
  add(query_564567, "api-version", newJString(apiVersion))
  add(path_564566, "subscriptionId", newJString(subscriptionId))
  add(path_564566, "shareName", newJString(shareName))
  add(path_564566, "resourceGroupName", newJString(resourceGroupName))
  add(path_564566, "accountName", newJString(accountName))
  result = call_564565.call(path_564566, query_564567, nil, nil, nil)

var invitationsGet* = Call_InvitationsGet_564555(name: "invitationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsGet_564556, base: "", url: url_InvitationsGet_564557,
    schemes: {Scheme.Https})
type
  Call_InvitationsDelete_564583 = ref object of OpenApiRestCall_563565
proc url_InvitationsDelete_564585(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsDelete_564584(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an invitation in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invitationName: JString (required)
  ##                 : The name of the invitation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationName` field"
  var valid_564586 = path.getOrDefault("invitationName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "invitationName", valid_564586
  var valid_564587 = path.getOrDefault("subscriptionId")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "subscriptionId", valid_564587
  var valid_564588 = path.getOrDefault("shareName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "shareName", valid_564588
  var valid_564589 = path.getOrDefault("resourceGroupName")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "resourceGroupName", valid_564589
  var valid_564590 = path.getOrDefault("accountName")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "accountName", valid_564590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564591 = query.getOrDefault("api-version")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "api-version", valid_564591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564592: Call_InvitationsDelete_564583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an invitation in a share
  ## 
  let valid = call_564592.validator(path, query, header, formData, body)
  let scheme = call_564592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564592.url(scheme.get, call_564592.host, call_564592.base,
                         call_564592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564592, url, valid)

proc call*(call_564593: Call_InvitationsDelete_564583; invitationName: string;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## invitationsDelete
  ## Delete an invitation in a share
  ##   invitationName: string (required)
  ##                 : The name of the invitation.
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564594 = newJObject()
  var query_564595 = newJObject()
  add(path_564594, "invitationName", newJString(invitationName))
  add(query_564595, "api-version", newJString(apiVersion))
  add(path_564594, "subscriptionId", newJString(subscriptionId))
  add(path_564594, "shareName", newJString(shareName))
  add(path_564594, "resourceGroupName", newJString(resourceGroupName))
  add(path_564594, "accountName", newJString(accountName))
  result = call_564593.call(path_564594, query_564595, nil, nil, nil)

var invitationsDelete* = Call_InvitationsDelete_564583(name: "invitationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsDelete_564584, base: "",
    url: url_InvitationsDelete_564585, schemes: {Scheme.Https})
type
  Call_SharesListSynchronizationDetails_564596 = ref object of OpenApiRestCall_563565
proc url_SharesListSynchronizationDetails_564598(protocol: Scheme; host: string;
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

proc validate_SharesListSynchronizationDetails_564597(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronization details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564599 = path.getOrDefault("subscriptionId")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "subscriptionId", valid_564599
  var valid_564600 = path.getOrDefault("shareName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "shareName", valid_564600
  var valid_564601 = path.getOrDefault("resourceGroupName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "resourceGroupName", valid_564601
  var valid_564602 = path.getOrDefault("accountName")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "accountName", valid_564602
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564603 = query.getOrDefault("$skipToken")
  valid_564603 = validateParameter(valid_564603, JString, required = false,
                                 default = nil)
  if valid_564603 != nil:
    section.add "$skipToken", valid_564603
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564604 = query.getOrDefault("api-version")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "api-version", valid_564604
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

proc call*(call_564606: Call_SharesListSynchronizationDetails_564596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronization details
  ## 
  let valid = call_564606.validator(path, query, header, formData, body)
  let scheme = call_564606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564606.url(scheme.get, call_564606.host, call_564606.base,
                         call_564606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564606, url, valid)

proc call*(call_564607: Call_SharesListSynchronizationDetails_564596;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; shareSynchronization: JsonNode;
          accountName: string; SkipToken: string = ""): Recallable =
  ## sharesListSynchronizationDetails
  ## List synchronization details
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   shareSynchronization: JObject (required)
  ##                       : Share Synchronization payload.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564608 = newJObject()
  var query_564609 = newJObject()
  var body_564610 = newJObject()
  add(query_564609, "$skipToken", newJString(SkipToken))
  add(query_564609, "api-version", newJString(apiVersion))
  add(path_564608, "subscriptionId", newJString(subscriptionId))
  add(path_564608, "shareName", newJString(shareName))
  add(path_564608, "resourceGroupName", newJString(resourceGroupName))
  if shareSynchronization != nil:
    body_564610 = shareSynchronization
  add(path_564608, "accountName", newJString(accountName))
  result = call_564607.call(path_564608, query_564609, nil, nil, body_564610)

var sharesListSynchronizationDetails* = Call_SharesListSynchronizationDetails_564596(
    name: "sharesListSynchronizationDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/listSynchronizationDetails",
    validator: validate_SharesListSynchronizationDetails_564597, base: "",
    url: url_SharesListSynchronizationDetails_564598, schemes: {Scheme.Https})
type
  Call_SharesListSynchronizations_564611 = ref object of OpenApiRestCall_563565
proc url_SharesListSynchronizations_564613(protocol: Scheme; host: string;
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

proc validate_SharesListSynchronizations_564612(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronizations of a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564614 = path.getOrDefault("subscriptionId")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "subscriptionId", valid_564614
  var valid_564615 = path.getOrDefault("shareName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "shareName", valid_564615
  var valid_564616 = path.getOrDefault("resourceGroupName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "resourceGroupName", valid_564616
  var valid_564617 = path.getOrDefault("accountName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "accountName", valid_564617
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564618 = query.getOrDefault("$skipToken")
  valid_564618 = validateParameter(valid_564618, JString, required = false,
                                 default = nil)
  if valid_564618 != nil:
    section.add "$skipToken", valid_564618
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564619 = query.getOrDefault("api-version")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "api-version", valid_564619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564620: Call_SharesListSynchronizations_564611; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List synchronizations of a share
  ## 
  let valid = call_564620.validator(path, query, header, formData, body)
  let scheme = call_564620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564620.url(scheme.get, call_564620.host, call_564620.base,
                         call_564620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564620, url, valid)

proc call*(call_564621: Call_SharesListSynchronizations_564611; apiVersion: string;
          subscriptionId: string; shareName: string; resourceGroupName: string;
          accountName: string; SkipToken: string = ""): Recallable =
  ## sharesListSynchronizations
  ## List synchronizations of a share
  ##   SkipToken: string
  ##            : Continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564622 = newJObject()
  var query_564623 = newJObject()
  add(query_564623, "$skipToken", newJString(SkipToken))
  add(query_564623, "api-version", newJString(apiVersion))
  add(path_564622, "subscriptionId", newJString(subscriptionId))
  add(path_564622, "shareName", newJString(shareName))
  add(path_564622, "resourceGroupName", newJString(resourceGroupName))
  add(path_564622, "accountName", newJString(accountName))
  result = call_564621.call(path_564622, query_564623, nil, nil, nil)

var sharesListSynchronizations* = Call_SharesListSynchronizations_564611(
    name: "sharesListSynchronizations", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/listSynchronizations",
    validator: validate_SharesListSynchronizations_564612, base: "",
    url: url_SharesListSynchronizations_564613, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsListByShare_564624 = ref object of OpenApiRestCall_563565
proc url_ProviderShareSubscriptionsListByShare_564626(protocol: Scheme;
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

proc validate_ProviderShareSubscriptionsListByShare_564625(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List share subscriptions in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564627 = path.getOrDefault("subscriptionId")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "subscriptionId", valid_564627
  var valid_564628 = path.getOrDefault("shareName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "shareName", valid_564628
  var valid_564629 = path.getOrDefault("resourceGroupName")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "resourceGroupName", valid_564629
  var valid_564630 = path.getOrDefault("accountName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "accountName", valid_564630
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Continuation Token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564631 = query.getOrDefault("$skipToken")
  valid_564631 = validateParameter(valid_564631, JString, required = false,
                                 default = nil)
  if valid_564631 != nil:
    section.add "$skipToken", valid_564631
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564632 = query.getOrDefault("api-version")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "api-version", valid_564632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564633: Call_ProviderShareSubscriptionsListByShare_564624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List share subscriptions in a provider share
  ## 
  let valid = call_564633.validator(path, query, header, formData, body)
  let scheme = call_564633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564633.url(scheme.get, call_564633.host, call_564633.base,
                         call_564633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564633, url, valid)

proc call*(call_564634: Call_ProviderShareSubscriptionsListByShare_564624;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## providerShareSubscriptionsListByShare
  ## List share subscriptions in a provider share
  ##   SkipToken: string
  ##            : Continuation Token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564635 = newJObject()
  var query_564636 = newJObject()
  add(query_564636, "$skipToken", newJString(SkipToken))
  add(query_564636, "api-version", newJString(apiVersion))
  add(path_564635, "subscriptionId", newJString(subscriptionId))
  add(path_564635, "shareName", newJString(shareName))
  add(path_564635, "resourceGroupName", newJString(resourceGroupName))
  add(path_564635, "accountName", newJString(accountName))
  result = call_564634.call(path_564635, query_564636, nil, nil, nil)

var providerShareSubscriptionsListByShare* = Call_ProviderShareSubscriptionsListByShare_564624(
    name: "providerShareSubscriptionsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions",
    validator: validate_ProviderShareSubscriptionsListByShare_564625, base: "",
    url: url_ProviderShareSubscriptionsListByShare_564626, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsGetByShare_564637 = ref object of OpenApiRestCall_563565
proc url_ProviderShareSubscriptionsGetByShare_564639(protocol: Scheme;
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

proc validate_ProviderShareSubscriptionsGetByShare_564638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get share subscription in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   providerShareSubscriptionId: JString (required)
  ##                              : To locate shareSubscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564640 = path.getOrDefault("subscriptionId")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "subscriptionId", valid_564640
  var valid_564641 = path.getOrDefault("shareName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "shareName", valid_564641
  var valid_564642 = path.getOrDefault("resourceGroupName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "resourceGroupName", valid_564642
  var valid_564643 = path.getOrDefault("providerShareSubscriptionId")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "providerShareSubscriptionId", valid_564643
  var valid_564644 = path.getOrDefault("accountName")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "accountName", valid_564644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564645 = query.getOrDefault("api-version")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "api-version", valid_564645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564646: Call_ProviderShareSubscriptionsGetByShare_564637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get share subscription in a provider share
  ## 
  let valid = call_564646.validator(path, query, header, formData, body)
  let scheme = call_564646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564646.url(scheme.get, call_564646.host, call_564646.base,
                         call_564646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564646, url, valid)

proc call*(call_564647: Call_ProviderShareSubscriptionsGetByShare_564637;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; providerShareSubscriptionId: string;
          accountName: string): Recallable =
  ## providerShareSubscriptionsGetByShare
  ## Get share subscription in a provider share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   providerShareSubscriptionId: string (required)
  ##                              : To locate shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564648 = newJObject()
  var query_564649 = newJObject()
  add(query_564649, "api-version", newJString(apiVersion))
  add(path_564648, "subscriptionId", newJString(subscriptionId))
  add(path_564648, "shareName", newJString(shareName))
  add(path_564648, "resourceGroupName", newJString(resourceGroupName))
  add(path_564648, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_564648, "accountName", newJString(accountName))
  result = call_564647.call(path_564648, query_564649, nil, nil, nil)

var providerShareSubscriptionsGetByShare* = Call_ProviderShareSubscriptionsGetByShare_564637(
    name: "providerShareSubscriptionsGetByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}",
    validator: validate_ProviderShareSubscriptionsGetByShare_564638, base: "",
    url: url_ProviderShareSubscriptionsGetByShare_564639, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsReinstate_564650 = ref object of OpenApiRestCall_563565
proc url_ProviderShareSubscriptionsReinstate_564652(protocol: Scheme; host: string;
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

proc validate_ProviderShareSubscriptionsReinstate_564651(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reinstate share subscription in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   providerShareSubscriptionId: JString (required)
  ##                              : To locate shareSubscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564653 = path.getOrDefault("subscriptionId")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "subscriptionId", valid_564653
  var valid_564654 = path.getOrDefault("shareName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "shareName", valid_564654
  var valid_564655 = path.getOrDefault("resourceGroupName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceGroupName", valid_564655
  var valid_564656 = path.getOrDefault("providerShareSubscriptionId")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "providerShareSubscriptionId", valid_564656
  var valid_564657 = path.getOrDefault("accountName")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "accountName", valid_564657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564658 = query.getOrDefault("api-version")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "api-version", valid_564658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564659: Call_ProviderShareSubscriptionsReinstate_564650;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reinstate share subscription in a provider share
  ## 
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_ProviderShareSubscriptionsReinstate_564650;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; providerShareSubscriptionId: string;
          accountName: string): Recallable =
  ## providerShareSubscriptionsReinstate
  ## Reinstate share subscription in a provider share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   providerShareSubscriptionId: string (required)
  ##                              : To locate shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "shareName", newJString(shareName))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  add(path_564661, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_564661, "accountName", newJString(accountName))
  result = call_564660.call(path_564661, query_564662, nil, nil, nil)

var providerShareSubscriptionsReinstate* = Call_ProviderShareSubscriptionsReinstate_564650(
    name: "providerShareSubscriptionsReinstate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}/reinstate",
    validator: validate_ProviderShareSubscriptionsReinstate_564651, base: "",
    url: url_ProviderShareSubscriptionsReinstate_564652, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsRevoke_564663 = ref object of OpenApiRestCall_563565
proc url_ProviderShareSubscriptionsRevoke_564665(protocol: Scheme; host: string;
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

proc validate_ProviderShareSubscriptionsRevoke_564664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke share subscription in a provider share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   providerShareSubscriptionId: JString (required)
  ##                              : To locate shareSubscription
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564666 = path.getOrDefault("subscriptionId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "subscriptionId", valid_564666
  var valid_564667 = path.getOrDefault("shareName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "shareName", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  var valid_564669 = path.getOrDefault("providerShareSubscriptionId")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "providerShareSubscriptionId", valid_564669
  var valid_564670 = path.getOrDefault("accountName")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "accountName", valid_564670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564671 = query.getOrDefault("api-version")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "api-version", valid_564671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564672: Call_ProviderShareSubscriptionsRevoke_564663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke share subscription in a provider share
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_ProviderShareSubscriptionsRevoke_564663;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; providerShareSubscriptionId: string;
          accountName: string): Recallable =
  ## providerShareSubscriptionsRevoke
  ## Revoke share subscription in a provider share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   providerShareSubscriptionId: string (required)
  ##                              : To locate shareSubscription
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  add(query_564675, "api-version", newJString(apiVersion))
  add(path_564674, "subscriptionId", newJString(subscriptionId))
  add(path_564674, "shareName", newJString(shareName))
  add(path_564674, "resourceGroupName", newJString(resourceGroupName))
  add(path_564674, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_564674, "accountName", newJString(accountName))
  result = call_564673.call(path_564674, query_564675, nil, nil, nil)

var providerShareSubscriptionsRevoke* = Call_ProviderShareSubscriptionsRevoke_564663(
    name: "providerShareSubscriptionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}/revoke",
    validator: validate_ProviderShareSubscriptionsRevoke_564664, base: "",
    url: url_ProviderShareSubscriptionsRevoke_564665, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsListByShare_564676 = ref object of OpenApiRestCall_563565
proc url_SynchronizationSettingsListByShare_564678(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsListByShare_564677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List synchronizationSettings in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564679 = path.getOrDefault("subscriptionId")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "subscriptionId", valid_564679
  var valid_564680 = path.getOrDefault("shareName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "shareName", valid_564680
  var valid_564681 = path.getOrDefault("resourceGroupName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "resourceGroupName", valid_564681
  var valid_564682 = path.getOrDefault("accountName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "accountName", valid_564682
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : continuation token
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  var valid_564683 = query.getOrDefault("$skipToken")
  valid_564683 = validateParameter(valid_564683, JString, required = false,
                                 default = nil)
  if valid_564683 != nil:
    section.add "$skipToken", valid_564683
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564684 = query.getOrDefault("api-version")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "api-version", valid_564684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564685: Call_SynchronizationSettingsListByShare_564676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronizationSettings in a share
  ## 
  let valid = call_564685.validator(path, query, header, formData, body)
  let scheme = call_564685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564685.url(scheme.get, call_564685.host, call_564685.base,
                         call_564685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564685, url, valid)

proc call*(call_564686: Call_SynchronizationSettingsListByShare_564676;
          apiVersion: string; subscriptionId: string; shareName: string;
          resourceGroupName: string; accountName: string; SkipToken: string = ""): Recallable =
  ## synchronizationSettingsListByShare
  ## List synchronizationSettings in a share
  ##   SkipToken: string
  ##            : continuation token
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564687 = newJObject()
  var query_564688 = newJObject()
  add(query_564688, "$skipToken", newJString(SkipToken))
  add(query_564688, "api-version", newJString(apiVersion))
  add(path_564687, "subscriptionId", newJString(subscriptionId))
  add(path_564687, "shareName", newJString(shareName))
  add(path_564687, "resourceGroupName", newJString(resourceGroupName))
  add(path_564687, "accountName", newJString(accountName))
  result = call_564686.call(path_564687, query_564688, nil, nil, nil)

var synchronizationSettingsListByShare* = Call_SynchronizationSettingsListByShare_564676(
    name: "synchronizationSettingsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings",
    validator: validate_SynchronizationSettingsListByShare_564677, base: "",
    url: url_SynchronizationSettingsListByShare_564678, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsCreate_564702 = ref object of OpenApiRestCall_563565
proc url_SynchronizationSettingsCreate_564704(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsCreate_564703(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a synchronizationSetting 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   synchronizationSettingName: JString (required)
  ##                             : The name of the synchronizationSetting.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share to add the synchronization setting to.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `synchronizationSettingName` field"
  var valid_564705 = path.getOrDefault("synchronizationSettingName")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "synchronizationSettingName", valid_564705
  var valid_564706 = path.getOrDefault("subscriptionId")
  valid_564706 = validateParameter(valid_564706, JString, required = true,
                                 default = nil)
  if valid_564706 != nil:
    section.add "subscriptionId", valid_564706
  var valid_564707 = path.getOrDefault("shareName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "shareName", valid_564707
  var valid_564708 = path.getOrDefault("resourceGroupName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "resourceGroupName", valid_564708
  var valid_564709 = path.getOrDefault("accountName")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "accountName", valid_564709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564710 = query.getOrDefault("api-version")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "api-version", valid_564710
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

proc call*(call_564712: Call_SynchronizationSettingsCreate_564702; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a synchronizationSetting 
  ## 
  let valid = call_564712.validator(path, query, header, formData, body)
  let scheme = call_564712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564712.url(scheme.get, call_564712.host, call_564712.base,
                         call_564712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564712, url, valid)

proc call*(call_564713: Call_SynchronizationSettingsCreate_564702;
          apiVersion: string; synchronizationSettingName: string;
          subscriptionId: string; shareName: string;
          synchronizationSetting: JsonNode; resourceGroupName: string;
          accountName: string): Recallable =
  ## synchronizationSettingsCreate
  ## Create or update a synchronizationSetting 
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   synchronizationSettingName: string (required)
  ##                             : The name of the synchronizationSetting.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share to add the synchronization setting to.
  ##   synchronizationSetting: JObject (required)
  ##                         : The new synchronization setting information.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564714 = newJObject()
  var query_564715 = newJObject()
  var body_564716 = newJObject()
  add(query_564715, "api-version", newJString(apiVersion))
  add(path_564714, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(path_564714, "subscriptionId", newJString(subscriptionId))
  add(path_564714, "shareName", newJString(shareName))
  if synchronizationSetting != nil:
    body_564716 = synchronizationSetting
  add(path_564714, "resourceGroupName", newJString(resourceGroupName))
  add(path_564714, "accountName", newJString(accountName))
  result = call_564713.call(path_564714, query_564715, nil, nil, body_564716)

var synchronizationSettingsCreate* = Call_SynchronizationSettingsCreate_564702(
    name: "synchronizationSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsCreate_564703, base: "",
    url: url_SynchronizationSettingsCreate_564704, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsGet_564689 = ref object of OpenApiRestCall_563565
proc url_SynchronizationSettingsGet_564691(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsGet_564690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a synchronizationSetting in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   synchronizationSettingName: JString (required)
  ##                             : The name of the synchronizationSetting.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `synchronizationSettingName` field"
  var valid_564692 = path.getOrDefault("synchronizationSettingName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "synchronizationSettingName", valid_564692
  var valid_564693 = path.getOrDefault("subscriptionId")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "subscriptionId", valid_564693
  var valid_564694 = path.getOrDefault("shareName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "shareName", valid_564694
  var valid_564695 = path.getOrDefault("resourceGroupName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "resourceGroupName", valid_564695
  var valid_564696 = path.getOrDefault("accountName")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "accountName", valid_564696
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564697 = query.getOrDefault("api-version")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "api-version", valid_564697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564698: Call_SynchronizationSettingsGet_564689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a synchronizationSetting in a share
  ## 
  let valid = call_564698.validator(path, query, header, formData, body)
  let scheme = call_564698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564698.url(scheme.get, call_564698.host, call_564698.base,
                         call_564698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564698, url, valid)

proc call*(call_564699: Call_SynchronizationSettingsGet_564689; apiVersion: string;
          synchronizationSettingName: string; subscriptionId: string;
          shareName: string; resourceGroupName: string; accountName: string): Recallable =
  ## synchronizationSettingsGet
  ## Get a synchronizationSetting in a share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   synchronizationSettingName: string (required)
  ##                             : The name of the synchronizationSetting.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564700 = newJObject()
  var query_564701 = newJObject()
  add(query_564701, "api-version", newJString(apiVersion))
  add(path_564700, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(path_564700, "subscriptionId", newJString(subscriptionId))
  add(path_564700, "shareName", newJString(shareName))
  add(path_564700, "resourceGroupName", newJString(resourceGroupName))
  add(path_564700, "accountName", newJString(accountName))
  result = call_564699.call(path_564700, query_564701, nil, nil, nil)

var synchronizationSettingsGet* = Call_SynchronizationSettingsGet_564689(
    name: "synchronizationSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsGet_564690, base: "",
    url: url_SynchronizationSettingsGet_564691, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsDelete_564717 = ref object of OpenApiRestCall_563565
proc url_SynchronizationSettingsDelete_564719(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsDelete_564718(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a synchronizationSetting in a share
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   synchronizationSettingName: JString (required)
  ##                             : The name of the synchronizationSetting .
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier
  ##   shareName: JString (required)
  ##            : The name of the share.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   accountName: JString (required)
  ##              : The name of the share account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `synchronizationSettingName` field"
  var valid_564720 = path.getOrDefault("synchronizationSettingName")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "synchronizationSettingName", valid_564720
  var valid_564721 = path.getOrDefault("subscriptionId")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "subscriptionId", valid_564721
  var valid_564722 = path.getOrDefault("shareName")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "shareName", valid_564722
  var valid_564723 = path.getOrDefault("resourceGroupName")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "resourceGroupName", valid_564723
  var valid_564724 = path.getOrDefault("accountName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "accountName", valid_564724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564725 = query.getOrDefault("api-version")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "api-version", valid_564725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564726: Call_SynchronizationSettingsDelete_564717; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a synchronizationSetting in a share
  ## 
  let valid = call_564726.validator(path, query, header, formData, body)
  let scheme = call_564726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564726.url(scheme.get, call_564726.host, call_564726.base,
                         call_564726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564726, url, valid)

proc call*(call_564727: Call_SynchronizationSettingsDelete_564717;
          apiVersion: string; synchronizationSettingName: string;
          subscriptionId: string; shareName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## synchronizationSettingsDelete
  ## Delete a synchronizationSetting in a share
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   synchronizationSettingName: string (required)
  ##                             : The name of the synchronizationSetting .
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   shareName: string (required)
  ##            : The name of the share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   accountName: string (required)
  ##              : The name of the share account.
  var path_564728 = newJObject()
  var query_564729 = newJObject()
  add(query_564729, "api-version", newJString(apiVersion))
  add(path_564728, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(path_564728, "subscriptionId", newJString(subscriptionId))
  add(path_564728, "shareName", newJString(shareName))
  add(path_564728, "resourceGroupName", newJString(resourceGroupName))
  add(path_564728, "accountName", newJString(accountName))
  result = call_564727.call(path_564728, query_564729, nil, nil, nil)

var synchronizationSettingsDelete* = Call_SynchronizationSettingsDelete_564717(
    name: "synchronizationSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsDelete_564718, base: "",
    url: url_SynchronizationSettingsDelete_564719, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
