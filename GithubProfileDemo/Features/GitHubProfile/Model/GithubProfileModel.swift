//
//  GithubProfile.swift
//  GithubProfileDemo
//
//  Created by Kazu on 18/9/24.
//

import Foundation


struct GithubProfileModel: Codable, Hashable {
    let login: String
    let id: Int
    let nodeID: String
    let url, reposURL, eventsURL, hooksURL: String
    let issuesURL: String
    let membersURL, publicMembersURL: String
    let avatarURL: String
    let description, name: String
    let company: String?
    let blog: String
    let location, email, twitterUsername: String
    let isVerified, hasOrganizationProjects, hasRepositoryProjects: Bool
    let publicRepos, publicGists, followers, following: Int
    let htmlURL: String
    let createdAt, updatedAt: String
    let archivedAt: Date?
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case url
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case hooksURL = "hooks_url"
        case issuesURL = "issues_url"
        case membersURL = "members_url"
        case publicMembersURL = "public_members_url"
        case avatarURL = "avatar_url"
        case description, name, company, blog, location, email
        case twitterUsername = "twitter_username"
        case isVerified = "is_verified"
        case hasOrganizationProjects = "has_organization_projects"
        case hasRepositoryProjects = "has_repository_projects"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case htmlURL = "html_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case archivedAt = "archived_at"
        case type
    }
}
