
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "datashare-DataShare"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConsumerInvitationsListInvitations_593660 = ref object of OpenApiRestCall_593438
proc url_ConsumerInvitationsListInvitations_593662(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ConsumerInvitationsListInvitations_593661(path: JsonNode;
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  var valid_593823 = query.getOrDefault("$skipToken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "$skipToken", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_ConsumerInvitationsListInvitations_593660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists invitations
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_ConsumerInvitationsListInvitations_593660;
          apiVersion: string; SkipToken: string = ""): Recallable =
  ## consumerInvitationsListInvitations
  ## Lists invitations
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   SkipToken: string
  ##            : The continuation token
  var query_593918 = newJObject()
  add(query_593918, "api-version", newJString(apiVersion))
  add(query_593918, "$skipToken", newJString(SkipToken))
  result = call_593917.call(nil, query_593918, nil, nil, nil)

var consumerInvitationsListInvitations* = Call_ConsumerInvitationsListInvitations_593660(
    name: "consumerInvitationsListInvitations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DataShare/ListInvitations",
    validator: validate_ConsumerInvitationsListInvitations_593661, base: "",
    url: url_ConsumerInvitationsListInvitations_593662, schemes: {Scheme.Https})
type
  Call_ConsumerInvitationsRejectInvitation_593958 = ref object of OpenApiRestCall_593438
proc url_ConsumerInvitationsRejectInvitation_593960(protocol: Scheme; host: string;
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

proc validate_ConsumerInvitationsRejectInvitation_593959(path: JsonNode;
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
  var valid_593975 = path.getOrDefault("location")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "location", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
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

proc call*(call_593978: Call_ConsumerInvitationsRejectInvitation_593958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reject an invitation
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_ConsumerInvitationsRejectInvitation_593958;
          apiVersion: string; invitation: JsonNode; location: string): Recallable =
  ## consumerInvitationsRejectInvitation
  ## Reject an invitation
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitation: JObject (required)
  ##             : An invitation payload
  ##   location: string (required)
  ##           : Location of the invitation
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  var body_593982 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  if invitation != nil:
    body_593982 = invitation
  add(path_593980, "location", newJString(location))
  result = call_593979.call(path_593980, query_593981, nil, nil, body_593982)

var consumerInvitationsRejectInvitation* = Call_ConsumerInvitationsRejectInvitation_593958(
    name: "consumerInvitationsRejectInvitation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.DataShare/locations/{location}/RejectInvitation",
    validator: validate_ConsumerInvitationsRejectInvitation_593959, base: "",
    url: url_ConsumerInvitationsRejectInvitation_593960, schemes: {Scheme.Https})
type
  Call_ConsumerInvitationsGet_593983 = ref object of OpenApiRestCall_593438
proc url_ConsumerInvitationsGet_593985(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerInvitationsGet_593984(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("invitationId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "invitationId", valid_593986
  var valid_593987 = path.getOrDefault("location")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "location", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_ConsumerInvitationsGet_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an invitation
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_ConsumerInvitationsGet_593983; apiVersion: string;
          invitationId: string; location: string): Recallable =
  ## consumerInvitationsGet
  ## Get an invitation
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   invitationId: string (required)
  ##               : An invitation id
  ##   location: string (required)
  ##           : Location of the invitation
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "invitationId", newJString(invitationId))
  add(path_593991, "location", newJString(location))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var consumerInvitationsGet* = Call_ConsumerInvitationsGet_593983(
    name: "consumerInvitationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.DataShare/locations/{location}/consumerInvitations/{invitationId}",
    validator: validate_ConsumerInvitationsGet_593984, base: "",
    url: url_ConsumerInvitationsGet_593985, schemes: {Scheme.Https})
type
  Call_OperationsList_593993 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593995(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593994(path: JsonNode; query: JsonNode;
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
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_OperationsList_593993; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of available operations
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_OperationsList_593993; apiVersion: string): Recallable =
  ## operationsList
  ## List of available operations
  ##   apiVersion: string (required)
  ##             : The api version to use.
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  result = call_593998.call(nil, query_593999, nil, nil, nil)

var operationsList* = Call_OperationsList_593993(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataShare/operations",
    validator: validate_OperationsList_593994, base: "", url: url_OperationsList_593995,
    schemes: {Scheme.Https})
type
  Call_AccountsListBySubscription_594000 = ref object of OpenApiRestCall_593438
proc url_AccountsListBySubscription_594002(protocol: Scheme; host: string;
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

proc validate_AccountsListBySubscription_594001(path: JsonNode; query: JsonNode;
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
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  var valid_594005 = query.getOrDefault("$skipToken")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "$skipToken", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_AccountsListBySubscription_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Accounts in Subscription
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_AccountsListBySubscription_594000; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## accountsListBySubscription
  ## List Accounts in Subscription
  ##   apiVersion: string (required)
  ##             : The api version to use.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier
  ##   SkipToken: string
  ##            : Continuation token
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(query_594009, "$skipToken", newJString(SkipToken))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var accountsListBySubscription* = Call_AccountsListBySubscription_594000(
    name: "accountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataShare/accounts",
    validator: validate_AccountsListBySubscription_594001, base: "",
    url: url_AccountsListBySubscription_594002, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_594010 = ref object of OpenApiRestCall_593438
proc url_AccountsListByResourceGroup_594012(protocol: Scheme; host: string;
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

proc validate_AccountsListByResourceGroup_594011(path: JsonNode; query: JsonNode;
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
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  var valid_594016 = query.getOrDefault("$skipToken")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "$skipToken", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_AccountsListByResourceGroup_594010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Accounts in ResourceGroup
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_AccountsListByResourceGroup_594010;
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
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(query_594020, "$skipToken", newJString(SkipToken))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_594010(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts",
    validator: validate_AccountsListByResourceGroup_594011, base: "",
    url: url_AccountsListByResourceGroup_594012, schemes: {Scheme.Https})
type
  Call_AccountsCreate_594032 = ref object of OpenApiRestCall_593438
proc url_AccountsCreate_594034(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsCreate_594033(path: JsonNode; query: JsonNode;
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
  var valid_594035 = path.getOrDefault("resourceGroupName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "resourceGroupName", valid_594035
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  var valid_594037 = path.getOrDefault("accountName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "accountName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
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

proc call*(call_594040: Call_AccountsCreate_594032; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an account
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_AccountsCreate_594032; resourceGroupName: string;
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
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  if account != nil:
    body_594044 = account
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(path_594042, "accountName", newJString(accountName))
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var accountsCreate* = Call_AccountsCreate_594032(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsCreate_594033, base: "", url: url_AccountsCreate_594034,
    schemes: {Scheme.Https})
type
  Call_AccountsGet_594021 = ref object of OpenApiRestCall_593438
proc url_AccountsGet_594023(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsGet_594022(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("accountName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "accountName", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_AccountsGet_594021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an account
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_AccountsGet_594021; resourceGroupName: string;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(path_594030, "accountName", newJString(accountName))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var accountsGet* = Call_AccountsGet_594021(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
                                        validator: validate_AccountsGet_594022,
                                        base: "", url: url_AccountsGet_594023,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_594056 = ref object of OpenApiRestCall_593438
proc url_AccountsUpdate_594058(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsUpdate_594057(path: JsonNode; query: JsonNode;
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
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("accountName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "accountName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
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

proc call*(call_594064: Call_AccountsUpdate_594056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch an account
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_AccountsUpdate_594056; resourceGroupName: string;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  if accountUpdateParameters != nil:
    body_594068 = accountUpdateParameters
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "accountName", newJString(accountName))
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var accountsUpdate* = Call_AccountsUpdate_594056(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsUpdate_594057, base: "", url: url_AccountsUpdate_594058,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_594045 = ref object of OpenApiRestCall_593438
proc url_AccountsDelete_594047(protocol: Scheme; host: string; base: string;
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

proc validate_AccountsDelete_594046(path: JsonNode; query: JsonNode;
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
  var valid_594050 = path.getOrDefault("accountName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "accountName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_AccountsDelete_594045; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## DeleteAccount
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_AccountsDelete_594045; resourceGroupName: string;
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
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(path_594054, "accountName", newJString(accountName))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_594045(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}",
    validator: validate_AccountsDelete_594046, base: "", url: url_AccountsDelete_594047,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListByAccount_594069 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsListByAccount_594071(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsListByAccount_594070(path: JsonNode;
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
  var valid_594072 = path.getOrDefault("resourceGroupName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "resourceGroupName", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  var valid_594074 = path.getOrDefault("accountName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "accountName", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation Token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  var valid_594076 = query.getOrDefault("$skipToken")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "$skipToken", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_ShareSubscriptionsListByAccount_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List share subscriptions in an account
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_ShareSubscriptionsListByAccount_594069;
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
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(path_594079, "resourceGroupName", newJString(resourceGroupName))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "subscriptionId", newJString(subscriptionId))
  add(query_594080, "$skipToken", newJString(SkipToken))
  add(path_594079, "accountName", newJString(accountName))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var shareSubscriptionsListByAccount* = Call_ShareSubscriptionsListByAccount_594069(
    name: "shareSubscriptionsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions",
    validator: validate_ShareSubscriptionsListByAccount_594070, base: "",
    url: url_ShareSubscriptionsListByAccount_594071, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsCreate_594093 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsCreate_594095(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsCreate_594094(path: JsonNode; query: JsonNode;
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
  var valid_594096 = path.getOrDefault("resourceGroupName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "resourceGroupName", valid_594096
  var valid_594097 = path.getOrDefault("subscriptionId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "subscriptionId", valid_594097
  var valid_594098 = path.getOrDefault("shareSubscriptionName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "shareSubscriptionName", valid_594098
  var valid_594099 = path.getOrDefault("accountName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "accountName", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
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

proc call*(call_594102: Call_ShareSubscriptionsCreate_594093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a shareSubscription in an account
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_ShareSubscriptionsCreate_594093;
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
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  var body_594106 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "shareSubscriptionName", newJString(shareSubscriptionName))
  if shareSubscription != nil:
    body_594106 = shareSubscription
  add(path_594104, "accountName", newJString(accountName))
  result = call_594103.call(path_594104, query_594105, nil, nil, body_594106)

var shareSubscriptionsCreate* = Call_ShareSubscriptionsCreate_594093(
    name: "shareSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsCreate_594094, base: "",
    url: url_ShareSubscriptionsCreate_594095, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsGet_594081 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsGet_594083(protocol: Scheme; host: string; base: string;
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

proc validate_ShareSubscriptionsGet_594082(path: JsonNode; query: JsonNode;
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
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("subscriptionId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "subscriptionId", valid_594085
  var valid_594086 = path.getOrDefault("shareSubscriptionName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "shareSubscriptionName", valid_594086
  var valid_594087 = path.getOrDefault("accountName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "accountName", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_ShareSubscriptionsGet_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a shareSubscription in an account
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_ShareSubscriptionsGet_594081;
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
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  add(path_594091, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_594091, "accountName", newJString(accountName))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var shareSubscriptionsGet* = Call_ShareSubscriptionsGet_594081(
    name: "shareSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsGet_594082, base: "",
    url: url_ShareSubscriptionsGet_594083, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsDelete_594107 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsDelete_594109(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsDelete_594108(path: JsonNode; query: JsonNode;
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
  var valid_594112 = path.getOrDefault("shareSubscriptionName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "shareSubscriptionName", valid_594112
  var valid_594113 = path.getOrDefault("accountName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "accountName", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594114 = query.getOrDefault("api-version")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "api-version", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_ShareSubscriptionsDelete_594107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a shareSubscription in an account
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_ShareSubscriptionsDelete_594107;
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
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(path_594117, "resourceGroupName", newJString(resourceGroupName))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  add(path_594117, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_594117, "accountName", newJString(accountName))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var shareSubscriptionsDelete* = Call_ShareSubscriptionsDelete_594107(
    name: "shareSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}",
    validator: validate_ShareSubscriptionsDelete_594108, base: "",
    url: url_ShareSubscriptionsDelete_594109, schemes: {Scheme.Https})
type
  Call_ConsumerSourceDataSetsListByShareSubscription_594119 = ref object of OpenApiRestCall_593438
proc url_ConsumerSourceDataSetsListByShareSubscription_594121(protocol: Scheme;
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

proc validate_ConsumerSourceDataSetsListByShareSubscription_594120(
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
  var valid_594124 = path.getOrDefault("shareSubscriptionName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "shareSubscriptionName", valid_594124
  var valid_594125 = path.getOrDefault("accountName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "accountName", valid_594125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  var valid_594127 = query.getOrDefault("$skipToken")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "$skipToken", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_ConsumerSourceDataSetsListByShareSubscription_594119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get source dataSets of a shareSubscription
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_ConsumerSourceDataSetsListByShareSubscription_594119;
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
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  add(path_594130, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_594131, "$skipToken", newJString(SkipToken))
  add(path_594130, "accountName", newJString(accountName))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var consumerSourceDataSetsListByShareSubscription* = Call_ConsumerSourceDataSetsListByShareSubscription_594119(
    name: "consumerSourceDataSetsListByShareSubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/ConsumerSourceDataSets",
    validator: validate_ConsumerSourceDataSetsListByShareSubscription_594120,
    base: "", url: url_ConsumerSourceDataSetsListByShareSubscription_594121,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsSynchronize_594132 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsSynchronize_594134(protocol: Scheme; host: string;
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

proc validate_ShareSubscriptionsSynchronize_594133(path: JsonNode; query: JsonNode;
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
  var valid_594137 = path.getOrDefault("shareSubscriptionName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "shareSubscriptionName", valid_594137
  var valid_594138 = path.getOrDefault("accountName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "accountName", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
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

proc call*(call_594141: Call_ShareSubscriptionsSynchronize_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiate a copy
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_ShareSubscriptionsSynchronize_594132;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  var body_594145 = newJObject()
  add(path_594143, "resourceGroupName", newJString(resourceGroupName))
  add(query_594144, "api-version", newJString(apiVersion))
  add(path_594143, "subscriptionId", newJString(subscriptionId))
  add(path_594143, "shareSubscriptionName", newJString(shareSubscriptionName))
  if synchronize != nil:
    body_594145 = synchronize
  add(path_594143, "accountName", newJString(accountName))
  result = call_594142.call(path_594143, query_594144, nil, nil, body_594145)

var shareSubscriptionsSynchronize* = Call_ShareSubscriptionsSynchronize_594132(
    name: "shareSubscriptionsSynchronize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/Synchronize",
    validator: validate_ShareSubscriptionsSynchronize_594133, base: "",
    url: url_ShareSubscriptionsSynchronize_594134, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsCancelSynchronization_594146 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsCancelSynchronization_594148(protocol: Scheme;
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

proc validate_ShareSubscriptionsCancelSynchronization_594147(path: JsonNode;
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
  var valid_594149 = path.getOrDefault("resourceGroupName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "resourceGroupName", valid_594149
  var valid_594150 = path.getOrDefault("subscriptionId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "subscriptionId", valid_594150
  var valid_594151 = path.getOrDefault("shareSubscriptionName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "shareSubscriptionName", valid_594151
  var valid_594152 = path.getOrDefault("accountName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "accountName", valid_594152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594153 = query.getOrDefault("api-version")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "api-version", valid_594153
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

proc call*(call_594155: Call_ShareSubscriptionsCancelSynchronization_594146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to cancel a synchronization.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_ShareSubscriptionsCancelSynchronization_594146;
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
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  var body_594159 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(path_594157, "shareSubscriptionName", newJString(shareSubscriptionName))
  if shareSubscriptionSynchronization != nil:
    body_594159 = shareSubscriptionSynchronization
  add(path_594157, "accountName", newJString(accountName))
  result = call_594156.call(path_594157, query_594158, nil, nil, body_594159)

var shareSubscriptionsCancelSynchronization* = Call_ShareSubscriptionsCancelSynchronization_594146(
    name: "shareSubscriptionsCancelSynchronization", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/cancelSynchronization",
    validator: validate_ShareSubscriptionsCancelSynchronization_594147, base: "",
    url: url_ShareSubscriptionsCancelSynchronization_594148,
    schemes: {Scheme.Https})
type
  Call_DataSetMappingsListByShareSubscription_594160 = ref object of OpenApiRestCall_593438
proc url_DataSetMappingsListByShareSubscription_594162(protocol: Scheme;
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

proc validate_DataSetMappingsListByShareSubscription_594161(path: JsonNode;
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
  var valid_594163 = path.getOrDefault("resourceGroupName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "resourceGroupName", valid_594163
  var valid_594164 = path.getOrDefault("subscriptionId")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "subscriptionId", valid_594164
  var valid_594165 = path.getOrDefault("shareSubscriptionName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "shareSubscriptionName", valid_594165
  var valid_594166 = path.getOrDefault("accountName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "accountName", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  var valid_594168 = query.getOrDefault("$skipToken")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "$skipToken", valid_594168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594169: Call_DataSetMappingsListByShareSubscription_594160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List DataSetMappings in a share subscription
  ## 
  let valid = call_594169.validator(path, query, header, formData, body)
  let scheme = call_594169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594169.url(scheme.get, call_594169.host, call_594169.base,
                         call_594169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594169, url, valid)

proc call*(call_594170: Call_DataSetMappingsListByShareSubscription_594160;
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
  var path_594171 = newJObject()
  var query_594172 = newJObject()
  add(path_594171, "resourceGroupName", newJString(resourceGroupName))
  add(query_594172, "api-version", newJString(apiVersion))
  add(path_594171, "subscriptionId", newJString(subscriptionId))
  add(path_594171, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_594172, "$skipToken", newJString(SkipToken))
  add(path_594171, "accountName", newJString(accountName))
  result = call_594170.call(path_594171, query_594172, nil, nil, nil)

var dataSetMappingsListByShareSubscription* = Call_DataSetMappingsListByShareSubscription_594160(
    name: "dataSetMappingsListByShareSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings",
    validator: validate_DataSetMappingsListByShareSubscription_594161, base: "",
    url: url_DataSetMappingsListByShareSubscription_594162,
    schemes: {Scheme.Https})
type
  Call_DataSetMappingsCreate_594186 = ref object of OpenApiRestCall_593438
proc url_DataSetMappingsCreate_594188(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetMappingsCreate_594187(path: JsonNode; query: JsonNode;
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
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("dataSetMappingName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "dataSetMappingName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  var valid_594192 = path.getOrDefault("shareSubscriptionName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "shareSubscriptionName", valid_594192
  var valid_594193 = path.getOrDefault("accountName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "accountName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
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

proc call*(call_594196: Call_DataSetMappingsCreate_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a DataSetMapping 
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_DataSetMappingsCreate_594186;
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
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  var body_594200 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "shareSubscriptionName", newJString(shareSubscriptionName))
  if dataSetMapping != nil:
    body_594200 = dataSetMapping
  add(path_594198, "accountName", newJString(accountName))
  result = call_594197.call(path_594198, query_594199, nil, nil, body_594200)

var dataSetMappingsCreate* = Call_DataSetMappingsCreate_594186(
    name: "dataSetMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsCreate_594187, base: "",
    url: url_DataSetMappingsCreate_594188, schemes: {Scheme.Https})
type
  Call_DataSetMappingsGet_594173 = ref object of OpenApiRestCall_593438
proc url_DataSetMappingsGet_594175(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetMappingsGet_594174(path: JsonNode; query: JsonNode;
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
  var valid_594176 = path.getOrDefault("resourceGroupName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "resourceGroupName", valid_594176
  var valid_594177 = path.getOrDefault("dataSetMappingName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "dataSetMappingName", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("shareSubscriptionName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "shareSubscriptionName", valid_594179
  var valid_594180 = path.getOrDefault("accountName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "accountName", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_DataSetMappingsGet_594173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a DataSetMapping in a shareSubscription
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_DataSetMappingsGet_594173; resourceGroupName: string;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_594184, "accountName", newJString(accountName))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var dataSetMappingsGet* = Call_DataSetMappingsGet_594173(
    name: "dataSetMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsGet_594174, base: "",
    url: url_DataSetMappingsGet_594175, schemes: {Scheme.Https})
type
  Call_DataSetMappingsDelete_594201 = ref object of OpenApiRestCall_593438
proc url_DataSetMappingsDelete_594203(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetMappingsDelete_594202(path: JsonNode; query: JsonNode;
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
  var valid_594204 = path.getOrDefault("resourceGroupName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "resourceGroupName", valid_594204
  var valid_594205 = path.getOrDefault("dataSetMappingName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "dataSetMappingName", valid_594205
  var valid_594206 = path.getOrDefault("subscriptionId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "subscriptionId", valid_594206
  var valid_594207 = path.getOrDefault("shareSubscriptionName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "shareSubscriptionName", valid_594207
  var valid_594208 = path.getOrDefault("accountName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "accountName", valid_594208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594209 = query.getOrDefault("api-version")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "api-version", valid_594209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_DataSetMappingsDelete_594201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a DataSetMapping in a shareSubscription
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_DataSetMappingsDelete_594201;
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
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "dataSetMappingName", newJString(dataSetMappingName))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  add(path_594212, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_594212, "accountName", newJString(accountName))
  result = call_594211.call(path_594212, query_594213, nil, nil, nil)

var dataSetMappingsDelete* = Call_DataSetMappingsDelete_594201(
    name: "dataSetMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/dataSetMappings/{dataSetMappingName}",
    validator: validate_DataSetMappingsDelete_594202, base: "",
    url: url_DataSetMappingsDelete_594203, schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSourceShareSynchronizationSettings_594214 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsListSourceShareSynchronizationSettings_594216(
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

proc validate_ShareSubscriptionsListSourceShareSynchronizationSettings_594215(
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
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  var valid_594219 = path.getOrDefault("shareSubscriptionName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "shareSubscriptionName", valid_594219
  var valid_594220 = path.getOrDefault("accountName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "accountName", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  var valid_594222 = query.getOrDefault("$skipToken")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "$skipToken", valid_594222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_ShareSubscriptionsListSourceShareSynchronizationSettings_594214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get synchronization settings set on a share
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_ShareSubscriptionsListSourceShareSynchronizationSettings_594214;
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
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(path_594225, "resourceGroupName", newJString(resourceGroupName))
  add(query_594226, "api-version", newJString(apiVersion))
  add(path_594225, "subscriptionId", newJString(subscriptionId))
  add(path_594225, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_594226, "$skipToken", newJString(SkipToken))
  add(path_594225, "accountName", newJString(accountName))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var shareSubscriptionsListSourceShareSynchronizationSettings* = Call_ShareSubscriptionsListSourceShareSynchronizationSettings_594214(
    name: "shareSubscriptionsListSourceShareSynchronizationSettings",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSourceShareSynchronizationSettings", validator: validate_ShareSubscriptionsListSourceShareSynchronizationSettings_594215,
    base: "", url: url_ShareSubscriptionsListSourceShareSynchronizationSettings_594216,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSynchronizationDetails_594227 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsListSynchronizationDetails_594229(protocol: Scheme;
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

proc validate_ShareSubscriptionsListSynchronizationDetails_594228(path: JsonNode;
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
  var valid_594230 = path.getOrDefault("resourceGroupName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceGroupName", valid_594230
  var valid_594231 = path.getOrDefault("subscriptionId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "subscriptionId", valid_594231
  var valid_594232 = path.getOrDefault("shareSubscriptionName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "shareSubscriptionName", valid_594232
  var valid_594233 = path.getOrDefault("accountName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "accountName", valid_594233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594234 = query.getOrDefault("api-version")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "api-version", valid_594234
  var valid_594235 = query.getOrDefault("$skipToken")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "$skipToken", valid_594235
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

proc call*(call_594237: Call_ShareSubscriptionsListSynchronizationDetails_594227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronization details
  ## 
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_ShareSubscriptionsListSynchronizationDetails_594227;
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
  var path_594239 = newJObject()
  var query_594240 = newJObject()
  var body_594241 = newJObject()
  add(path_594239, "resourceGroupName", newJString(resourceGroupName))
  add(query_594240, "api-version", newJString(apiVersion))
  add(path_594239, "subscriptionId", newJString(subscriptionId))
  add(path_594239, "shareSubscriptionName", newJString(shareSubscriptionName))
  if shareSubscriptionSynchronization != nil:
    body_594241 = shareSubscriptionSynchronization
  add(query_594240, "$skipToken", newJString(SkipToken))
  add(path_594239, "accountName", newJString(accountName))
  result = call_594238.call(path_594239, query_594240, nil, nil, body_594241)

var shareSubscriptionsListSynchronizationDetails* = Call_ShareSubscriptionsListSynchronizationDetails_594227(
    name: "shareSubscriptionsListSynchronizationDetails",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSynchronizationDetails",
    validator: validate_ShareSubscriptionsListSynchronizationDetails_594228,
    base: "", url: url_ShareSubscriptionsListSynchronizationDetails_594229,
    schemes: {Scheme.Https})
type
  Call_ShareSubscriptionsListSynchronizations_594242 = ref object of OpenApiRestCall_593438
proc url_ShareSubscriptionsListSynchronizations_594244(protocol: Scheme;
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

proc validate_ShareSubscriptionsListSynchronizations_594243(path: JsonNode;
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
  var valid_594245 = path.getOrDefault("resourceGroupName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "resourceGroupName", valid_594245
  var valid_594246 = path.getOrDefault("subscriptionId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "subscriptionId", valid_594246
  var valid_594247 = path.getOrDefault("shareSubscriptionName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "shareSubscriptionName", valid_594247
  var valid_594248 = path.getOrDefault("accountName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "accountName", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594249 = query.getOrDefault("api-version")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "api-version", valid_594249
  var valid_594250 = query.getOrDefault("$skipToken")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "$skipToken", valid_594250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594251: Call_ShareSubscriptionsListSynchronizations_594242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronizations of a share subscription
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_ShareSubscriptionsListSynchronizations_594242;
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
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  add(path_594253, "resourceGroupName", newJString(resourceGroupName))
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "subscriptionId", newJString(subscriptionId))
  add(path_594253, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_594254, "$skipToken", newJString(SkipToken))
  add(path_594253, "accountName", newJString(accountName))
  result = call_594252.call(path_594253, query_594254, nil, nil, nil)

var shareSubscriptionsListSynchronizations* = Call_ShareSubscriptionsListSynchronizations_594242(
    name: "shareSubscriptionsListSynchronizations", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/listSynchronizations",
    validator: validate_ShareSubscriptionsListSynchronizations_594243, base: "",
    url: url_ShareSubscriptionsListSynchronizations_594244,
    schemes: {Scheme.Https})
type
  Call_TriggersListByShareSubscription_594255 = ref object of OpenApiRestCall_593438
proc url_TriggersListByShareSubscription_594257(protocol: Scheme; host: string;
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

proc validate_TriggersListByShareSubscription_594256(path: JsonNode;
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
  var valid_594258 = path.getOrDefault("resourceGroupName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "resourceGroupName", valid_594258
  var valid_594259 = path.getOrDefault("subscriptionId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "subscriptionId", valid_594259
  var valid_594260 = path.getOrDefault("shareSubscriptionName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "shareSubscriptionName", valid_594260
  var valid_594261 = path.getOrDefault("accountName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "accountName", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594262 = query.getOrDefault("api-version")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "api-version", valid_594262
  var valid_594263 = query.getOrDefault("$skipToken")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "$skipToken", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_TriggersListByShareSubscription_594255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Triggers in a share subscription
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_TriggersListByShareSubscription_594255;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  add(path_594266, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(query_594267, "$skipToken", newJString(SkipToken))
  add(path_594266, "accountName", newJString(accountName))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var triggersListByShareSubscription* = Call_TriggersListByShareSubscription_594255(
    name: "triggersListByShareSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers",
    validator: validate_TriggersListByShareSubscription_594256, base: "",
    url: url_TriggersListByShareSubscription_594257, schemes: {Scheme.Https})
type
  Call_TriggersCreate_594281 = ref object of OpenApiRestCall_593438
proc url_TriggersCreate_594283(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreate_594282(path: JsonNode; query: JsonNode;
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
  var valid_594284 = path.getOrDefault("resourceGroupName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "resourceGroupName", valid_594284
  var valid_594285 = path.getOrDefault("subscriptionId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "subscriptionId", valid_594285
  var valid_594286 = path.getOrDefault("shareSubscriptionName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "shareSubscriptionName", valid_594286
  var valid_594287 = path.getOrDefault("triggerName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "triggerName", valid_594287
  var valid_594288 = path.getOrDefault("accountName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "accountName", valid_594288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594289 = query.getOrDefault("api-version")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "api-version", valid_594289
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

proc call*(call_594291: Call_TriggersCreate_594281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Trigger 
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_TriggersCreate_594281; resourceGroupName: string;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  var body_594295 = newJObject()
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(query_594294, "api-version", newJString(apiVersion))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  add(path_594293, "shareSubscriptionName", newJString(shareSubscriptionName))
  if trigger != nil:
    body_594295 = trigger
  add(path_594293, "triggerName", newJString(triggerName))
  add(path_594293, "accountName", newJString(accountName))
  result = call_594292.call(path_594293, query_594294, nil, nil, body_594295)

var triggersCreate* = Call_TriggersCreate_594281(name: "triggersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
    validator: validate_TriggersCreate_594282, base: "", url: url_TriggersCreate_594283,
    schemes: {Scheme.Https})
type
  Call_TriggersGet_594268 = ref object of OpenApiRestCall_593438
proc url_TriggersGet_594270(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_594269(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594271 = path.getOrDefault("resourceGroupName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resourceGroupName", valid_594271
  var valid_594272 = path.getOrDefault("subscriptionId")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "subscriptionId", valid_594272
  var valid_594273 = path.getOrDefault("shareSubscriptionName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "shareSubscriptionName", valid_594273
  var valid_594274 = path.getOrDefault("triggerName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "triggerName", valid_594274
  var valid_594275 = path.getOrDefault("accountName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "accountName", valid_594275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594276 = query.getOrDefault("api-version")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "api-version", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_TriggersGet_594268; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Trigger in a shareSubscription
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_TriggersGet_594268; resourceGroupName: string;
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
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  add(path_594279, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_594279, "triggerName", newJString(triggerName))
  add(path_594279, "accountName", newJString(accountName))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var triggersGet* = Call_TriggersGet_594268(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_594269,
                                        base: "", url: url_TriggersGet_594270,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_594296 = ref object of OpenApiRestCall_593438
proc url_TriggersDelete_594298(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_594297(path: JsonNode; query: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("shareSubscriptionName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "shareSubscriptionName", valid_594301
  var valid_594302 = path.getOrDefault("triggerName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "triggerName", valid_594302
  var valid_594303 = path.getOrDefault("accountName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "accountName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594305: Call_TriggersDelete_594296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Trigger in a shareSubscription
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_TriggersDelete_594296; resourceGroupName: string;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  add(path_594307, "shareSubscriptionName", newJString(shareSubscriptionName))
  add(path_594307, "triggerName", newJString(triggerName))
  add(path_594307, "accountName", newJString(accountName))
  result = call_594306.call(path_594307, query_594308, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_594296(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shareSubscriptions/{shareSubscriptionName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_594297, base: "", url: url_TriggersDelete_594298,
    schemes: {Scheme.Https})
type
  Call_SharesListByAccount_594309 = ref object of OpenApiRestCall_593438
proc url_SharesListByAccount_594311(protocol: Scheme; host: string; base: string;
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

proc validate_SharesListByAccount_594310(path: JsonNode; query: JsonNode;
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
  var valid_594312 = path.getOrDefault("resourceGroupName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "resourceGroupName", valid_594312
  var valid_594313 = path.getOrDefault("subscriptionId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "subscriptionId", valid_594313
  var valid_594314 = path.getOrDefault("accountName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "accountName", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation Token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
  var valid_594316 = query.getOrDefault("$skipToken")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "$skipToken", valid_594316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594317: Call_SharesListByAccount_594309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List shares in an account
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_SharesListByAccount_594309; resourceGroupName: string;
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  add(path_594319, "resourceGroupName", newJString(resourceGroupName))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(query_594320, "$skipToken", newJString(SkipToken))
  add(path_594319, "accountName", newJString(accountName))
  result = call_594318.call(path_594319, query_594320, nil, nil, nil)

var sharesListByAccount* = Call_SharesListByAccount_594309(
    name: "sharesListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares",
    validator: validate_SharesListByAccount_594310, base: "",
    url: url_SharesListByAccount_594311, schemes: {Scheme.Https})
type
  Call_SharesCreate_594333 = ref object of OpenApiRestCall_593438
proc url_SharesCreate_594335(protocol: Scheme; host: string; base: string;
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

proc validate_SharesCreate_594334(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594336 = path.getOrDefault("resourceGroupName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "resourceGroupName", valid_594336
  var valid_594337 = path.getOrDefault("subscriptionId")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "subscriptionId", valid_594337
  var valid_594338 = path.getOrDefault("shareName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "shareName", valid_594338
  var valid_594339 = path.getOrDefault("accountName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "accountName", valid_594339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594340 = query.getOrDefault("api-version")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "api-version", valid_594340
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

proc call*(call_594342: Call_SharesCreate_594333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a share 
  ## 
  let valid = call_594342.validator(path, query, header, formData, body)
  let scheme = call_594342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594342.url(scheme.get, call_594342.host, call_594342.base,
                         call_594342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594342, url, valid)

proc call*(call_594343: Call_SharesCreate_594333; resourceGroupName: string;
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
  var path_594344 = newJObject()
  var query_594345 = newJObject()
  var body_594346 = newJObject()
  add(path_594344, "resourceGroupName", newJString(resourceGroupName))
  add(query_594345, "api-version", newJString(apiVersion))
  add(path_594344, "subscriptionId", newJString(subscriptionId))
  add(path_594344, "shareName", newJString(shareName))
  if share != nil:
    body_594346 = share
  add(path_594344, "accountName", newJString(accountName))
  result = call_594343.call(path_594344, query_594345, nil, nil, body_594346)

var sharesCreate* = Call_SharesCreate_594333(name: "sharesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
    validator: validate_SharesCreate_594334, base: "", url: url_SharesCreate_594335,
    schemes: {Scheme.Https})
type
  Call_SharesGet_594321 = ref object of OpenApiRestCall_593438
proc url_SharesGet_594323(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SharesGet_594322(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594324 = path.getOrDefault("resourceGroupName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "resourceGroupName", valid_594324
  var valid_594325 = path.getOrDefault("subscriptionId")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "subscriptionId", valid_594325
  var valid_594326 = path.getOrDefault("shareName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "shareName", valid_594326
  var valid_594327 = path.getOrDefault("accountName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "accountName", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594329: Call_SharesGet_594321; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a share 
  ## 
  let valid = call_594329.validator(path, query, header, formData, body)
  let scheme = call_594329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594329.url(scheme.get, call_594329.host, call_594329.base,
                         call_594329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594329, url, valid)

proc call*(call_594330: Call_SharesGet_594321; resourceGroupName: string;
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
  var path_594331 = newJObject()
  var query_594332 = newJObject()
  add(path_594331, "resourceGroupName", newJString(resourceGroupName))
  add(query_594332, "api-version", newJString(apiVersion))
  add(path_594331, "subscriptionId", newJString(subscriptionId))
  add(path_594331, "shareName", newJString(shareName))
  add(path_594331, "accountName", newJString(accountName))
  result = call_594330.call(path_594331, query_594332, nil, nil, nil)

var sharesGet* = Call_SharesGet_594321(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
                                    validator: validate_SharesGet_594322,
                                    base: "", url: url_SharesGet_594323,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_594347 = ref object of OpenApiRestCall_593438
proc url_SharesDelete_594349(protocol: Scheme; host: string; base: string;
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

proc validate_SharesDelete_594348(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594350 = path.getOrDefault("resourceGroupName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "resourceGroupName", valid_594350
  var valid_594351 = path.getOrDefault("subscriptionId")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "subscriptionId", valid_594351
  var valid_594352 = path.getOrDefault("shareName")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "shareName", valid_594352
  var valid_594353 = path.getOrDefault("accountName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "accountName", valid_594353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594354 = query.getOrDefault("api-version")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "api-version", valid_594354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594355: Call_SharesDelete_594347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a share 
  ## 
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_SharesDelete_594347; resourceGroupName: string;
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
  var path_594357 = newJObject()
  var query_594358 = newJObject()
  add(path_594357, "resourceGroupName", newJString(resourceGroupName))
  add(query_594358, "api-version", newJString(apiVersion))
  add(path_594357, "subscriptionId", newJString(subscriptionId))
  add(path_594357, "shareName", newJString(shareName))
  add(path_594357, "accountName", newJString(accountName))
  result = call_594356.call(path_594357, query_594358, nil, nil, nil)

var sharesDelete* = Call_SharesDelete_594347(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}",
    validator: validate_SharesDelete_594348, base: "", url: url_SharesDelete_594349,
    schemes: {Scheme.Https})
type
  Call_DataSetsListByShare_594359 = ref object of OpenApiRestCall_593438
proc url_DataSetsListByShare_594361(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsListByShare_594360(path: JsonNode; query: JsonNode;
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
  var valid_594362 = path.getOrDefault("resourceGroupName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "resourceGroupName", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  var valid_594364 = path.getOrDefault("shareName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "shareName", valid_594364
  var valid_594365 = path.getOrDefault("accountName")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "accountName", valid_594365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594366 = query.getOrDefault("api-version")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "api-version", valid_594366
  var valid_594367 = query.getOrDefault("$skipToken")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "$skipToken", valid_594367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594368: Call_DataSetsListByShare_594359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List DataSets in a share
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_DataSetsListByShare_594359; resourceGroupName: string;
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
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  add(path_594370, "resourceGroupName", newJString(resourceGroupName))
  add(query_594371, "api-version", newJString(apiVersion))
  add(path_594370, "subscriptionId", newJString(subscriptionId))
  add(path_594370, "shareName", newJString(shareName))
  add(query_594371, "$skipToken", newJString(SkipToken))
  add(path_594370, "accountName", newJString(accountName))
  result = call_594369.call(path_594370, query_594371, nil, nil, nil)

var dataSetsListByShare* = Call_DataSetsListByShare_594359(
    name: "dataSetsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets",
    validator: validate_DataSetsListByShare_594360, base: "",
    url: url_DataSetsListByShare_594361, schemes: {Scheme.Https})
type
  Call_DataSetsCreate_594385 = ref object of OpenApiRestCall_593438
proc url_DataSetsCreate_594387(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsCreate_594386(path: JsonNode; query: JsonNode;
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
  var valid_594388 = path.getOrDefault("resourceGroupName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "resourceGroupName", valid_594388
  var valid_594389 = path.getOrDefault("subscriptionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "subscriptionId", valid_594389
  var valid_594390 = path.getOrDefault("shareName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "shareName", valid_594390
  var valid_594391 = path.getOrDefault("dataSetName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "dataSetName", valid_594391
  var valid_594392 = path.getOrDefault("accountName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "accountName", valid_594392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
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

proc call*(call_594395: Call_DataSetsCreate_594385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a DataSet 
  ## 
  let valid = call_594395.validator(path, query, header, formData, body)
  let scheme = call_594395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594395.url(scheme.get, call_594395.host, call_594395.base,
                         call_594395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594395, url, valid)

proc call*(call_594396: Call_DataSetsCreate_594385; resourceGroupName: string;
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
  var path_594397 = newJObject()
  var query_594398 = newJObject()
  var body_594399 = newJObject()
  add(path_594397, "resourceGroupName", newJString(resourceGroupName))
  add(query_594398, "api-version", newJString(apiVersion))
  if dataSet != nil:
    body_594399 = dataSet
  add(path_594397, "subscriptionId", newJString(subscriptionId))
  add(path_594397, "shareName", newJString(shareName))
  add(path_594397, "dataSetName", newJString(dataSetName))
  add(path_594397, "accountName", newJString(accountName))
  result = call_594396.call(path_594397, query_594398, nil, nil, body_594399)

var dataSetsCreate* = Call_DataSetsCreate_594385(name: "dataSetsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
    validator: validate_DataSetsCreate_594386, base: "", url: url_DataSetsCreate_594387,
    schemes: {Scheme.Https})
type
  Call_DataSetsGet_594372 = ref object of OpenApiRestCall_593438
proc url_DataSetsGet_594374(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsGet_594373(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594375 = path.getOrDefault("resourceGroupName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "resourceGroupName", valid_594375
  var valid_594376 = path.getOrDefault("subscriptionId")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "subscriptionId", valid_594376
  var valid_594377 = path.getOrDefault("shareName")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "shareName", valid_594377
  var valid_594378 = path.getOrDefault("dataSetName")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "dataSetName", valid_594378
  var valid_594379 = path.getOrDefault("accountName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "accountName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594381: Call_DataSetsGet_594372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a DataSet in a share
  ## 
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_DataSetsGet_594372; resourceGroupName: string;
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
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  add(path_594383, "resourceGroupName", newJString(resourceGroupName))
  add(query_594384, "api-version", newJString(apiVersion))
  add(path_594383, "subscriptionId", newJString(subscriptionId))
  add(path_594383, "shareName", newJString(shareName))
  add(path_594383, "dataSetName", newJString(dataSetName))
  add(path_594383, "accountName", newJString(accountName))
  result = call_594382.call(path_594383, query_594384, nil, nil, nil)

var dataSetsGet* = Call_DataSetsGet_594372(name: "dataSetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
                                        validator: validate_DataSetsGet_594373,
                                        base: "", url: url_DataSetsGet_594374,
                                        schemes: {Scheme.Https})
type
  Call_DataSetsDelete_594400 = ref object of OpenApiRestCall_593438
proc url_DataSetsDelete_594402(protocol: Scheme; host: string; base: string;
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

proc validate_DataSetsDelete_594401(path: JsonNode; query: JsonNode;
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
  var valid_594403 = path.getOrDefault("resourceGroupName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "resourceGroupName", valid_594403
  var valid_594404 = path.getOrDefault("subscriptionId")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "subscriptionId", valid_594404
  var valid_594405 = path.getOrDefault("shareName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "shareName", valid_594405
  var valid_594406 = path.getOrDefault("dataSetName")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "dataSetName", valid_594406
  var valid_594407 = path.getOrDefault("accountName")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "accountName", valid_594407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594408 = query.getOrDefault("api-version")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "api-version", valid_594408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594409: Call_DataSetsDelete_594400; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a DataSet in a share
  ## 
  let valid = call_594409.validator(path, query, header, formData, body)
  let scheme = call_594409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594409.url(scheme.get, call_594409.host, call_594409.base,
                         call_594409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594409, url, valid)

proc call*(call_594410: Call_DataSetsDelete_594400; resourceGroupName: string;
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
  var path_594411 = newJObject()
  var query_594412 = newJObject()
  add(path_594411, "resourceGroupName", newJString(resourceGroupName))
  add(query_594412, "api-version", newJString(apiVersion))
  add(path_594411, "subscriptionId", newJString(subscriptionId))
  add(path_594411, "shareName", newJString(shareName))
  add(path_594411, "dataSetName", newJString(dataSetName))
  add(path_594411, "accountName", newJString(accountName))
  result = call_594410.call(path_594411, query_594412, nil, nil, nil)

var dataSetsDelete* = Call_DataSetsDelete_594400(name: "dataSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/dataSets/{dataSetName}",
    validator: validate_DataSetsDelete_594401, base: "", url: url_DataSetsDelete_594402,
    schemes: {Scheme.Https})
type
  Call_InvitationsListByShare_594413 = ref object of OpenApiRestCall_593438
proc url_InvitationsListByShare_594415(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsListByShare_594414(path: JsonNode; query: JsonNode;
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
  var valid_594416 = path.getOrDefault("resourceGroupName")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "resourceGroupName", valid_594416
  var valid_594417 = path.getOrDefault("subscriptionId")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "subscriptionId", valid_594417
  var valid_594418 = path.getOrDefault("shareName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "shareName", valid_594418
  var valid_594419 = path.getOrDefault("accountName")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "accountName", valid_594419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : The continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594420 = query.getOrDefault("api-version")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "api-version", valid_594420
  var valid_594421 = query.getOrDefault("$skipToken")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "$skipToken", valid_594421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594422: Call_InvitationsListByShare_594413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List invitations in a share
  ## 
  let valid = call_594422.validator(path, query, header, formData, body)
  let scheme = call_594422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594422.url(scheme.get, call_594422.host, call_594422.base,
                         call_594422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594422, url, valid)

proc call*(call_594423: Call_InvitationsListByShare_594413;
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
  var path_594424 = newJObject()
  var query_594425 = newJObject()
  add(path_594424, "resourceGroupName", newJString(resourceGroupName))
  add(query_594425, "api-version", newJString(apiVersion))
  add(path_594424, "subscriptionId", newJString(subscriptionId))
  add(path_594424, "shareName", newJString(shareName))
  add(query_594425, "$skipToken", newJString(SkipToken))
  add(path_594424, "accountName", newJString(accountName))
  result = call_594423.call(path_594424, query_594425, nil, nil, nil)

var invitationsListByShare* = Call_InvitationsListByShare_594413(
    name: "invitationsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations",
    validator: validate_InvitationsListByShare_594414, base: "",
    url: url_InvitationsListByShare_594415, schemes: {Scheme.Https})
type
  Call_InvitationsCreate_594439 = ref object of OpenApiRestCall_593438
proc url_InvitationsCreate_594441(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsCreate_594440(path: JsonNode; query: JsonNode;
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
  var valid_594442 = path.getOrDefault("resourceGroupName")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "resourceGroupName", valid_594442
  var valid_594443 = path.getOrDefault("invitationName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "invitationName", valid_594443
  var valid_594444 = path.getOrDefault("subscriptionId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "subscriptionId", valid_594444
  var valid_594445 = path.getOrDefault("shareName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "shareName", valid_594445
  var valid_594446 = path.getOrDefault("accountName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "accountName", valid_594446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594447 = query.getOrDefault("api-version")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "api-version", valid_594447
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

proc call*(call_594449: Call_InvitationsCreate_594439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an invitation 
  ## 
  let valid = call_594449.validator(path, query, header, formData, body)
  let scheme = call_594449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594449.url(scheme.get, call_594449.host, call_594449.base,
                         call_594449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594449, url, valid)

proc call*(call_594450: Call_InvitationsCreate_594439; resourceGroupName: string;
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
  var path_594451 = newJObject()
  var query_594452 = newJObject()
  var body_594453 = newJObject()
  add(path_594451, "resourceGroupName", newJString(resourceGroupName))
  add(query_594452, "api-version", newJString(apiVersion))
  if invitation != nil:
    body_594453 = invitation
  add(path_594451, "invitationName", newJString(invitationName))
  add(path_594451, "subscriptionId", newJString(subscriptionId))
  add(path_594451, "shareName", newJString(shareName))
  add(path_594451, "accountName", newJString(accountName))
  result = call_594450.call(path_594451, query_594452, nil, nil, body_594453)

var invitationsCreate* = Call_InvitationsCreate_594439(name: "invitationsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsCreate_594440, base: "",
    url: url_InvitationsCreate_594441, schemes: {Scheme.Https})
type
  Call_InvitationsGet_594426 = ref object of OpenApiRestCall_593438
proc url_InvitationsGet_594428(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsGet_594427(path: JsonNode; query: JsonNode;
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
  var valid_594429 = path.getOrDefault("resourceGroupName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "resourceGroupName", valid_594429
  var valid_594430 = path.getOrDefault("invitationName")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "invitationName", valid_594430
  var valid_594431 = path.getOrDefault("subscriptionId")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "subscriptionId", valid_594431
  var valid_594432 = path.getOrDefault("shareName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "shareName", valid_594432
  var valid_594433 = path.getOrDefault("accountName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "accountName", valid_594433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594434 = query.getOrDefault("api-version")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "api-version", valid_594434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594435: Call_InvitationsGet_594426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an invitation in a share
  ## 
  let valid = call_594435.validator(path, query, header, formData, body)
  let scheme = call_594435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594435.url(scheme.get, call_594435.host, call_594435.base,
                         call_594435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594435, url, valid)

proc call*(call_594436: Call_InvitationsGet_594426; resourceGroupName: string;
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
  var path_594437 = newJObject()
  var query_594438 = newJObject()
  add(path_594437, "resourceGroupName", newJString(resourceGroupName))
  add(query_594438, "api-version", newJString(apiVersion))
  add(path_594437, "invitationName", newJString(invitationName))
  add(path_594437, "subscriptionId", newJString(subscriptionId))
  add(path_594437, "shareName", newJString(shareName))
  add(path_594437, "accountName", newJString(accountName))
  result = call_594436.call(path_594437, query_594438, nil, nil, nil)

var invitationsGet* = Call_InvitationsGet_594426(name: "invitationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsGet_594427, base: "", url: url_InvitationsGet_594428,
    schemes: {Scheme.Https})
type
  Call_InvitationsDelete_594454 = ref object of OpenApiRestCall_593438
proc url_InvitationsDelete_594456(protocol: Scheme; host: string; base: string;
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

proc validate_InvitationsDelete_594455(path: JsonNode; query: JsonNode;
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
  var valid_594457 = path.getOrDefault("resourceGroupName")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "resourceGroupName", valid_594457
  var valid_594458 = path.getOrDefault("invitationName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "invitationName", valid_594458
  var valid_594459 = path.getOrDefault("subscriptionId")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "subscriptionId", valid_594459
  var valid_594460 = path.getOrDefault("shareName")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "shareName", valid_594460
  var valid_594461 = path.getOrDefault("accountName")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "accountName", valid_594461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594462 = query.getOrDefault("api-version")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "api-version", valid_594462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594463: Call_InvitationsDelete_594454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an invitation in a share
  ## 
  let valid = call_594463.validator(path, query, header, formData, body)
  let scheme = call_594463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594463.url(scheme.get, call_594463.host, call_594463.base,
                         call_594463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594463, url, valid)

proc call*(call_594464: Call_InvitationsDelete_594454; resourceGroupName: string;
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
  var path_594465 = newJObject()
  var query_594466 = newJObject()
  add(path_594465, "resourceGroupName", newJString(resourceGroupName))
  add(query_594466, "api-version", newJString(apiVersion))
  add(path_594465, "invitationName", newJString(invitationName))
  add(path_594465, "subscriptionId", newJString(subscriptionId))
  add(path_594465, "shareName", newJString(shareName))
  add(path_594465, "accountName", newJString(accountName))
  result = call_594464.call(path_594465, query_594466, nil, nil, nil)

var invitationsDelete* = Call_InvitationsDelete_594454(name: "invitationsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/invitations/{invitationName}",
    validator: validate_InvitationsDelete_594455, base: "",
    url: url_InvitationsDelete_594456, schemes: {Scheme.Https})
type
  Call_SharesListSynchronizationDetails_594467 = ref object of OpenApiRestCall_593438
proc url_SharesListSynchronizationDetails_594469(protocol: Scheme; host: string;
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

proc validate_SharesListSynchronizationDetails_594468(path: JsonNode;
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
  var valid_594470 = path.getOrDefault("resourceGroupName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "resourceGroupName", valid_594470
  var valid_594471 = path.getOrDefault("subscriptionId")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "subscriptionId", valid_594471
  var valid_594472 = path.getOrDefault("shareName")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "shareName", valid_594472
  var valid_594473 = path.getOrDefault("accountName")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "accountName", valid_594473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594474 = query.getOrDefault("api-version")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "api-version", valid_594474
  var valid_594475 = query.getOrDefault("$skipToken")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "$skipToken", valid_594475
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

proc call*(call_594477: Call_SharesListSynchronizationDetails_594467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronization details
  ## 
  let valid = call_594477.validator(path, query, header, formData, body)
  let scheme = call_594477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594477.url(scheme.get, call_594477.host, call_594477.base,
                         call_594477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594477, url, valid)

proc call*(call_594478: Call_SharesListSynchronizationDetails_594467;
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
  var path_594479 = newJObject()
  var query_594480 = newJObject()
  var body_594481 = newJObject()
  add(path_594479, "resourceGroupName", newJString(resourceGroupName))
  add(query_594480, "api-version", newJString(apiVersion))
  add(path_594479, "subscriptionId", newJString(subscriptionId))
  add(path_594479, "shareName", newJString(shareName))
  if shareSynchronization != nil:
    body_594481 = shareSynchronization
  add(query_594480, "$skipToken", newJString(SkipToken))
  add(path_594479, "accountName", newJString(accountName))
  result = call_594478.call(path_594479, query_594480, nil, nil, body_594481)

var sharesListSynchronizationDetails* = Call_SharesListSynchronizationDetails_594467(
    name: "sharesListSynchronizationDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/listSynchronizationDetails",
    validator: validate_SharesListSynchronizationDetails_594468, base: "",
    url: url_SharesListSynchronizationDetails_594469, schemes: {Scheme.Https})
type
  Call_SharesListSynchronizations_594482 = ref object of OpenApiRestCall_593438
proc url_SharesListSynchronizations_594484(protocol: Scheme; host: string;
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

proc validate_SharesListSynchronizations_594483(path: JsonNode; query: JsonNode;
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
  var valid_594485 = path.getOrDefault("resourceGroupName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "resourceGroupName", valid_594485
  var valid_594486 = path.getOrDefault("subscriptionId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "subscriptionId", valid_594486
  var valid_594487 = path.getOrDefault("shareName")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "shareName", valid_594487
  var valid_594488 = path.getOrDefault("accountName")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "accountName", valid_594488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594489 = query.getOrDefault("api-version")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "api-version", valid_594489
  var valid_594490 = query.getOrDefault("$skipToken")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "$skipToken", valid_594490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594491: Call_SharesListSynchronizations_594482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List synchronizations of a share
  ## 
  let valid = call_594491.validator(path, query, header, formData, body)
  let scheme = call_594491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594491.url(scheme.get, call_594491.host, call_594491.base,
                         call_594491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594491, url, valid)

proc call*(call_594492: Call_SharesListSynchronizations_594482;
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
  var path_594493 = newJObject()
  var query_594494 = newJObject()
  add(path_594493, "resourceGroupName", newJString(resourceGroupName))
  add(query_594494, "api-version", newJString(apiVersion))
  add(path_594493, "subscriptionId", newJString(subscriptionId))
  add(path_594493, "shareName", newJString(shareName))
  add(query_594494, "$skipToken", newJString(SkipToken))
  add(path_594493, "accountName", newJString(accountName))
  result = call_594492.call(path_594493, query_594494, nil, nil, nil)

var sharesListSynchronizations* = Call_SharesListSynchronizations_594482(
    name: "sharesListSynchronizations", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/listSynchronizations",
    validator: validate_SharesListSynchronizations_594483, base: "",
    url: url_SharesListSynchronizations_594484, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsListByShare_594495 = ref object of OpenApiRestCall_593438
proc url_ProviderShareSubscriptionsListByShare_594497(protocol: Scheme;
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

proc validate_ProviderShareSubscriptionsListByShare_594496(path: JsonNode;
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
  var valid_594498 = path.getOrDefault("resourceGroupName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "resourceGroupName", valid_594498
  var valid_594499 = path.getOrDefault("subscriptionId")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "subscriptionId", valid_594499
  var valid_594500 = path.getOrDefault("shareName")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "shareName", valid_594500
  var valid_594501 = path.getOrDefault("accountName")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "accountName", valid_594501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : Continuation Token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594502 = query.getOrDefault("api-version")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "api-version", valid_594502
  var valid_594503 = query.getOrDefault("$skipToken")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "$skipToken", valid_594503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594504: Call_ProviderShareSubscriptionsListByShare_594495;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List share subscriptions in a provider share
  ## 
  let valid = call_594504.validator(path, query, header, formData, body)
  let scheme = call_594504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594504.url(scheme.get, call_594504.host, call_594504.base,
                         call_594504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594504, url, valid)

proc call*(call_594505: Call_ProviderShareSubscriptionsListByShare_594495;
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
  var path_594506 = newJObject()
  var query_594507 = newJObject()
  add(path_594506, "resourceGroupName", newJString(resourceGroupName))
  add(query_594507, "api-version", newJString(apiVersion))
  add(path_594506, "subscriptionId", newJString(subscriptionId))
  add(path_594506, "shareName", newJString(shareName))
  add(query_594507, "$skipToken", newJString(SkipToken))
  add(path_594506, "accountName", newJString(accountName))
  result = call_594505.call(path_594506, query_594507, nil, nil, nil)

var providerShareSubscriptionsListByShare* = Call_ProviderShareSubscriptionsListByShare_594495(
    name: "providerShareSubscriptionsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions",
    validator: validate_ProviderShareSubscriptionsListByShare_594496, base: "",
    url: url_ProviderShareSubscriptionsListByShare_594497, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsGetByShare_594508 = ref object of OpenApiRestCall_593438
proc url_ProviderShareSubscriptionsGetByShare_594510(protocol: Scheme;
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

proc validate_ProviderShareSubscriptionsGetByShare_594509(path: JsonNode;
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
  var valid_594511 = path.getOrDefault("resourceGroupName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "resourceGroupName", valid_594511
  var valid_594512 = path.getOrDefault("subscriptionId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "subscriptionId", valid_594512
  var valid_594513 = path.getOrDefault("shareName")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "shareName", valid_594513
  var valid_594514 = path.getOrDefault("providerShareSubscriptionId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "providerShareSubscriptionId", valid_594514
  var valid_594515 = path.getOrDefault("accountName")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "accountName", valid_594515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594516 = query.getOrDefault("api-version")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "api-version", valid_594516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594517: Call_ProviderShareSubscriptionsGetByShare_594508;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get share subscription in a provider share
  ## 
  let valid = call_594517.validator(path, query, header, formData, body)
  let scheme = call_594517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594517.url(scheme.get, call_594517.host, call_594517.base,
                         call_594517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594517, url, valid)

proc call*(call_594518: Call_ProviderShareSubscriptionsGetByShare_594508;
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
  var path_594519 = newJObject()
  var query_594520 = newJObject()
  add(path_594519, "resourceGroupName", newJString(resourceGroupName))
  add(query_594520, "api-version", newJString(apiVersion))
  add(path_594519, "subscriptionId", newJString(subscriptionId))
  add(path_594519, "shareName", newJString(shareName))
  add(path_594519, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_594519, "accountName", newJString(accountName))
  result = call_594518.call(path_594519, query_594520, nil, nil, nil)

var providerShareSubscriptionsGetByShare* = Call_ProviderShareSubscriptionsGetByShare_594508(
    name: "providerShareSubscriptionsGetByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}",
    validator: validate_ProviderShareSubscriptionsGetByShare_594509, base: "",
    url: url_ProviderShareSubscriptionsGetByShare_594510, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsReinstate_594521 = ref object of OpenApiRestCall_593438
proc url_ProviderShareSubscriptionsReinstate_594523(protocol: Scheme; host: string;
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

proc validate_ProviderShareSubscriptionsReinstate_594522(path: JsonNode;
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
  var valid_594524 = path.getOrDefault("resourceGroupName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "resourceGroupName", valid_594524
  var valid_594525 = path.getOrDefault("subscriptionId")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "subscriptionId", valid_594525
  var valid_594526 = path.getOrDefault("shareName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "shareName", valid_594526
  var valid_594527 = path.getOrDefault("providerShareSubscriptionId")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "providerShareSubscriptionId", valid_594527
  var valid_594528 = path.getOrDefault("accountName")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "accountName", valid_594528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594529 = query.getOrDefault("api-version")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "api-version", valid_594529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594530: Call_ProviderShareSubscriptionsReinstate_594521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reinstate share subscription in a provider share
  ## 
  let valid = call_594530.validator(path, query, header, formData, body)
  let scheme = call_594530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594530.url(scheme.get, call_594530.host, call_594530.base,
                         call_594530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594530, url, valid)

proc call*(call_594531: Call_ProviderShareSubscriptionsReinstate_594521;
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
  var path_594532 = newJObject()
  var query_594533 = newJObject()
  add(path_594532, "resourceGroupName", newJString(resourceGroupName))
  add(query_594533, "api-version", newJString(apiVersion))
  add(path_594532, "subscriptionId", newJString(subscriptionId))
  add(path_594532, "shareName", newJString(shareName))
  add(path_594532, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_594532, "accountName", newJString(accountName))
  result = call_594531.call(path_594532, query_594533, nil, nil, nil)

var providerShareSubscriptionsReinstate* = Call_ProviderShareSubscriptionsReinstate_594521(
    name: "providerShareSubscriptionsReinstate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}/reinstate",
    validator: validate_ProviderShareSubscriptionsReinstate_594522, base: "",
    url: url_ProviderShareSubscriptionsReinstate_594523, schemes: {Scheme.Https})
type
  Call_ProviderShareSubscriptionsRevoke_594534 = ref object of OpenApiRestCall_593438
proc url_ProviderShareSubscriptionsRevoke_594536(protocol: Scheme; host: string;
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

proc validate_ProviderShareSubscriptionsRevoke_594535(path: JsonNode;
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
  var valid_594537 = path.getOrDefault("resourceGroupName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "resourceGroupName", valid_594537
  var valid_594538 = path.getOrDefault("subscriptionId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "subscriptionId", valid_594538
  var valid_594539 = path.getOrDefault("shareName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "shareName", valid_594539
  var valid_594540 = path.getOrDefault("providerShareSubscriptionId")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "providerShareSubscriptionId", valid_594540
  var valid_594541 = path.getOrDefault("accountName")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "accountName", valid_594541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594542 = query.getOrDefault("api-version")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "api-version", valid_594542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594543: Call_ProviderShareSubscriptionsRevoke_594534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke share subscription in a provider share
  ## 
  let valid = call_594543.validator(path, query, header, formData, body)
  let scheme = call_594543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594543.url(scheme.get, call_594543.host, call_594543.base,
                         call_594543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594543, url, valid)

proc call*(call_594544: Call_ProviderShareSubscriptionsRevoke_594534;
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
  var path_594545 = newJObject()
  var query_594546 = newJObject()
  add(path_594545, "resourceGroupName", newJString(resourceGroupName))
  add(query_594546, "api-version", newJString(apiVersion))
  add(path_594545, "subscriptionId", newJString(subscriptionId))
  add(path_594545, "shareName", newJString(shareName))
  add(path_594545, "providerShareSubscriptionId",
      newJString(providerShareSubscriptionId))
  add(path_594545, "accountName", newJString(accountName))
  result = call_594544.call(path_594545, query_594546, nil, nil, nil)

var providerShareSubscriptionsRevoke* = Call_ProviderShareSubscriptionsRevoke_594534(
    name: "providerShareSubscriptionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/providerShareSubscriptions/{providerShareSubscriptionId}/revoke",
    validator: validate_ProviderShareSubscriptionsRevoke_594535, base: "",
    url: url_ProviderShareSubscriptionsRevoke_594536, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsListByShare_594547 = ref object of OpenApiRestCall_593438
proc url_SynchronizationSettingsListByShare_594549(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsListByShare_594548(path: JsonNode;
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
  var valid_594550 = path.getOrDefault("resourceGroupName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "resourceGroupName", valid_594550
  var valid_594551 = path.getOrDefault("subscriptionId")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "subscriptionId", valid_594551
  var valid_594552 = path.getOrDefault("shareName")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "shareName", valid_594552
  var valid_594553 = path.getOrDefault("accountName")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "accountName", valid_594553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  ##   $skipToken: JString
  ##             : continuation token
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594554 = query.getOrDefault("api-version")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "api-version", valid_594554
  var valid_594555 = query.getOrDefault("$skipToken")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "$skipToken", valid_594555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594556: Call_SynchronizationSettingsListByShare_594547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List synchronizationSettings in a share
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_SynchronizationSettingsListByShare_594547;
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
  var path_594558 = newJObject()
  var query_594559 = newJObject()
  add(path_594558, "resourceGroupName", newJString(resourceGroupName))
  add(query_594559, "api-version", newJString(apiVersion))
  add(path_594558, "subscriptionId", newJString(subscriptionId))
  add(path_594558, "shareName", newJString(shareName))
  add(query_594559, "$skipToken", newJString(SkipToken))
  add(path_594558, "accountName", newJString(accountName))
  result = call_594557.call(path_594558, query_594559, nil, nil, nil)

var synchronizationSettingsListByShare* = Call_SynchronizationSettingsListByShare_594547(
    name: "synchronizationSettingsListByShare", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings",
    validator: validate_SynchronizationSettingsListByShare_594548, base: "",
    url: url_SynchronizationSettingsListByShare_594549, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsCreate_594573 = ref object of OpenApiRestCall_593438
proc url_SynchronizationSettingsCreate_594575(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsCreate_594574(path: JsonNode; query: JsonNode;
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
  var valid_594576 = path.getOrDefault("resourceGroupName")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "resourceGroupName", valid_594576
  var valid_594577 = path.getOrDefault("synchronizationSettingName")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "synchronizationSettingName", valid_594577
  var valid_594578 = path.getOrDefault("subscriptionId")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "subscriptionId", valid_594578
  var valid_594579 = path.getOrDefault("shareName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "shareName", valid_594579
  var valid_594580 = path.getOrDefault("accountName")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "accountName", valid_594580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594581 = query.getOrDefault("api-version")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "api-version", valid_594581
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

proc call*(call_594583: Call_SynchronizationSettingsCreate_594573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a synchronizationSetting 
  ## 
  let valid = call_594583.validator(path, query, header, formData, body)
  let scheme = call_594583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594583.url(scheme.get, call_594583.host, call_594583.base,
                         call_594583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594583, url, valid)

proc call*(call_594584: Call_SynchronizationSettingsCreate_594573;
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
  var path_594585 = newJObject()
  var query_594586 = newJObject()
  var body_594587 = newJObject()
  add(path_594585, "resourceGroupName", newJString(resourceGroupName))
  add(path_594585, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(query_594586, "api-version", newJString(apiVersion))
  add(path_594585, "subscriptionId", newJString(subscriptionId))
  add(path_594585, "shareName", newJString(shareName))
  if synchronizationSetting != nil:
    body_594587 = synchronizationSetting
  add(path_594585, "accountName", newJString(accountName))
  result = call_594584.call(path_594585, query_594586, nil, nil, body_594587)

var synchronizationSettingsCreate* = Call_SynchronizationSettingsCreate_594573(
    name: "synchronizationSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsCreate_594574, base: "",
    url: url_SynchronizationSettingsCreate_594575, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsGet_594560 = ref object of OpenApiRestCall_593438
proc url_SynchronizationSettingsGet_594562(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsGet_594561(path: JsonNode; query: JsonNode;
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
  var valid_594563 = path.getOrDefault("resourceGroupName")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "resourceGroupName", valid_594563
  var valid_594564 = path.getOrDefault("synchronizationSettingName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "synchronizationSettingName", valid_594564
  var valid_594565 = path.getOrDefault("subscriptionId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "subscriptionId", valid_594565
  var valid_594566 = path.getOrDefault("shareName")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "shareName", valid_594566
  var valid_594567 = path.getOrDefault("accountName")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "accountName", valid_594567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594568 = query.getOrDefault("api-version")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "api-version", valid_594568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594569: Call_SynchronizationSettingsGet_594560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a synchronizationSetting in a share
  ## 
  let valid = call_594569.validator(path, query, header, formData, body)
  let scheme = call_594569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594569.url(scheme.get, call_594569.host, call_594569.base,
                         call_594569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594569, url, valid)

proc call*(call_594570: Call_SynchronizationSettingsGet_594560;
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
  var path_594571 = newJObject()
  var query_594572 = newJObject()
  add(path_594571, "resourceGroupName", newJString(resourceGroupName))
  add(path_594571, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(query_594572, "api-version", newJString(apiVersion))
  add(path_594571, "subscriptionId", newJString(subscriptionId))
  add(path_594571, "shareName", newJString(shareName))
  add(path_594571, "accountName", newJString(accountName))
  result = call_594570.call(path_594571, query_594572, nil, nil, nil)

var synchronizationSettingsGet* = Call_SynchronizationSettingsGet_594560(
    name: "synchronizationSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsGet_594561, base: "",
    url: url_SynchronizationSettingsGet_594562, schemes: {Scheme.Https})
type
  Call_SynchronizationSettingsDelete_594588 = ref object of OpenApiRestCall_593438
proc url_SynchronizationSettingsDelete_594590(protocol: Scheme; host: string;
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

proc validate_SynchronizationSettingsDelete_594589(path: JsonNode; query: JsonNode;
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
  var valid_594591 = path.getOrDefault("resourceGroupName")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "resourceGroupName", valid_594591
  var valid_594592 = path.getOrDefault("synchronizationSettingName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "synchronizationSettingName", valid_594592
  var valid_594593 = path.getOrDefault("subscriptionId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "subscriptionId", valid_594593
  var valid_594594 = path.getOrDefault("shareName")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "shareName", valid_594594
  var valid_594595 = path.getOrDefault("accountName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "accountName", valid_594595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594596 = query.getOrDefault("api-version")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "api-version", valid_594596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594597: Call_SynchronizationSettingsDelete_594588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a synchronizationSetting in a share
  ## 
  let valid = call_594597.validator(path, query, header, formData, body)
  let scheme = call_594597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594597.url(scheme.get, call_594597.host, call_594597.base,
                         call_594597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594597, url, valid)

proc call*(call_594598: Call_SynchronizationSettingsDelete_594588;
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
  var path_594599 = newJObject()
  var query_594600 = newJObject()
  add(path_594599, "resourceGroupName", newJString(resourceGroupName))
  add(path_594599, "synchronizationSettingName",
      newJString(synchronizationSettingName))
  add(query_594600, "api-version", newJString(apiVersion))
  add(path_594599, "subscriptionId", newJString(subscriptionId))
  add(path_594599, "shareName", newJString(shareName))
  add(path_594599, "accountName", newJString(accountName))
  result = call_594598.call(path_594599, query_594600, nil, nil, nil)

var synchronizationSettingsDelete* = Call_SynchronizationSettingsDelete_594588(
    name: "synchronizationSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataShare/accounts/{accountName}/shares/{shareName}/synchronizationSettings/{synchronizationSettingName}",
    validator: validate_SynchronizationSettingsDelete_594589, base: "",
    url: url_SynchronizationSettingsDelete_594590, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
